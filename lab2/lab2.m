%% load
clear;
close all;

data_load = load('data/audio_data.mat');
data = data_load.audioData;

fs = 96000;

% 4 channels: front back left right
wave = data.Data; 
cuts = [data.sceneCut.s1;
        data.sceneCut.s2;
        data.sceneCut.s3;
        data.sceneCut.s4;
        data.sceneCut.s5];

wave_s1 = wave(1:cuts(1), :);
wave_s2 = wave(cuts(1):cuts(2), :);
wave_s3 = wave(cuts(2):cuts(3), :);
wave_s4 = wave(cuts(3):cuts(4), :);
wave_s5 = wave(cuts(4):cuts(5), :);


%% apply
close all;

save_file = true;

N_window = 90000;% ~1s resolution
angle_s1 = angle_eval(wave_s1(:, 1:2), wave_s1(:, 3:4), N_window, fs);
[c, fl, rl, rr, fr] = vbap(wave_s1(:, 1), angle_s1, N_window);
lfe = zeros(size(c));
if save_file
    audiowrite('output/s1_c_lfe.wav', [c; lfe], fs);
    audiowrite('output/s1_front.wav', [fl; fr], fs);
    audiowrite('output/s1_rear.wav', [rl; rr], fs);
end

N_window = 90000;% ~1s resolution
angle_s2 = angle_eval(wave_s2(:, 1:2), wave_s2(:, 3:4), N_window, fs);
[c, fl, rl, rr, fr] = vbap(wave_s2(:, 1), angle_s2, N_window);
lfe = zeros(size(c));
if save_file
    audiowrite('output/s2_c_lfe.wav', [c; lfe], fs);
    audiowrite('output/s2_front.wav', [fl; fr], fs);
    audiowrite('output/s2_rear.wav', [rl; rr], fs);
end

N_window = 24000;% ~250ms resolution
angle_s3 = angle_eval(wave_s3(:, 1:2), wave_s3(:, 3:4), N_window, fs);
[c, fl, rl, rr, fr] = vbap(wave_s3(:, 1), angle_s3, N_window);
lfe = zeros(size(c));
if save_file
    audiowrite('output/s3_c_lfe.wav', [c; lfe], fs);
    audiowrite('output/s3_front.wav', [fl; fr], fs);
    audiowrite('output/s3_rear.wav', [rl; rr], fs);
end

N_window = 24000;% ~250ms resolution
angle_s4 = angle_eval(wave_s4(:, 1:2), wave_s4(:, 3:4), N_window, fs);
[c, fl, rl, rr, fr] = vbap(wave_s4(:, 1), angle_s4, N_window);
lfe = zeros(size(c));
if save_file
    audiowrite('output/s4_c_lfe.wav', [c; lfe], fs);
    audiowrite('output/s4_front.wav', [fl; fr], fs);
    audiowrite('output/s4_rear.wav', [rl; rr], fs);
end

figure;
plot(angle_s1);
figure;
plot(angle_s2);
figure;
plot(angle_s3);
figure;
plot(angle_s4);
% %% 
% soundsc([fl c], fs);
