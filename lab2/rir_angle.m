function [out_angle, t_delay, attenuation] = rir_angle(ori_angle, fs)
    %% hyperparameters
    room_dim = [4 5]; %room dimension
    d = 1; %distance between the speaker and the listener
    wave_speed = 340;
    speaker_loc = d*[cos(ori_angle) sin(ori_angle)]; %speaker location
    %calculate R_p
    R_p_x = [speaker_loc(1) room_dim(1)-speaker_loc(1) -room_dim(1)/2-speaker_loc(1)];
    R_p_y = [speaker_loc(2) room_dim(2)-speaker_loc(2) -room_dim(2)/2-speaker_loc(2)];
    %calculate 8 other angles
    out_angle = zeros(9,1);
    t_delay = zeros(9,1);
    attenuation = zeros(9,1);
    ind = 1;
    for y = R_p_y
       for x = R_p_x
          out_angle(ind) = atan2(y/x);
          t_delay(ind) = round(fs*sqrt(x^2 + y^2)/wave_speed);
          attenuation(ind) = 4*pi*sqrt(x^2 + y^2);
          ind = ind + 1;
       end
    end 
end

