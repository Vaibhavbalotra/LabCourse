clc;
clear;
close all;

%% .csv
T1_file = './Part_1/1.sw,esl,pico_ALL.csv';
T2_file = './Part_1/2.sw,esl,tpp1000_ALL.csv';
T3_file = './Part_1/2.sw,spring,tpp1000_ALL.csv';
T4_file = './Part_1/3.sw,lowZ_ALL.csv';
T5_file = './Part_1/4.sw,P2000A,GaN_ALL.csv';

opts = detectImportOptions(T1_file);
opts.VariableNamesLine = 17;
opts.DataLines = [18, Inf];
T1 = readtable(T1_file, opts);
opts = detectImportOptions(T2_file);
opts.VariableNamesLine = 17;
opts.DataLines = [18, Inf];
T2 = readtable(T2_file, opts);
opts = detectImportOptions(T3_file);
opts.VariableNamesLine = 17;
opts.DataLines = [18, Inf];
T3 = readtable(T3_file, opts);
opts = detectImportOptions(T4_file);
opts.VariableNamesLine = 17;
opts.DataLines = [18, Inf];
T4 = readtable(T4_file, opts);
opts = detectImportOptions(T5_file);
opts.VariableNamesLine = 17;
opts.DataLines = [18, Inf];
T5 = readtable(T5_file, opts);

%% Channel 1
Iexp1 = table2array(T1(3:height(T1),2));%%value at each point
t01 = table2array(T1(3,1)); %%beginning time
t1 = table2array(T1(3:height(T1),1)); %%time at each point
t1 = t1 - t01; %% starting at 0s
Fs1 = 1/(t1(2)-t1(1)); %% sample frequency (EX. time scale = 10ms,csv file sample point = 200000 ==> sample frequency = 2000000)
xexp1 = Iexp1; %%value array (Iexp1-1.5)*30/0.5
Nexp1 = length(xexp1); %% N points
expdft1 = fft(xexp1,Nexp1); %% fft (double_sided)
expdft1 = expdft1(1:Nexp1/2+1); %% one_sided
p1_rms = abs(expdft1/Nexp1)/sqrt(2); %%rms
p1_rms(2:end-1) = 2*p1_rms(2:end-1); %% 0Hz以及Nyquist frequency沒有重疊部分,因此不用乘2
freqexp1 = 0:Fs1/(Nexp1):Fs1/2; %% frequency span

%% Channel 2
Iexp2 = table2array(T2(3:height(T2),2));
t02 = table2array(T2(3,1));
t2 = table2array(T2(3:height(T2),1));
t2 = t2 - t02;
Fs2 = 1/(t2(2)-t2(1));
xexp2 = Iexp2; %(Iexp2-1.5)*30/0.5
Nexp2 = length(xexp2);
expdft2 = fft(xexp2,Nexp2);
expdft2 = expdft2(1:Nexp2/2+1);
p2_rms = abs(expdft2/Nexp2)/sqrt(2);
p2_rms(2:end-1) = 2*p2_rms(2:end-1);
freqexp2 = 0:Fs2/Nexp2:Fs2/2;

%% Channel 3
Iexp3 = table2array(T3(3:height(T3),2));
t03 = table2array(T3(3,1));
t3 = table2array(T3(3:height(T3),1));
t3 = t3 - t03;
Fs3 = 1/(t3(2)-t3(1));
xexp3 = Iexp3;
Nexp3 = length(xexp3);
expdft3 = fft(xexp3,Nexp3);
expdft3 = expdft3(1:Nexp3/2+1);
p3_rms = abs(expdft3/Nexp3)/sqrt(2);
p3_rms(2:end-1) = 2*p3_rms(2:end-1);
freqexp3 = 0:Fs3/Nexp3:Fs3/2;

%% Channel 4
Iexp4 = table2array(T4(3:height(T4),2));
t04 = table2array(T4(3,1));
t4 = table2array(T4(3:height(T4),1));
t4 = t4 - t04;
Fs4 = 1/(t4(2)-t4(1));
xexp4 = Iexp4;
Nexp4 = length(xexp4);
expdft4 = fft(xexp4,Nexp4);
expdft4 = expdft4(1:Nexp4/2+1);
p4_rms = abs(expdft4/Nexp4)/sqrt(2);
p4_rms(2:end-1) = 2*p4_rms(2:end-1);
freqexp4 = 0:Fs4/Nexp4:Fs4/2;

%% Channel 5
Iexp5 = table2array(T5(3:height(T5),2));
t05 = table2array(T5(3,1));
t5 = table2array(T5(3:height(T5),1));
t5 = t5 - t05;
Fs5 = 1/(t5(2)-t5(1));
xexp5 = Iexp5;
Nexp5 = length(xexp5);
expdft5 = fft(xexp5,Nexp5);
expdft5 = expdft5(1:Nexp5/2+1);
p5_rms = abs(expdft5/Nexp5)/sqrt(2);
p5_rms(2:end-1) = 2*p5_rms(2:end-1);
freqexp5 = 0:Fs5/Nexp5:Fs5/2;

%% Plot
% figure()
% % plot(t1(1:0.5*length(t1)+1),Iexp1(0.04*length(Iexp1):0.54*length(Iexp1))) %(Iexp1-1.5)*30/0.5
% 
% plot(t1(1:0.5*length(t2)+1),Iexp2(0.143*length(Iexp2):0.643*length(Iexp2))) %(Iexp2-1.5)*30/0.5
% hold on
% plot(t1(1:0.5*length(t3)+1),Iexp3(0.04*length(Iexp3):0.54*length(Iexp3)))
% % plot(t1(1:0.5*length(t3)+1),Iexp4(0.04*length(Iexp3):0.54*length(Iexp3)))
% % plot(t1(1:0.5*length(t3)+1),Iexp5(0.01*length(Iexp3):0.51*length(Iexp3)))
% grid on
% grid minor
% xlim tight
% % title('three-phase current')
% xlabel('Time [s]')
% ylabel('Voltage [V]')
% legend('\it{V_{sw1}}','\it{V_{sw2}}','\it{V_{sw3}}','\it{V_{sw4}}','\it{V_{sw5}}')
% 
% 
% figure()
% plot(t1(1:0.9*length(t1)+1),Iexp1(0.01*length(Iexp1):0.91*length(Iexp1))) %(Iexp1-1.5)*30/0.5
% hold on
% plot(t1(1:0.9*length(t2)+1),Iexp2(0.01*length(Iexp2):0.91*length(Iexp2))) %(Iexp2-1.5)*30/0.5
% plot(t1(1:0.9*length(t3)+1),Iexp3(0.01*length(Iexp3):0.91*length(Iexp3)))
% plot(t1(1:0.9*length(t3)+1),Iexp4(0.01*length(Iexp3):0.91*length(Iexp3)))
% plot(t1(1:0.9*length(t3)+1),Iexp5(0.01*length(Iexp3):0.91*length(Iexp3)))
% grid on
% grid minor
% xlim tight
% % title('three-phase current')
% xlabel('Time [s]')
% ylabel('Voltage [V]')
% legend('\it{V_{sw1}}','\it{V_{sw2}}','\it{V_{sw3}}','\it{V_{sw4}}','\it{V_{sw5}}')
% 
% 
% 
% figure()
% semilogx(freqexp1,(p1_rms*sqrt(2)))
% grid on
% grid minor
% xlim tight
% title('V_s_w with Pico voltage spectrum')
% xlabel('Frequency [Hz]')
% ylabel('Voltage [V]')
% legend('\it{V_s_w}')
% 
% figure()
% semilogx(freqexp2,(p2_rms*sqrt(2)))
% grid on
% grid minor
% xlim tight
% title('V_s_w with TPP1000(ESL) voltage spectrum')
% xlabel('Frequency [Hz]')
% ylabel('Voltage [V]')
% legend('\it{V_s_w}')
% 
% figure()
% semilogx(freqexp3,(p3_rms*sqrt(2)))
% grid on
% grid minor
% xlim tight
% title('V_s_w with TPP1000(Spring) voltage spectrum')
% xlabel('Frequency [Hz]')
% ylabel('Voltage [V]')
% legend('\it{V_s_w}')
% 
% figure()
% semilogx(freqexp4,(p4_rms*sqrt(2)))
% grid on
% grid minor
% xlim tight
% title('V_s_w with lowZ voltage spectrum')
% xlabel('Frequency [Hz]')
% ylabel('Voltage [V]')
% legend('\it{V_s_w}')
% 
% figure()
% semilogx(freqexp5,(p5_rms*sqrt(2)))
% grid on
% grid minor
% xlim tight
% title('V_s_w with P2000A voltage spectrum')
% xlabel('Frequency [Hz]')
% ylabel('Voltage [V]')
% legend('\it{V_s_w}')
% 
% 



% 
% 
% % 1. 定義時間與擷取區間
% time = t1;
% VSW = Iexp1;
% t_rise_start = 1.1e-7; 
% t_rise_end   = 4.1e-7;
% t_fall_start = 6.0e-7;   % <--- 現在你改動這個，右圖就會立刻跟著變了！
% t_fall_end   = 9.0e-7;
% 
% idx_rise = (time >= t_rise_start) & (time <= t_rise_end);
% idx_fall = (time >= t_fall_start) & (time <= t_fall_end);
% 
% % 2. 進行時間軸平移（讓兩邊都從 0 開始，方便橫向對照振盪長度）
% % time_rise = t1(idx_rise) - t_rise_start;
% % time_fall = t1(idx_fall) - t_fall_start;
% % 
% % VSW_rising  = Iexp1(idx_rise);
% % VSW_falling = Iexp1(idx_fall);
% 
% % 3. 建立標準比例白底視窗
% figure('Color', 'w', 'Position', [100, 100, 750, 300]);
% t = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');
% 
% % --- 左圖：Rising Edge ---
% nexttile;
% plot((time(idx_rise)-t_rise_start)*1e7, VSW(idx_rise), 'LineWidth', 1.2);
% pbaspect([4 3 1]); 
% xlabel('Time [\times 10^{-7} s]'); 
% ylabel('V_{SW} [V]');
% title('Rising Edge');
% grid on; grid minor;
% xlim tight
% % xlim([0 4.5]); % 限制橫軸跨度
% ylim([-15 40]);  % 統一縱軸範圍，方便對照
% 
% % --- 右圖：Falling Edge ---
% nexttile;
% % 【核心修正】確保這裡輸入的是 time_fall*1e7，絕對沒有多餘的英文字母
% plot((time(idx_fall)-t_fall_start)*1e7, VSW(idx_fall), 'LineWidth', 1.2);
% pbaspect([4 3 1]); 
% xlabel('Time [\times 10^{-7} s]'); 
% ylabel('V_{SW} [V]'); 
% title('Falling Edge');
% grid on; grid minor;
% xlim tight
% % xlim([0 4.5]); % 限制橫軸跨度
% ylim([-15 40]);  % 統一縱軸範圍


%% Figure 1

% 確保矩陣都是直的
time = t1(:);            
VSW = Iexp1(:);  

t_rise_start = 1.1e-7; 
t_rise_end   = 4.1e-7;
t_fall_start = 5.9e-7;   % <--- 現在你改動這個，右圖就會立刻跟著變了！
t_fall_end   = 8.9e-7;

idx_rise = (time >= t_rise_start) & (time <= t_rise_end);
idx_fall = (time >= t_fall_start) & (time <= t_fall_end);

% 0 點平移（時間軸乘上 1e7 以符合你圖上的刻度）
time_rise = (time(idx_rise) - t_rise_start) * 1e9;
time_fall = (time(idx_fall) - t_fall_start) * 1e9;

VSW_rising  = VSW(idx_rise);
VSW_falling = VSW(idx_fall);

% 建立畫布
figure('Color', 'w', 'Position', [100, 100, 850, 350]);
t = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% =========================================================================
% --- 左圖：Rising Edge (上升沿標註) ---
% =========================================================================
nexttile;
h_main1 = plot(time_rise, VSW_rising, 'Color', [0.0 0.45 0.74], 'LineWidth', 1.8); hold on;

% 1. 尋找左圖 Peak+ 點
[V_pk_plus, idx_pk1] = max(VSW_rising);
t_pk_plus = time_rise(idx_pk1);

% 2. 計算 10% 與 90% 的目標電壓（假設穩態是 25V，基底是 0V）
V_base1 = 0;   V_top1 = 25; 
V_10_target1 = V_base1 + 0.1 * (V_top1 - V_base1);
V_90_target1 = V_base1 + 0.9 * (V_top1 - V_base1);

% 3. 精準尋找最接近 10% 和 90% 的時間點 (使用內插法最準，避免離散點對不準)
idx_search_rise = (time_rise >= 0.45e2) & (time_rise <= 0.65e2);

% 提取這個黃金窗口內的電壓與時間
VSW_window_rise   = VSW_rising(idx_search_rise);
time_window_rise  = time_rise(idx_search_rise);

% 在這個乾淨、沒有振盪的窗口內找最接近的點
[~, local_idx_10_1] = min(abs(VSW_window_rise - V_10_target1));
[~, local_idx_90_1] = min(abs(VSW_window_rise - V_90_target1));

% 映射回真正要畫圖的時間點
t_10_1 = time_window_rise(local_idx_10_1);
t_90_1 = time_window_rise(local_idx_90_1);

% 4. 畫線與標注
% [連線與端點] 畫一條虛線連起兩點，並在兩端點加上 '*' 號標記
h_line1 = plot([t_10_1, t_90_1], [V_10_target1, V_90_target1], '--*', ...
               'Color', [0.9 0.5 0.5], 'LineWidth', 1.5, 'MarkerSize', 8);

% [Peak點] 畫一個紅色實心圓圈
h_peak1 = plot(t_pk_plus, V_pk_plus, 'ro', 'MarkerFaceColor', 'w', 'LineWidth', 2, 'MarkerSize', 7);

% [文字說明的位子]
text(t_10_1 + 0.08e2, V_10_target1-1, '10% point', 'FontSize', 9);
text(0.05e2, V_90_target1-2, '90% point', 'FontSize', 9);
text(t_pk_plus - 0.15e2, V_pk_plus+5, 'V_{PK+}', 'Color', 'r', 'FontWeight', 'bold', 'FontSize', 12);

% 圖表基本設定
grid on; grid minor; pbaspect([4 3 1]);
xlabel('Time [ns]', 'FontWeight', 'bold'); ylabel('Voltage [V]', 'FontWeight', 'bold'); title('Rising Edge');
xlim tight
% xlim([0 4.5]); % 限制橫軸跨度
ylim([-15 45]);  % 統一縱軸範圍
legend([h_main1, h_line1, h_peak1], {'{\itV}_{SW}', '10%-90% Connect', 'Peak+ Point'}, 'Location', 'northeast');


ax = gca; % 取得目前坐標軸控制權

% 1. 一鍵放大並加粗「全圖所有刻度數字」（包含 5, 10, 15... 和左、右、下的數字）
% set(ax, 'FontSize', 12, 'FontWeight', 'bold', 'LineWidth', 1.2);
% 2. 【核心魔法】：只抓 X 軸和 Y 軸的「數字物件 (Ruler)」，單獨放大並加粗
ax.XAxis.FontSize = 10;
ax.XAxis.FontWeight = 'bold';

% 左側 Y 軸數字單獨加粗放大
ax.YAxis(1).FontSize = 10;
ax.YAxis(1).FontWeight = 'bold';
% =========================================================================
% --- 右圖：Falling Edge (下降沿標註) ---
% =========================================================================
nexttile;
h_main2 = plot(time_fall, VSW_falling, 'Color', [0.0 0.45 0.74], 'LineWidth', 1.8); hold on;

% 1. 尋找右圖 Peak- 點 (最小值)
[V_pk_minus, idx_pk2] = min(VSW_falling);
t_pk_minus = time_fall(idx_pk2);

% 2. 計算 10% 與 90% 的目標電壓（注意：下降沿通常是從 25V 跌到 5V 或是跌到 0V）
% 請根據你右圖真實的平台電壓修改 V_top2 和 V_base2
V_top2 = 25;   V_base2 = 0; 
V_10_target2 = V_base2 + 0.1 * (V_top2 - V_base2); % 接近底部的電壓
V_90_target2 = V_base2 + 0.9 * (V_top2 - V_base2); % 接近頂部的電壓

% 3. 精準尋找時間點 (因為下降沿數據是遞減的，內插時時間軸需要處理，這裡用最穩健的方法)
idx_search_fall = (time_fall >= 0.45e2) & (time_fall <= 0.7e2);

% 提取這個黃金窗口內的電壓與時間
VSW_window_fall   = VSW_falling(idx_search_fall);
time_window_fall  = time_fall(idx_search_fall);

% 在窗口內找最接近的點
[~, local_idx_10_2] = min(abs(VSW_window_fall - V_10_target2));
[~, local_idx_90_2] = min(abs(VSW_window_fall - V_90_target2));

% 映射回真正要畫圖的時間點
t_10_2 = time_window_fall(local_idx_10_2);
t_90_2 = time_window_fall(local_idx_90_2);

% 4. 畫線與標注
% [連線與端點] 用紫紅色虛線連起來
h_line2 = plot([t_90_2, t_10_2], [V_90_target2, V_10_target2], '--x', ...
               'Color', [0.75 0.1 0.75], 'LineWidth', 1.5, 'MarkerSize', 8);

% [Peak點] 畫一個深藍色實心圓圈
h_peak2 = plot(t_pk_minus, V_pk_minus, 'bo', 'MarkerFaceColor', 'w', 'LineWidth', 2, 'MarkerSize', 7);

% [文字說明]
text(t_10_2 - 0.55e2, V_10_target2 + 1, '10% point', 'FontSize', 9);
text(t_90_2 + 0.1e2, V_90_target2, '90% point', 'FontSize', 9);
text(t_pk_minus - 0.4e2, V_pk_minus + 1, 'V_{PK-}', 'Color', 'b', 'FontWeight', 'bold', 'FontSize', 12);

% 圖表基本設定
grid on; grid minor; pbaspect([4 3 1]);
xlabel('Time [ns]', 'FontWeight', 'bold'); ylabel('Voltage [V]', 'FontWeight', 'bold'); title('Falling Edge');
% xlim([0 6]); ylim([-2 35]);
xlim tight
% xlim([0 4.5]); % 限制橫軸跨度
ylim([-15 45]);  % 統一縱軸範圍
legend([h_main2, h_line2, h_peak2], {'{\itV}_{SW}', '90%-10% Connect', 'Peak- Point'}, 'Location', 'northeast');
sgtitle('Differential Probe Pico High-Z', ...
        'FontSize', 14, 'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);


ax = gca; % 取得目前坐標軸控制權

% 1. 一鍵放大並加粗「全圖所有刻度數字」（包含 5, 10, 15... 和左、右、下的數字）
% set(ax, 'FontSize', 12, 'FontWeight', 'bold', 'LineWidth', 1.2);
% 2. 【核心魔法】：只抓 X 軸和 Y 軸的「數字物件 (Ruler)」，單獨放大並加粗
ax.XAxis.FontSize = 10;
ax.XAxis.FontWeight = 'bold';

% 左側 Y 軸數字單獨加粗放大
ax.YAxis.FontSize = 10;
ax.YAxis.FontWeight = 'bold';

%% Figure 2


% 確保矩陣都是直的
time = t2(:);            
VSW = Iexp2(:);  

t_rise_start = 3.02e-7; 
t_rise_end   = 6.02e-7;
t_fall_start = 7.9e-7;   % <--- 現在你改動這個，右圖就會立刻跟著變了！
t_fall_end   = 10.9e-7;

idx_rise = (time >= t_rise_start) & (time <= t_rise_end);
idx_fall = (time >= t_fall_start) & (time <= t_fall_end);

% 0 點平移（時間軸乘上 1e7 以符合你圖上的刻度）
time_rise = (time(idx_rise) - t_rise_start) * 1e9;
time_fall = (time(idx_fall) - t_fall_start) * 1e9;

VSW_rising  = VSW(idx_rise);
VSW_falling = VSW(idx_fall);

% 建立畫布
figure('Color', 'w', 'Position', [100, 100, 850, 350]);
t = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% =========================================================================
% --- 左圖：Rising Edge (上升沿標註) ---
% =========================================================================
nexttile;
h_main1 = plot(time_rise, VSW_rising, 'Color', [0.0 0.45 0.74], 'LineWidth', 1.8); hold on;

% 1. 尋找左圖 Peak+ 點
[V_pk_plus, idx_pk1] = max(VSW_rising);
t_pk_plus = time_rise(idx_pk1);

% 2. 計算 10% 與 90% 的目標電壓（假設穩態是 25V，基底是 0V）
V_base1 = 0;   V_top1 = 24; 
V_10_target1 = V_base1 + 0.1 * (V_top1 - V_base1);
V_90_target1 = V_base1 + 0.9 * (V_top1 - V_base1);

% 3. 精準尋找最接近 10% 和 90% 的時間點 (使用內插法最準，避免離散點對不準)
idx_search_rise = (time_rise >= 0.45e2) & (time_rise <= 0.64e2);

% 提取這個黃金窗口內的電壓與時間
VSW_window_rise   = VSW_rising(idx_search_rise);
time_window_rise  = time_rise(idx_search_rise);

% 在這個乾淨、沒有振盪的窗口內找最接近的點
[~, local_idx_10_1] = min(abs(VSW_window_rise - V_10_target1));
[~, local_idx_90_1] = min(abs(VSW_window_rise - V_90_target1));

% 映射回真正要畫圖的時間點
t_10_1 = time_window_rise(local_idx_10_1);
t_90_1 = time_window_rise(local_idx_90_1);

% 4. 畫線與標注
% [連線與端點] 畫一條虛線連起兩點，並在兩端點加上 '*' 號標記
h_line1 = plot([t_10_1, t_90_1], [V_10_target1, V_90_target1], '--*', ...
               'Color', [0.9 0.5 0.5], 'LineWidth', 1.5, 'MarkerSize', 8);

% [Peak點] 畫一個紅色實心圓圈
h_peak1 = plot(t_pk_plus, V_pk_plus, 'ro', 'MarkerFaceColor', 'w', 'LineWidth', 2, 'MarkerSize', 7);

% [文字說明的位子]
text(t_10_1 + 0.08e2, V_10_target1-1, '10% point', 'FontSize', 9);
text(0.05e2, V_90_target1-2, '90% point', 'FontSize', 9);
text(t_pk_plus - 0.15e2, V_pk_plus+5, 'V_{PK+}', 'Color', 'r', 'FontWeight', 'bold', 'FontSize', 12);

% 圖表基本設定
grid on; grid minor; pbaspect([4 3 1]);
xlabel('Time [ns]', 'FontWeight', 'bold'); ylabel('Voltage [V]', 'FontWeight', 'bold'); title('Rising Edge');
xlim tight
% xlim([0 4.5]); % 限制橫軸跨度
ylim([-15 45]);  % 統一縱軸範圍
legend([h_main1, h_line1, h_peak1], {'{\itV}_{SW}', '10%-90% Connect', 'Peak+ Point'}, 'Location', 'northeast');
ax = gca; % 取得目前坐標軸控制權

% 1. 一鍵放大並加粗「全圖所有刻度數字」（包含 5, 10, 15... 和左、右、下的數字）
% set(ax, 'FontSize', 12, 'FontWeight', 'bold', 'LineWidth', 1.2);
% 2. 【核心魔法】：只抓 X 軸和 Y 軸的「數字物件 (Ruler)」，單獨放大並加粗
ax.XAxis.FontSize = 10;
ax.XAxis.FontWeight = 'bold';

% 左側 Y 軸數字單獨加粗放大
ax.YAxis.FontSize = 10;
ax.YAxis.FontWeight = 'bold';

% =========================================================================
% --- 右圖：Falling Edge (下降沿標註) ---
% =========================================================================
nexttile;
h_main2 = plot(time_fall, VSW_falling, 'Color', [0.0 0.45 0.74], 'LineWidth', 1.8); hold on;

% 1. 尋找右圖 Peak- 點 (最小值)
[V_pk_minus, idx_pk2] = min(VSW_falling);
t_pk_minus = time_fall(idx_pk2);

% 2. 計算 10% 與 90% 的目標電壓（注意：下降沿通常是從 25V 跌到 5V 或是跌到 0V）
% 請根據你右圖真實的平台電壓修改 V_top2 和 V_base2
V_top2 = 24;   V_base2 = 0; 
V_10_target2 = V_base2 + 0.1 * (V_top2 - V_base2); % 接近底部的電壓
V_90_target2 = V_base2 + 0.9 * (V_top2 - V_base2); % 接近頂部的電壓

% 3. 精準尋找時間點 (因為下降沿數據是遞減的，內插時時間軸需要處理，這裡用最穩健的方法)
idx_search_fall = (time_fall >= 0.45e2) & (time_fall <= 0.67e2);

% 提取這個黃金窗口內的電壓與時間
VSW_window_fall   = VSW_falling(idx_search_fall);
time_window_fall  = time_fall(idx_search_fall);

% 在窗口內找最接近的點
[~, local_idx_10_2] = min(abs(VSW_window_fall - V_10_target2));
[~, local_idx_90_2] = min(abs(VSW_window_fall - V_90_target2));

% 映射回真正要畫圖的時間點
t_10_2 = time_window_fall(local_idx_10_2);
t_90_2 = time_window_fall(local_idx_90_2);

% 4. 畫線與標注
% [連線與端點] 用紫紅色虛線連起來
h_line2 = plot([t_90_2, t_10_2], [V_90_target2, V_10_target2], '--x', ...
               'Color', [0.75 0.1 0.75], 'LineWidth', 1.5, 'MarkerSize', 8);

% [Peak點] 畫一個深藍色實心圓圈
h_peak2 = plot(t_pk_minus, V_pk_minus, 'bo', 'MarkerFaceColor', 'w', 'LineWidth', 2, 'MarkerSize', 7);

% [文字說明]
text(t_10_2 - 0.55e2, V_10_target2 + 1, '10% point', 'FontSize', 9);
text(t_90_2 + 0.1e2, V_90_target2, '90% point', 'FontSize', 9);
text(t_pk_minus - 0.4e2, V_pk_minus + 1, 'V_{PK-}', 'Color', 'b', 'FontWeight', 'bold', 'FontSize', 12);

% 圖表基本設定
grid on; grid minor; pbaspect([4 3 1]);
xlabel('Time [ns]', 'FontWeight', 'bold'); ylabel('Voltage [V]', 'FontWeight', 'bold'); title('Falling Edge');
% xlim([0 6]); ylim([-2 35]);
xlim tight
% xlim([0 4.5]); % 限制橫軸跨度
ylim([-15 45]);  % 統一縱軸範圍
legend([h_main2, h_line2, h_peak2], {'{\itV}_{SW}', '90%-10% Connect', 'Peak- Point'}, 'Location', 'northeast');
sgtitle('Passive Probe with Spring Clip High-Z', ...
        'FontSize', 14, 'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);
ax = gca; % 取得目前坐標軸控制權

% 1. 一鍵放大並加粗「全圖所有刻度數字」（包含 5, 10, 15... 和左、右、下的數字）
% set(ax, 'FontSize', 12, 'FontWeight', 'bold', 'LineWidth', 1.2);
% 2. 【核心魔法】：只抓 X 軸和 Y 軸的「數字物件 (Ruler)」，單獨放大並加粗
ax.XAxis.FontSize = 10;
ax.XAxis.FontWeight = 'bold';

% 左側 Y 軸數字單獨加粗放大
ax.YAxis.FontSize = 10;
ax.YAxis.FontWeight = 'bold';


%% Figure 3


% 確保矩陣都是直的
time = t4(:);            
VSW = Iexp4(:);  

t_rise_start = 1.08e-7; 
t_rise_end   = 4.08e-7;
t_fall_start = 5.9e-7;   % <--- 現在你改動這個，右圖就會立刻跟著變了！
t_fall_end   = 8.9e-7;

idx_rise = (time >= t_rise_start) & (time <= t_rise_end);
idx_fall = (time >= t_fall_start) & (time <= t_fall_end);

% 0 點平移（時間軸乘上 1e7 以符合你圖上的刻度）
time_rise = (time(idx_rise) - t_rise_start) * 1e9;
time_fall = (time(idx_fall) - t_fall_start) * 1e9;

VSW_rising  = VSW(idx_rise);
VSW_falling = VSW(idx_fall);

% 建立畫布
figure('Color', 'w', 'Position', [100, 100, 850, 350]);
t = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% =========================================================================
% --- 左圖：Rising Edge (上升沿標註) ---
% =========================================================================
nexttile;
h_main1 = plot(time_rise, VSW_rising, 'Color', [0.0 0.45 0.74], 'LineWidth', 1.8); hold on;

% 1. 尋找左圖 Peak+ 點
[V_pk_plus, idx_pk1] = max(VSW_rising);
t_pk_plus = time_rise(idx_pk1);

% 2. 計算 10% 與 90% 的目標電壓（假設穩態是 25V，基底是 0V）
V_base1 = 0;   V_top1 = 25; 
V_10_target1 = V_base1 + 0.1 * (V_top1 - V_base1);
V_90_target1 = V_base1 + 0.9 * (V_top1 - V_base1);

% 3. 精準尋找最接近 10% 和 90% 的時間點 (使用內插法最準，避免離散點對不準)
idx_search_rise = (time_rise >= 0.45e2) & (time_rise <= 0.8e2);

% 提取這個黃金窗口內的電壓與時間
VSW_window_rise   = VSW_rising(idx_search_rise);
time_window_rise  = time_rise(idx_search_rise);

% 在這個乾淨、沒有振盪的窗口內找最接近的點
[~, local_idx_10_1] = min(abs(VSW_window_rise - V_10_target1));
[~, local_idx_90_1] = min(abs(VSW_window_rise - V_90_target1));

% 映射回真正要畫圖的時間點
t_10_1 = time_window_rise(local_idx_10_1);
t_90_1 = time_window_rise(local_idx_90_1);

% 4. 畫線與標注
% [連線與端點] 畫一條虛線連起兩點，並在兩端點加上 '*' 號標記
h_line1 = plot([t_10_1, t_90_1], [V_10_target1, V_90_target1], '--*', ...
               'Color', [0.9 0.5 0.5], 'LineWidth', 1.5, 'MarkerSize', 8);

% [Peak點] 畫一個紅色實心圓圈
h_peak1 = plot(t_pk_plus, V_pk_plus, 'ro', 'MarkerFaceColor', 'w', 'LineWidth', 2, 'MarkerSize', 7);

% [文字說明的位子]
text(t_10_1 + 0.08e2, V_10_target1-1, '10% point', 'FontSize', 9);
text(0.05e2, V_90_target1-2, '90% point', 'FontSize', 9);
text(t_pk_plus - 0.15e2, V_pk_plus+5, 'V_{PK+}', 'Color', 'r', 'FontWeight', 'bold', 'FontSize', 12);

% 圖表基本設定
grid on; grid minor; pbaspect([4 3 1]);
xlabel('Time [ns]', 'FontWeight', 'bold'); ylabel('Voltage [V]', 'FontWeight', 'bold'); title('Rising Edge');
xlim tight
% xlim([0 4.5]); % 限制橫軸跨度
ylim([-15 45]);  % 統一縱軸範圍
legend([h_main1, h_line1, h_peak1], {'{\itV}_{SW}', '10%-90% Connect', 'Peak+ Point'}, 'Location', 'northeast');
ax = gca; % 取得目前坐標軸控制權

% 1. 一鍵放大並加粗「全圖所有刻度數字」（包含 5, 10, 15... 和左、右、下的數字）
% set(ax, 'FontSize', 12, 'FontWeight', 'bold', 'LineWidth', 1.2);
% 2. 【核心魔法】：只抓 X 軸和 Y 軸的「數字物件 (Ruler)」，單獨放大並加粗
ax.XAxis.FontSize = 10;
ax.XAxis.FontWeight = 'bold';

% 左側 Y 軸數字單獨加粗放大
ax.YAxis.FontSize = 10;
ax.YAxis.FontWeight = 'bold';

% =========================================================================
% --- 右圖：Falling Edge (下降沿標註) ---
% =========================================================================
nexttile;
h_main2 = plot(time_fall, VSW_falling, 'Color', [0.0 0.45 0.74], 'LineWidth', 1.8); hold on;

% 1. 尋找右圖 Peak- 點 (最小值)
[V_pk_minus, idx_pk2] = min(VSW_falling);
t_pk_minus = time_fall(idx_pk2);

% 2. 計算 10% 與 90% 的目標電壓（注意：下降沿通常是從 25V 跌到 5V 或是跌到 0V）
% 請根據你右圖真實的平台電壓修改 V_top2 和 V_base2
V_top2 = 25;   V_base2 = 0; 
V_10_target2 = V_base2 + 0.1 * (V_top2 - V_base2); % 接近底部的電壓
V_90_target2 = V_base2 + 0.9 * (V_top2 - V_base2); % 接近頂部的電壓

% 3. 精準尋找時間點 (因為下降沿數據是遞減的，內插時時間軸需要處理，這裡用最穩健的方法)
idx_search_fall = (time_fall >= 0.45e2) & (time_fall <= 0.8e2);

% 提取這個黃金窗口內的電壓與時間
VSW_window_fall   = VSW_falling(idx_search_fall);
time_window_fall  = time_fall(idx_search_fall);

% 在窗口內找最接近的點
[~, local_idx_10_2] = min(abs(VSW_window_fall - V_10_target2));
[~, local_idx_90_2] = min(abs(VSW_window_fall - V_90_target2));

% 映射回真正要畫圖的時間點
t_10_2 = time_window_fall(local_idx_10_2);
t_90_2 = time_window_fall(local_idx_90_2);

% 4. 畫線與標注
% [連線與端點] 用紫紅色虛線連起來
h_line2 = plot([t_90_2, t_10_2], [V_90_target2, V_10_target2], '--x', ...
               'Color', [0.75 0.1 0.75], 'LineWidth', 1.5, 'MarkerSize', 8);

% [Peak點] 畫一個深藍色實心圓圈
h_peak2 = plot(t_pk_minus, V_pk_minus, 'bo', 'MarkerFaceColor', 'w', 'LineWidth', 2, 'MarkerSize', 7);

% [文字說明]
text(t_10_2 - 0.55e2, V_10_target2 + 1, '10% point', 'FontSize', 9);
text(t_90_2 + 0.1e2, V_90_target2, '90% point', 'FontSize', 9);
text(t_pk_minus - 0.2e2, V_pk_minus - 3.5, 'V_{PK-}', 'Color', 'b', 'FontWeight', 'bold', 'FontSize', 12);

% 圖表基本設定
grid on; grid minor; pbaspect([4 3 1]);
xlabel('Time [ns]', 'FontWeight', 'bold'); ylabel('Voltage [V]', 'FontWeight', 'bold'); title('Falling Edge');
% xlim([0 6]); ylim([-2 35]);
xlim tight
% xlim([0 4.5]); % 限制橫軸跨度
ylim([-15 45]);  % 統一縱軸範圍
legend([h_main2, h_line2, h_peak2], {'{\itV}_{SW}', '90%-10% Connect', 'Peak- Point'}, 'Location', 'northeast');
sgtitle('Passive Probe with Low-Z', ...
        'FontSize', 14, 'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);
ax = gca; % 取得目前坐標軸控制權

% 1. 一鍵放大並加粗「全圖所有刻度數字」（包含 5, 10, 15... 和左、右、下的數字）
% set(ax, 'FontSize', 12, 'FontWeight', 'bold', 'LineWidth', 1.2);
% 2. 【核心魔法】：只抓 X 軸和 Y 軸的「數字物件 (Ruler)」，單獨放大並加粗
ax.XAxis.FontSize = 10;
ax.XAxis.FontWeight = 'bold';

% 左側 Y 軸數字單獨加粗放大
ax.YAxis.FontSize = 10;
ax.YAxis.FontWeight = 'bold';


%% Figure 4


% 確保矩陣都是直的
time = t5(:);            
VSW = Iexp5(:);  

t_rise_start = 0.44e-7; 
t_rise_end   = 3.44e-7;
t_fall_start = 5.25e-7;   % <--- 現在你改動這個，右圖就會立刻跟著變了！
t_fall_end   = 8.25e-7;

idx_rise = (time >= t_rise_start) & (time <= t_rise_end);
idx_fall = (time >= t_fall_start) & (time <= t_fall_end);

% 0 點平移（時間軸乘上 1e7 以符合你圖上的刻度）
time_rise = (time(idx_rise) - t_rise_start) * 1e9;
time_fall = (time(idx_fall) - t_fall_start) * 1e9;

VSW_rising  = VSW(idx_rise);
VSW_falling = VSW(idx_fall);

% 建立畫布
figure('Color', 'w', 'Position', [100, 100, 850, 350]);
t = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% =========================================================================
% --- 左圖：Rising Edge (上升沿標註) ---
% =========================================================================
nexttile;
h_main1 = plot(time_rise, VSW_rising, 'Color', [0.0 0.45 0.74], 'LineWidth', 1.8); hold on;

% 1. 尋找左圖 Peak+ 點
[V_pk_plus, idx_pk1] = max(VSW_rising);
t_pk_plus = time_rise(idx_pk1);

% 2. 計算 10% 與 90% 的目標電壓（假設穩態是 25V，基底是 0V）
V_base1 = 0;   V_top1 = 25; 
V_10_target1 = V_base1 + 0.1 * (V_top1 - V_base1);
V_90_target1 = V_base1 + 0.9 * (V_top1 - V_base1);

% 3. 精準尋找最接近 10% 和 90% 的時間點 (使用內插法最準，避免離散點對不準)
idx_search_rise = (time_rise >= 0.45e2) & (time_rise <= 0.8e2);

% 提取這個黃金窗口內的電壓與時間
VSW_window_rise   = VSW_rising(idx_search_rise);
time_window_rise  = time_rise(idx_search_rise);

% 在這個乾淨、沒有振盪的窗口內找最接近的點
[~, local_idx_10_1] = min(abs(VSW_window_rise - V_10_target1));
[~, local_idx_90_1] = min(abs(VSW_window_rise - V_90_target1));

% 映射回真正要畫圖的時間點
t_10_1 = time_window_rise(local_idx_10_1);
t_90_1 = time_window_rise(local_idx_90_1);

% 4. 畫線與標注
% [連線與端點] 畫一條虛線連起兩點，並在兩端點加上 '*' 號標記
h_line1 = plot([t_10_1, t_90_1], [V_10_target1, V_90_target1], '--*', ...
               'Color', [0.9 0.5 0.5], 'LineWidth', 1.5, 'MarkerSize', 8);

% [Peak點] 畫一個紅色實心圓圈
h_peak1 = plot(t_pk_plus, V_pk_plus, 'ro', 'MarkerFaceColor', 'w', 'LineWidth', 2, 'MarkerSize', 7);

% [文字說明的位子]
text(t_10_1 + 0.08e2, V_10_target1-1, '10% point', 'FontSize', 9);
text(0.05e2, V_90_target1-2, '90% point', 'FontSize', 9);
text(t_pk_plus - 0.15e2, V_pk_plus+5, 'V_{PK+}', 'Color', 'r', 'FontWeight', 'bold', 'FontSize', 12);

% 圖表基本設定
grid on; grid minor; pbaspect([4 3 1]);
xlabel('Time [ns]', 'FontWeight', 'bold'); ylabel('Voltage [V]', 'FontWeight', 'bold'); title('Rising Edge');
xlim tight
% xlim([0 4.5]); % 限制橫軸跨度
ylim([-15 45]);  % 統一縱軸範圍
legend([h_main1, h_line1, h_peak1], {'{\itV}_{SW}', '10%-90% Connect', 'Peak+ Point'}, 'Location', 'northeast');
ax = gca; % 取得目前坐標軸控制權

% 1. 一鍵放大並加粗「全圖所有刻度數字」（包含 5, 10, 15... 和左、右、下的數字）
% set(ax, 'FontSize', 12, 'FontWeight', 'bold', 'LineWidth', 1.2);
% 2. 【核心魔法】：只抓 X 軸和 Y 軸的「數字物件 (Ruler)」，單獨放大並加粗
ax.XAxis.FontSize = 10;
ax.XAxis.FontWeight = 'bold';

% 左側 Y 軸數字單獨加粗放大
ax.YAxis.FontSize = 10;
ax.YAxis.FontWeight = 'bold';

% =========================================================================
% --- 右圖：Falling Edge (下降沿標註) ---
% =========================================================================
nexttile;
h_main2 = plot(time_fall, VSW_falling, 'Color', [0.0 0.45 0.74], 'LineWidth', 1.8); hold on;

% 1. 尋找右圖 Peak- 點 (最小值)
[V_pk_minus, idx_pk2] = min(VSW_falling);
t_pk_minus = time_fall(idx_pk2);

% 2. 計算 10% 與 90% 的目標電壓（注意：下降沿通常是從 25V 跌到 5V 或是跌到 0V）
% 請根據你右圖真實的平台電壓修改 V_top2 和 V_base2
V_top2 = 25;   V_base2 = 0; 
V_10_target2 = V_base2 + 0.1 * (V_top2 - V_base2); % 接近底部的電壓
V_90_target2 = V_base2 + 0.9 * (V_top2 - V_base2); % 接近頂部的電壓

% 3. 精準尋找時間點 (因為下降沿數據是遞減的，內插時時間軸需要處理，這裡用最穩健的方法)
idx_search_fall = (time_fall >= 0.45e2) & (time_fall <= 0.8e2);

% 提取這個黃金窗口內的電壓與時間
VSW_window_fall   = VSW_falling(idx_search_fall);
time_window_fall  = time_fall(idx_search_fall);

% 在窗口內找最接近的點
[~, local_idx_10_2] = min(abs(VSW_window_fall - V_10_target2));
[~, local_idx_90_2] = min(abs(VSW_window_fall - V_90_target2));

% 映射回真正要畫圖的時間點
t_10_2 = time_window_fall(local_idx_10_2);
t_90_2 = time_window_fall(local_idx_90_2);

% 4. 畫線與標注
% [連線與端點] 用紫紅色虛線連起來
h_line2 = plot([t_90_2, t_10_2], [V_90_target2, V_10_target2], '--x', ...
               'Color', [0.75 0.1 0.75], 'LineWidth', 1.5, 'MarkerSize', 8);

% [Peak點] 畫一個深藍色實心圓圈
h_peak2 = plot(t_pk_minus, V_pk_minus, 'bo', 'MarkerFaceColor', 'w', 'LineWidth', 2, 'MarkerSize', 7);

% [文字說明]
text(t_10_2 - 0.55e2, V_10_target2 + 1, '10% point', 'FontSize', 9);
text(t_90_2 + 0.1e2, V_90_target2, '90% point', 'FontSize', 9);
text(t_pk_minus - 0.2e2, V_pk_minus - 3.5, 'V_{PK-}', 'Color', 'b', 'FontWeight', 'bold', 'FontSize', 12);

% 圖表基本設定
grid on; grid minor; pbaspect([4 3 1]);
xlabel('Time [ns]', 'FontWeight', 'bold'); ylabel('Voltage [V]', 'FontWeight', 'bold'); title('Falling Edge');
% xlim([0 6]); ylim([-2 35]);
xlim tight
% xlim([0 4.5]); % 限制橫軸跨度
ylim([-15 45]);  % 統一縱軸範圍
legend([h_main2, h_line2, h_peak2], {'{\itV}_{SW}', '90%-10% Connect', 'Peak- Point'}, 'Location', 'northeast');
sgtitle('Passive Probe High Voltage', ...
        'FontSize', 14, 'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);

ax = gca; % 取得目前坐標軸控制權

% 1. 一鍵放大並加粗「全圖所有刻度數字」（包含 5, 10, 15... 和左、右、下的數字）
% set(ax, 'FontSize', 12, 'FontWeight', 'bold', 'LineWidth', 1.2);
% 2. 【核心魔法】：只抓 X 軸和 Y 軸的「數字物件 (Ruler)」，單獨放大並加粗
ax.XAxis.FontSize = 10;
ax.XAxis.FontWeight = 'bold';

% 左側 Y 軸數字單獨加粗放大
ax.YAxis.FontSize = 10;
ax.YAxis.FontWeight = 'bold';