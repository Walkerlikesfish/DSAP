function [out_sig] = vocodeLPC(in_spe, in_carr, O_lpc)
%vocodeLPC is used to filter the 

[a_spe, g_spe] = lpc(in_spe,O_lpc);
[a_carr, g_carr] = lpc(in_carr, O_lpc);

% Get the envenlop and error from the LPC 
est_spe = filter([0 -a_spe(2:end)], 1, in_spe);
err_spe = in_spe-est_spe;
est_carr = filter([0 -a_carr(2:end)], 1, in_carr);
err_carr = in_carr - est_carr;

% Apply the spectral envelop of speech on instrument
est_ins = filter([0 -a_spe(2:end)], 1, in_carr);
% Aplly the amplitude dynamics of speech on instrument
out_sig = est_ins + err_spe;

%[DEBUG] figure plot
%figure(1);plot(est_carr);hold on;plot(in_carr);

end

