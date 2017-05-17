% Lab 1 - Demo Use
%

%% Flags

% select input mode
% 1-test music; 2-impluse for PSD; 3-PCA test; 4-ADP test;
flags.in_data_mode = 3;

% select the upmix method
% 1-PSD 2-LMS 3-PCA 4-ADP
flags.up_mix = 4; 

% save file tag: 1-ON; 0-OFF
flags.save_file = 0;

% Define low pass filter taps number
flags.Ntaps = 256;


%% Data selection
% output: 
%   - fs
%   - x_l x_r

if flags.in_data_mode == 1
    filename = 'data/test2.wav';
    [x, fs] = audioread(filename);
    x_l = x(:, 1);
    x_r = x(:, 2);
    
elseif flags.in_data_mode == 2
    fs = 16e3;
    t_in = 0.1; % set the demo input as 5 [s]
    t_axis = [0:1/fs:t_in];
    t_axis = t_axis(1:end-1);
    N_in = t_in * fs;
    x_l = zeros(1, N_in);
    x_r = zeros(1, N_in);
    x_r(1) = 1;
    
elseif flags.in_data_mode == 3
    filename = 'data/stereo2surround_testfile.wav';
    [x, fs] = audioread(filename);
    x_l = x(:, 1);
    x_r = x(:, 2);
elseif flags.in_data_mode == 4
    filename = 'data/stereo2surround_testfile_2.wav';
    [x, fs] = audioread(filename);
    x_l = x(:, 1);
    x_r = x(:, 2);
end

%% Upmix
if flags.up_mix == 1 %PSD
    [c_psd, s_psd] = upmix_psd(x_l, x_r);
elseif flags.up_mix == 2 %LMS
    [c_lms, s_lms] = upmix_lms(x_l, x_r);
elseif flags.up_mix == 3 %PCA
    [c_pca, s_pca] = upmix_pca(x_l, x_r);
elseif flags.up_mix == 4  %ADP
    [c_adp, s_adp] = upmix_adp(x_l, x_r);
    
end

%% Go through the filters
% LPF 1
% cutoff 4kHz n=256
Wn = 4000/fs;
lpf1 = fir1(flags.Ntaps,Wn);

% LPF 2
Wn = 200/fs;
lpf2 = fir1(flags.Ntaps,Wn);

% LPF 3
Wn = 7000/fs;
lpf3 = fir1(flags.Ntaps,Wn);

% 90 degree shifter
L = 2629;
beta = 31;
shifter = kaiser(L,beta);

%% Assemble the channels

c_mono = zeros(size(x_l));
s_mono = zeros(size(x_l));

switch flags.up_mix
    case 1
        disp('PSD Upmixer');
        c_mono(:) = c_psd;
        s_mono(:) = s_psd;
    case 2
        disp('LMS Upmixer');
        c_mono(:) = c_lms;
        s_mono(:) = s_lms;
    case 3
        disp('PCA-based Upmixer');
        c_mono(:) = c_pca;
        s_mono(:) = s_pca;
    case 4
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

%% Visual

switch flags.up_mix
    case 1
        figure(1)
        subplot(6,1,1);plot(t_axis,fl);
        subplot(6,1,2);plot(t_axis,fr);
        subplot(6,1,3);plot(t_axis,c);
        subplot(6,1,4);plot(t_axis,rl);
        subplot(6,1,5);plot(t_axis,rr);
        subplot(6,1,6);plot(t_axis,lfe);
    case 2
        disp('LMS Upmixer - weight matrix plot');
        
    case 3
        disp('PCA-based Upmixer - synthesis window & eigen vectors');
        
    case 4
        disp('ADP Upmixer - wl and wr plotted');
        
    otherwise
        error('invalid number!');
end

%% Save file or not
if flags.save_file == 1
    audiowrite('output/c_lfe.wav', [c; lfe], fs);
    audiowrite('output/front.wav', [fl; fr], fs);
    audiowrite('output/rear.wav', [rl; rr], fs);
else
    disp('We dont want to save files!')
end