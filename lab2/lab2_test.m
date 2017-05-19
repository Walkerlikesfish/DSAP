close all;

%% global settings
fs = 48000;
T = 1.0; % 1 second
N_samples = round(T*fs);

N = 24000;
N_impulse = 300;

wave_mono = zeros(N_samples, 1);
wave_mono(N_impulse) = 1.0;
angle_mono = zeros(N_samples, 1);
angle_mono(:) = 0;

[c, fl, rl, rr, fr] = room_vbap(wave_mono, angle_mono, N, fs);

N_plot_begin = N_impulse;
N_plot_end = N_impulse+3000;

figure;
stem(c(N_plot_begin:N_plot_end));
title('center');
xlabel('Sample')
ylabel('Amp')
figure
subplot(121);
stem(fl(N_plot_begin:N_plot_end));
title('front left');
xlabel('Sample')
ylabel('Amp')
subplot(122);
stem(fr(N_plot_begin:N_plot_end));
title('front right');
xlabel('Sample')
ylabel('Amp')
figure
subplot(121);
stem(rl(N_plot_begin:N_plot_end));
title('rear left');
xlabel('Sample')
ylabel('Amp')
subplot(122);
stem(rr(N_plot_begin:N_plot_end));
title('rear right');
xlabel('Sample')
ylabel('Amp')

figure;
wave_tot = sqrt(c.^2+fl.^2+rl.^2+rr.^2+fr.^2);
stem(wave_tot);

