% DSAP Lab 1

%% Data initialisation
filename = './data/test0.mp3';
[y,Fs] = audioread(filename);

%% Upmixing - 1) PSD
c = sum(y, 2)/sqrt(2); %center
s = y;
s(:,2) = -s(:,2);
s = sum(s, 2)/sqrt(2);

%% LPF 1

%% LPF 2

%% LPF 3

%% 
