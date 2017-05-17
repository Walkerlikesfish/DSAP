function [out_sig] = vocodeLPC(in_spe, in_carr, O_lpc, verbal)
%vocodeLPC is used to filter the 

[a_spe, v_spe] = lpc(in_spe,O_lpc);
[a_carr, v_carr] = lpc(in_carr, O_lpc);

% Get the envenlop and error from the LPC 
est_spe = filter([0 -a_spe(2:end)], 1, in_spe);
err_spe = in_spe-est_spe;
est_carr = filter([0 -a_carr(2:end)], 1, in_carr);
err_carr = in_carr - est_carr;

% Calc the energy of the error
g_spe = sqrt(sum(err_spe.^2));
g_carr = sqrt(sum(err_carr.^2));
g_coeff = g_spe/g_carr;

% Apply the spectral envelop of speech on instrument
est_ins = filter(1, a_spe, err_carr);
% Aplly the amplitude dynamics of speech on instrument
out_sig = est_ins*g_coeff;

%[DEBUG] figure plot
% Get the spetrum

spec_in_spe = fft(in_spe);
spec_in_carr = fft(in_carr);
spec_est_spe = fft(est_spe);
spec_est_carr = fft(est_carr);
spec_err_spe = fft(err_spe);
spec_err_carr = fft(err_carr);

if verbal
    figure(1);
    subplot(3,1,1); plot(abs(spec_in_spe)); title('Original Signal');
    subplot(3,1,2); plot(abs(spec_est_spe)); title('Envelop');
    subplot(3,1,3); plot(abs(spec_err_spe)); title('Residual');
    figure(2);
    subplot(3,1,1); plot(abs(spec_in_carr)); title('Original Signal');
    subplot(3,1,2); plot(abs(spec_est_carr)); title('Envelop');
    subplot(3,1,3); plot(abs(spec_err_carr)); title('Residual');
    figure(3);
    plot(abs(out_sig)); title('Output Signal');
end

%figure;plot(est_ins); hold on; plot(out_sig);
%figure;plot(est_spe, 'r');hold on;plot(in_spe , 'b');
%figure;plot(est_carr, 'r');hold on;plot(in_carr , 'b');

end

