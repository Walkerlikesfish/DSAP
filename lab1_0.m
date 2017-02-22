% DSAP Lab 1

%% Data initialisation
filename = './data/test0.mp3';
[y,Fs] = audioread(filename);

%% Upmixing - 1) PSD
c = sum(y, 2)/sqrt(2); %center
s = y;
s(:,2) = -s(:,2);
s = sum(s, 2)/sqrt(2);

%% Upmixing - 2) LMS
lms2 = dsp.LMSFilter('Length',N_frame, ...
   'Method','LMS',...
   'AdaptInputPort',true, ...
   'StepSizeSource','Input port', ...
   'WeightsOutputPort',false);
filt2 = dsp.FIRFilter('Numerator', fir1(10,[.5, .75]));
x = randn(1000,1); % Noise
d = filt2(x) + sin(0:.05:49.95)'; % Noise + Signal
a = 1; % adaptation control
mu = 0.05; % step size
[y, err] = lms2(x,d,mu,a);

%% Upmixing - 3) PCA-based

%% Upmixing - 4) ADP

%% LPF 1

%% LPF 2

%% LPF 3

%% 90 degree shifter

%% assemble
