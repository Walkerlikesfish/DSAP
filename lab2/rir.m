%virtual room reverb
function [c, fl, rl, rr, fr] = rir(ori_wave, out_angle, t_delay, attenuation)
    %% hyperparameters
    room_dim = [4 5];
    d = 2; %distance between the speaker and the listener
    wave_speed = 340;

    %% allocation
    wave_i = zeros(8, size(ori_wave));
    c = zeros(8, size(ori_wave));
    fl = zeros(8, size(ori_wave));
    rl = zeros(8, size(ori_wave));
    rr = zeros(8, size(ori_wave));
    fr = zeros(8, size(ori_wave));

    for ind_start=1:N_window:N-N_window
        for ind = 1:8
            ind_end = ind_start+N_window-1;
            wave_windowed = ori_wave(ind_start-t_delay:ind_end-t_delay).*w;
            wave_windowed = wave_windowed/attenuation;
            wave_i(ind, ind_start:ind_end) = wave_i(ind, ind_start:ind_end) + wave_windowed.*w;
            wave_i(ind, :) = wave_i(ind, :)/attenuation(ind);
        end
    end
    
    for ind = 1:8
        [c_i, fl_i, rl_i, rr_i, fr_i] = vbap(wave_i, angle_i, N_window);
        c = c + c_i;
        fl = fl + fl_i;
        rl = rl + rl_i;
        rr = rr + rr_i;
        fr = fr + fr_i;
    end

end