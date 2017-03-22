function [c, s] = upmix_psd(x_l, x_r)

c = (x_l + x_r)/sqrt(2); %center
s = (x_l - x_r)/sqrt(2); %surround

end
