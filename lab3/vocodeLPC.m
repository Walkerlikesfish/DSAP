function [out_sig] = vocodeLPC(in_spe, in_carr, O_lpc)
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
%figure;plot(est_ins); hold on; plot(out_sig);
%figure;plot(est_spe, 'r');hold on;plot(in_spe , 'b');
%figure;plot(est_carr, 'r');hold on;plot(in_carr , 'b');

end

