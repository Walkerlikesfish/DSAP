close all;

fs = 96000;
T = 1.0; % 1 second
N_samples = round(T*fs);

N = 24000;
N_impulse = 300;

wave_mono = zeros(N_samples, 1);
wave_mono(N_impulse) = 1.0;
angle_mono = zeros(N_samples, 1);
angle_mono(:) = pi;

[c, fl, rl, rr, fr] = room_vbap(wave_mono, angle_mono, N, fs);
% [c, fl, rl, rr, fr] = vbap(wave_mono, angle_mono, N);

N_plot_begin = N_impulse;
N_plot_end = N_impulse+3000;

figure;
subplot(511);
stem(c(N_plot_begin:N_plot_end), '.');
title('center');
subplot(512);
stem(fl(N_plot_begin:N_plot_end), '.');
title('front left');
subplot(513);
stem(rr(N_plot_begin:N_plot_end), '.');
title('rear right');
subplot(514);
stem(rl(N_plot_begin:N_plot_end), '.');
title('rear left');
subplot(515);
stem(fr(N_plot_begin:N_plot_end), '.');
title('front right');

figure;
wave_sum = sqrt(c.^2+fl.^2+rl.^2+rr.^2+fr.^2);
stem(wave_sum(N_plot_begin:N_plot_end));
