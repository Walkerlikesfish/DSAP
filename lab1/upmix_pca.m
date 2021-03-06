function [c, s] = upmix_pca(x_l, x_r)

% N = 1024; % Window length
N = 8820; % 200ms window on fs=44100
M = 256;  % Overlap
n = 0:N-1;
w = zeros(N, 1);

% Construct the window for overlap and add
w(1:M) = sin((pi/2)*(n(1:M)+1/2)/M);
w(M+1:N-M) = 1;
w(N-M+1:N) = sin((pi/2)*(N-n(N-M+1:N)-1/2)/M);

done = false;
t_begin = 1;
t_max = length(x_l);

c = zeros(size(x_l));
s = zeros(size(x_l));

% use running average on the eigenvectors, more natural feel
lambda = 0.1;
% initial values
v_c_inertia = [1; 1]/sqrt(2);
v_s_inertia = [1; -1]/sqrt(2);

% plot for output
v_c_plot_l = [];
v_c_plot_r = [];
v_s_plot_l = [];
v_s_plot_r = [];

while (~done)
    t_end = t_begin + N - 1;
    if (t_end>t_max)
        t_end = t_max;
    end
    % apply the window
    y_l = x_l(t_begin:t_end).*w(1:t_end-t_begin+1);
    y_r = x_r(t_begin:t_end).*w(1:t_end-t_begin+1);
    % calc the covariance matrix 
    cov_mat = cov([y_l y_r]);
    [v, d] = eig(cov_mat);
    v_s = v(:, 1); % first one: smallest eigenvalue
    v_c = v(:, 2); % second one: greatest eigenvalue
    
    % make sure no sign flipping from one window to the next
    v_c = abs(v_c);
    v_s(1) = abs(v_s(1));
    v_s(2) = -abs(v_s(2));
    
    % running average
    v_c_inertia = (1-lambda)*v_c_inertia + lambda*v_c;
    v_s_inertia = (1-lambda)*v_s_inertia + lambda*v_s;
    
    c(t_begin:t_end) = c(t_begin:t_end) + (y_l * v_c_inertia(1) + y_r * v_c_inertia(2)).*w(1:t_end-t_begin+1);
    s(t_begin:t_end) = s(t_begin:t_end) + (y_l * v_s_inertia(1) + y_r * v_s_inertia(2)).*w(1:t_end-t_begin+1);
    
    v_c_plot_l = [v_c_plot_l; v_c_inertia(1)];
    v_c_plot_r = [v_c_plot_r; v_c_inertia(2)];
    v_s_plot_l = [v_s_plot_l; v_s_inertia(1)];
    v_s_plot_r = [v_s_plot_r; v_s_inertia(2)];
    
    done = t_end == t_max;
    t_begin = t_end - M + 1;% move window with overlap
end

% plot the Filter
w_sum = zeros(N+(N-M), 1);
w_sum(1:N) = w;
w_sum(N-M+1:end) = w_sum(N-M+1:end) + w;
figure;
plot(w_sum);
title('The Overlap-add filter')
xlabel('Samples')
ylabel('Amplitude')

% plot the eigenvectors vs time
figure
subplot(2,2,1)
plot(v_c_plot_l)
title('The weight factor for the center channel (Cl)')
xlabel('Time (in ms)')
ylabel('Amplitude')
subplot(2,2,2)
plot(v_c_plot_r)
title('The weight factor for the center channel (Cr)')
xlabel('Time (in ms)')
ylabel('Amplitude')
subplot(2,2,3)
plot(v_s_plot_l)
title('The weight factor for the surround channel (sl)')
xlabel('Time (in ms)')
ylabel('Amplitude')
subplot(2,2,4)
plot(v_s_plot_r)
title('The weight factor for the surround channel (sr)')
xlabel('Time (in ms)')
ylabel('Amplitude')
end