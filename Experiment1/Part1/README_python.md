# Experiment 1 / Part 1 plotting (Python)

## Setup

```bash
cd Experiment1/Part1
python -m venv .venv
# Windows: .venv\Scripts\activate
# macOS/Linux:
source .venv/bin/activate
pip install -r requirements.txt
```

## Run

```bash
python plot_vsw_metrics.py
```

## Outputs

- `Experiment1/Part1/python_out/*_edges.png` : annotated rising/falling edge plots
- `Experiment1/Part1/python_out/metrics_summary.csv` : extracted metrics

## Notes

- The script expects Tektronix CSV exports with a header row `TIME,CH1,CH2`.
- The time windows are taken from `Waveform_Reader_E1_part1.m`.
- If you want the script to automatically detect the edge windows instead of using fixed windows, tell me and I will modify it.
