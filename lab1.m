% DSAP Lab 1

%% Data initialisation
filename = 'data/test2.wav';
[x, fs] = audioread(filename);

x_l = x(:, 1);
x_r = x(:, 2);

Ntaps = 256;

%% Upmixing - 1) PSD
[c_psd, s_psd] = upmix_psd(x_l, x_r);

%% Upmixing - 2) LMS
[c_lms, s_lms] = upmix_lms(x_l, x_r);

%% Upmixing - 3) PCA-based
[c_pca, s_pca] = upmix_pca(x_l, x_r);
% audiowrite('out.wav', s_pca, fs);

%% Upmixing - 4) ADP
% [c_adp, s_adp] = upmix_adp(x_l, x_r);

%% LPF 1
lp = 100;
hp = 200;
lpf1 = fir1(Ntaps,[lp/fs hp/fs]);
freqz(lpf1,1,fs)

%% LPF 2
lp = 0;
hp = 200;
lpf2 = fir1(Ntaps,[lp/fs hp/fs]);
freqz(lpf2,1,fs)

%% LPF 3

%% 90 degree shifter

%% assemble
