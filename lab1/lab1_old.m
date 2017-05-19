% DSAP Lab 1

%% Data initialisation
filename = 'data/test2.wav';
[x, fs] = audioread(filename);

x_l = x(:, 1);
x_r = x(:, 2);

Ntaps = 256;

%% Data Generate
% Construct demo input
fs = 16e3;
t_in = 10; % set the demo input as 5 [s]
N_in = t_in * fs;

x_l = zeros(1, N_in);
x_r = zeros(1, N_in);
x_r(1) = 1;

%% Upmixing - 1) PSD
[c_psd, s_psd] = upmix_psd(x_l, x_r);

%% Upmixing - 2) LMS
[c_lms, s_lms] = upmix_lms(x_l, x_r);

%% Upmixing - 3) PCA-based
[c_pca, s_pca] = upmix_pca(x_l, x_r);

%% Upmixing - 4) ADP
[c_adp, s_adp] = upmix_adp(x_l, x_r);

%% LPF 1
% cutoff 4kHz n=256
Wn = 4000/fs;
lpf1 = fir1(Ntaps,Wn);

%% LPF 2
Wn = 200/fs;
lpf2 = fir1(Ntaps,Wn);

%% LPF 3
Wn = 7000/fs;
lpf3 = fir1(Ntaps,Wn);

%% 90 degree shifter
L = 2629;
beta = 31;
shifter = kaiser(L,beta);

%% assemble
s_in = input('Select the upmixer (1-4), enter q to exit: ', 's');
c_mono = zeros(size(x_l));
s_mono = zeros(size(x_l));
switch s_in
    case '1'
        disp('PSD Upmixer');
        c_mono(:) = c_psd;
        s_mono(:) = s_psd;
    case '2'
        disp('LMS Upmixer');
        c_mono(:) = c_lms;
        s_mono(:) = s_lms;
    case '3'
        disp('PCA-based Upmixer');
        c_mono(:) = c_pca;
        s_mono(:) = s_pca;
    case '4'
        disp('ADP Upmixer');
        c_mono(:) = c_adp;
        s_mono(:) = s_adp;
    otherwise
        error('invalid number!');
end

t_shift = round(fs*0.012);

c = conv(c_mono, lpf1, 'same');
lfe = conv(c_mono, lpf2, 'same');
s_delayed = zeros(size(s_mono));
s_delayed(1+t_shift:end) = s_mono(1:end-t_shift);
s_delayed_lpf3 = conv(s_delayed, lpf3, 'same');
rl = phase_shifter(s_delayed_lpf3, true);
rr = phase_shifter(s_delayed_lpf3, false);
fl = x_l;
fr = x_r;

audiowrite('output/c_lfe.wav', [c; lfe], fs);
audiowrite('output/front.wav', [fl; fr], fs);
audiowrite('output/rear.wav', [rl; rr], fs);
