function [c, s] = upmix_lms(x_l, x_r)

mu = 1e-4;
% take the x_l as the input(x); and x_r as desired(d)
len_in = size(x_l);
c = zeros(size(x_l));
s = zeros(size(x_l));
% initialise the filter weight
wnp = 1;
wn = wnp;

for ii = 1:len_in(1)
    c(ii) = wn * x_l(ii);  % y(n)
    wnp = wn;
    s(ii) = x_r(ii) - c(ii); % e(n)
    wn = wnp + 2*mu*s(ii)*x_l(ii);
end

end
