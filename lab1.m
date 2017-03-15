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

%% Upmixing - 4) ADP
[c_adp, s_adp] = upmix_adp(x_l, x_r);

%% LPF 1
% cutoff 4kHz n=256
Wn = 4000/fs;
lpf1 = fir1(Ntaps,Wn);
freqz(lpf1,1,fs)

%% LPF 2
Wn = 200/fs;
lpf2 = fir1(Ntaps,Wn);
%freqz(lpf2,1,fs)

%% LPF 3
Wn = 7000/fs;
lpf3 = fir1(Ntaps,Wn);

%% 90 degree shifter
L = 2629;
beta = 31;
shifter = kaiser(L,beta);

%% assemble
s_in = input('Select the upmixer (1-4), enter q to exit: ', 's');
while(s_in ~= 'q')
    switch s_in
        case '1'
            display 'PSD Upmixer'
        case '2'
            display 'LMS Upmixer'
        case '3'
            display 'PCA-based Upmixer'
        case '4'
            display 'ADP Upmixer'
    end
    s_in = input('Select the upmixer: enter q to exit', 's');
end
