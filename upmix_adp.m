function [c, s] = upmix_adp(x_l, x_r)

mu = 1e-10;
% take the x_l as the input(x); and x_r as desired(d)
len_in = size(x_l);
c = zeros(size(x_l));
s = zeros(size(x_l));
% initialise the filter weight
wnp = [1, 1]; % [w_l, w_r]
wn = wnp(:);
x = [x_l, x_r];

for ii = 1:len_in(1)
    xn = x(ii,:);
    yn = xn * wn;
    wnp = wn;
    wn(1) = wnp(1) - mu*yn*(x_l(ii)-wnp(1)*yn); % w_l(n+1)
    wn(2) = wnp(2) - mu*yn*(x_r(ii)-wnp(2)*yn); % w_r(n+1)
    c(ii) = wnp(1)*x_l(ii) + wnp(2)*x_r(ii);
    s(ii) = wnp(2)*x_l(ii) - wnp(1)*x_r(ii);
end
end
