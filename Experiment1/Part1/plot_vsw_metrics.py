"""Experiment 1 / Part 1: Switching node (Vsw) waveform plotting and edge metrics.

This script reads Tektronix MSO CSV exports (like the files in
Experiment1/Part1/logs/*_ALL.csv) and generates, for each CSV:

- A plot of Vsw vs time (ns)
- Markers for 10% and 90% points on the rising edge (tr, 10-90%)
- Markers for 90% and 10% points on the falling edge (tf, 90-10%)
- Markers for Vpk+ (max) and Vpk- (min) within the selected windows

Outputs:
- PNG plots under Experiment1/Part1/python_out/
- A summary CSV (metrics_summary.csv)

Usage:
  python Experiment1/Part1/plot_vsw_metrics.py

Dependencies:
  pip install numpy pandas matplotlib

Notes:
- The MATLAB file Waveform_Reader_E1_part1.m uses manually-chosen time windows
  for each probe to isolate rising/falling edges. This script uses the same
  default windows.
- If you want fully automatic edge window detection, tell me and I can add it,
  but using fixed windows is more robust for noisy ringing waveforms.
"""

from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


@dataclass(frozen=True)
class EdgeWindows:
    # Seconds
    t_rise_start: float
    t_rise_end: float
    t_fall_start: float
    t_fall_end: float
    # expected low/high steady levels for thresholds (Volts)
    v_low: float
    v_high: float


# Default windows copied from Experiment1/Part1/Waveform_Reader_E1_part1.m
WINDOWS: dict[str, EdgeWindows] = {
    # Differential Probe Pico High-Z (T1)
    "1.sw,esl,pico_ALL.csv": EdgeWindows(
        t_rise_start=1.1e-7,
        t_rise_end=4.1e-7,
        t_fall_start=5.9e-7,
        t_fall_end=8.9e-7,
        v_low=0.0,
        v_high=25.0,
    ),
    # Passive Probe with Spring Clip High-Z (T2)
    "2.sw,esl,tpp1000_ALL.csv": EdgeWindows(
        t_rise_start=3.02e-7,
        t_rise_end=6.02e-7,
        t_fall_start=7.9e-7,
        t_fall_end=10.9e-7,
        v_low=0.0,
        v_high=24.0,
    ),
    # Passive Probe with Spring Clip High-Z (T3) - file exists in logs
    "2.sw,spring,tpp1000_ALL.csv": EdgeWindows(
        t_rise_start=3.02e-7,
        t_rise_end=6.02e-7,
        t_fall_start=7.9e-7,
        t_fall_end=10.9e-7,
        v_low=0.0,
        v_high=24.0,
    ),
    # Passive Probe with Low-Z (T4)
    "3.sw,lowZ_ALL.csv": EdgeWindows(
        t_rise_start=1.08e-7,
        t_rise_end=4.08e-7,
        t_fall_start=5.9e-7,
        t_fall_end=8.9e-7,
        v_low=0.0,
        v_high=25.0,
    ),
    # Passive Probe High Voltage (T5)
    "4.sw,P2000A,GaN_ALL.csv": EdgeWindows(
        t_rise_start=0.44e-7,
        t_rise_end=3.44e-7,
        t_fall_start=5.25e-7,
        t_fall_end=8.25e-7,
        v_low=0.0,
        v_high=25.0,
    ),
}


def read_tektronix_csv(path: Path) -> pd.DataFrame:
    """Read Tektronix CSV export.

    File structure (example): metadata header, then line with "TIME,CH1,CH2".
    We parse from that line forward.
    """

    # Find the header line index containing TIME
    with path.open("r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()

    header_idx = None
    for i, line in enumerate(lines):
        if line.strip().startswith("TIME"):
            header_idx = i
            break

    if header_idx is None:
        raise ValueError(f"Could not find TIME header in {path}")

    df = pd.read_csv(path, skiprows=header_idx)

    # Normalize column names
    df.columns = [c.strip() for c in df.columns]

    # Keep only numeric rows (sometimes there are trailing blanks)
    df = df.dropna(subset=["TIME"]).copy()

    # Ensure numeric
    for c in df.columns:
        df[c] = pd.to_numeric(df[c], errors="coerce")

    df = df.dropna(subset=["TIME"]).reset_index(drop=True)

    return df


def _interp_crossing_time(t: np.ndarray, v: np.ndarray, level: float) -> float:
    """Linear interpolation for the time when v crosses 'level'.

    Assumes there is at least one crossing in the provided segment.
    """
    # Find sign changes of (v - level)
    y = v - level
    s = np.sign(y)
    idx = np.where(np.diff(s) != 0)[0]
    if len(idx) == 0:
        # fall back: closest point
        j = int(np.argmin(np.abs(y)))
        return float(t[j])

    i = int(idx[0])
    t0, t1 = t[i], t[i + 1]
    y0, y1 = y[i], y[i + 1]
    # Avoid divide by zero
    if y1 == y0:
        return float(t0)
    return float(t0 + (0 - y0) * (t1 - t0) / (y1 - y0))


def compute_edge_metrics(time_s: np.ndarray, vsw_v: np.ndarray, w: EdgeWindows):
    """Compute tr/tf, threshold times, Vpk+ and Vpk- using configured windows."""

    # Rising window
    rise_mask = (time_s >= w.t_rise_start) & (time_s <= w.t_rise_end)
    t_rise = time_s[rise_mask]
    v_rise = vsw_v[rise_mask]

    # Falling window
    fall_mask = (time_s >= w.t_fall_start) & (time_s <= w.t_fall_end)
    t_fall = time_s[fall_mask]
    v_fall = vsw_v[fall_mask]

    if len(t_rise) < 2 or len(t_fall) < 2:
        raise ValueError("Edge window too small; adjust windows.")

    v10 = w.v_low + 0.1 * (w.v_high - w.v_low)
    v90 = w.v_low + 0.9 * (w.v_high - w.v_low)

    # Rising: 10% then 90%
    t10_r = _interp_crossing_time(t_rise, v_rise, v10)
    t90_r = _interp_crossing_time(t_rise, v_rise, v90)
    tr = t90_r - t10_r

    # Falling: 90% then 10%
    # For falling, ensure the search segment starts at higher values ideally; interpolation still works.
    t90_f = _interp_crossing_time(t_fall, v_fall, v90)
    t10_f = _interp_crossing_time(t_fall, v_fall, v10)
    tf = t10_f - t90_f

    # Peaks within windows
    vpk_plus = float(np.nanmax(v_rise))
    t_vpk_plus = float(t_rise[int(np.nanargmax(v_rise))])

    vpk_minus = float(np.nanmin(v_fall))
    t_vpk_minus = float(t_fall[int(np.nanargmin(v_fall))])

    return {
        "v10": float(v10),
        "v90": float(v90),
        "t10_r": float(t10_r),
        "t90_r": float(t90_r),
        "tr": float(tr),
        "t90_f": float(t90_f),
        "t10_f": float(t10_f),
        "tf": float(tf),
        "vpk_plus": vpk_plus,
        "t_vpk_plus": t_vpk_plus,
        "vpk_minus": vpk_minus,
        "t_vpk_minus": t_vpk_minus,
    }


def plot_with_annotations(
    *,
    name: str,
    time_s: np.ndarray,
    vsw_v: np.ndarray,
    w: EdgeWindows,
    metrics: dict,
    out_dir: Path,
):
    """Generate a two-panel plot (rising / falling) with annotations."""

    out_dir.mkdir(parents=True, exist_ok=True)

    # Build edge windows again for plotting
    rise_mask = (time_s >= w.t_rise_start) & (time_s <= w.t_rise_end)
    fall_mask = (time_s >= w.t_fall_start) & (time_s <= w.t_fall_end)

    t_rise_ns = (time_s[rise_mask] - w.t_rise_start) * 1e9
    v_rise = vsw_v[rise_mask]

    t_fall_ns = (time_s[fall_mask] - w.t_fall_start) * 1e9
    v_fall = vsw_v[fall_mask]

    fig, axes = plt.subplots(1, 2, figsize=(12, 4), constrained_layout=True)

    # Rising
    ax = axes[0]
    ax.plot(t_rise_ns, v_rise, linewidth=1.6)

    # Mark 10% and 90%
    t10_r_ns = (metrics["t10_r"] - w.t_rise_start) * 1e9
    t90_r_ns = (metrics["t90_r"] - w.t_rise_start) * 1e9
    ax.plot([t10_r_ns, t90_r_ns], [metrics["v10"], metrics["v90"]], "--", linewidth=1.2)
    ax.scatter([t10_r_ns, t90_r_ns], [metrics["v10"], metrics["v90"]], s=35)

    # Peak+
    tpkp_ns = (metrics["t_vpk_plus"] - w.t_rise_start) * 1e9
    ax.scatter([tpkp_ns], [metrics["vpk_plus"]], s=45)

    ax.set_title("Rising edge")
    ax.set_xlabel("Time [ns]")
    ax.set_ylabel("Vsw [V]")
    ax.grid(True, which="both", alpha=0.3)

    ax.text(
        0.02,
        0.98,
        f"tr(10–90%) = {metrics['tr']*1e9:.2f} ns\nVpk+ = {metrics['vpk_plus']:.2f} V",
        transform=ax.transAxes,
        va="top",
        ha="left",
        fontsize=9,
        bbox=dict(boxstyle="round", facecolor="white", alpha=0.8),
    )

    # Falling
    ax = axes[1]
    ax.plot(t_fall_ns, v_fall, linewidth=1.6)

    t90_f_ns = (metrics["t90_f"] - w.t_fall_start) * 1e9
    t10_f_ns = (metrics["t10_f"] - w.t_fall_start) * 1e9
    ax.plot([t90_f_ns, t10_f_ns], [metrics["v90"], metrics["v10"]], "--", linewidth=1.2)
    ax.scatter([t90_f_ns, t10_f_ns], [metrics["v90"], metrics["v10"]], s=35)

    # Peak-
    tpkm_ns = (metrics["t_vpk_minus"] - w.t_fall_start) * 1e9
    ax.scatter([tpkm_ns], [metrics["vpk_minus"]], s=45)

    ax.set_title("Falling edge")
    ax.set_xlabel("Time [ns]")
    ax.set_ylabel("Vsw [V]")
    ax.grid(True, which="both", alpha=0.3)

    ax.text(
        0.02,
        0.98,
        f"tf(90–10%) = {metrics['tf']*1e9:.2f} ns\nVpk- = {metrics['vpk_minus']:.2f} V",
        transform=ax.transAxes,
        va="top",
        ha="left",
        fontsize=9,
        bbox=dict(boxstyle="round", facecolor="white", alpha=0.8),
    )

    fig.suptitle(name)

    png_path = out_dir / f"{Path(name).stem}_edges.png"
    fig.savefig(png_path, dpi=200)
    plt.close(fig)


def main():
    repo_root = Path(__file__).resolve().parents[2]
    logs_dir = repo_root / "Experiment1" / "Part1" / "logs"
    out_dir = repo_root / "Experiment1" / "Part1" / "python_out"

    if not logs_dir.exists():
        raise SystemExit(f"Logs dir not found: {logs_dir}")

    summary_rows = []

    for csv_path in sorted(logs_dir.glob("*.csv")):
        name = csv_path.name
        if name not in WINDOWS:
            # Skip unknown CSVs but keep it obvious
            print(f"[skip] No window config for {name}")
            continue

        print(f"[read] {name}")
        df = read_tektronix_csv(csv_path)

        # Choose CH1 by default as Vsw (based on file inspected: TIME,CH1,CH2)
        if "CH1" not in df.columns:
            raise ValueError(f"Expected CH1 column in {csv_path}, got {df.columns}")

        time_s = df["TIME"].to_numpy(dtype=float)
        vsw_v = df["CH1"].to_numpy(dtype=float)

        w = WINDOWS[name]
        metrics = compute_edge_metrics(time_s, vsw_v, w)

        plot_with_annotations(
            name=name,
            time_s=time_s,
            vsw_v=vsw_v,
            w=w,
            metrics=metrics,
            out_dir=out_dir,
        )

        summary_rows.append(
            {
                "file": name,
                "tr_ns": metrics["tr"] * 1e9,
                "tf_ns": metrics["tf"] * 1e9,
                "vpk_plus_V": metrics["vpk_plus"],
                "vpk_minus_V": metrics["vpk_minus"],
                "v10_V": metrics["v10"],
                "v90_V": metrics["v90"],
            }
        )

    if summary_rows:
        out_dir.mkdir(parents=True, exist_ok=True)
        summary_df = pd.DataFrame(summary_rows)
        summary_path = out_dir / "metrics_summary.csv"
        summary_df.to_csv(summary_path, index=False)
        print(f"[ok] Wrote {summary_path}")

    print(f"[ok] Plots in {out_dir}")


if __name__ == "__main__":
    # Make matplotlib deterministic-ish
    plt.rcParams.update({
        "figure.dpi": 120,
        "savefig.dpi": 200,
        "font.size": 10,
        "axes.titlesize": 11,
        "axes.labelsize": 10,
    })

    main()
