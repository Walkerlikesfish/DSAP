function [c, s] = upmix_lms(x_l, x_r)

%[Memo] take the x_l as the desired(d); and x_r as the input(x)

% set the mu to be 1e-3
mu = 1e-3;
% set the method parameters
N_wn = 2205; % 50ms * fs(44100)
t_axis = [0:1/44100:0.05];
t_axis = t_axis(1:end-1);
len_in = size(x_l);
c = zeros(size(x_l));
s = zeros(size(x_l));
% initialise the filter weight
wn = zeros(1, N_wn);

cur_xn = zeros(1, N_wn);
for ii = 1:len_in(1)
    % construct the x series
    cur_xn(1:N_wn-1) = cur_xn(2:N_wn);
    cur_xn(N_wn) = x_r(ii); % x(n)
    c(ii) = wn * cur_xn';  % y(n)
    wnp = wn;
    s(ii) = x_l(ii) - c(ii); % e(n)
    wn = wnp + 2*mu*s(ii)*cur_xn;
end

figure(2);
plot(t_axis, wn); xlim([0 0.06]); title('The filter vector w(n)') 
xlabel('Time (in seconds)') 
        ylabel('Amplitude') 
end
