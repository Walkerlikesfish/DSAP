function [c, s] = upmix_lms(x_l, x_r)

% nonsense output for now
c = zeros(size(x_l));
s = zeros(size(x_r));

return;

lms2 = dsp.LMSFilter('Length',N_frame, ...
   'Method','LMS',...
   'AdaptInputPort',true, ...
   'StepSizeSource','Input port', ...
   'WeightsOutputPort',false);
filt2 = dsp.FIRFilter('Numerator', fir1(10,[.5, .75]));
x_noise = randn(1000,1); % Noise
d = filt2(x_noise) + sin(0:.05:49.95)'; % Noise + Signal
a = 1; % adaptation control
mu = 0.05; % step size
[y, err] = lms2(x_noise,d,mu,a);

end
