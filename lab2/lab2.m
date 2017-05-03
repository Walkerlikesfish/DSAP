%% load
clear

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

%% eval

angle_s1 = angle_eval(wave_s1(:, 1:2), wave_s1(:, 3:4), fs);

figure;
plot(angle_s1);
