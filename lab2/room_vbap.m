function [c, fl, rl, rr, fr] = room_vbap(wave_0, angle_0, N, fs)
    %% window settings
    M = 256;  % Overlap
    n = 0:N-1;
    w = zeros(N, 1);

    % Construct the window for overlap and add
    w(1:M) = sin((pi/2)*(n(1:M)+1/2)/M);
    w(M+1:N-M) = 1;
    w(N-M+1:N) = sin((pi/2)*(N-n(N-M+1:N)-1/2)/M);

    %% initialize output
    N_samples = size(wave_0, 1);

    c = zeros(N_samples, 1);
    fl = zeros(N_samples, 1);
    rl = zeros(N_samples, 1);
    rr = zeros(N_samples, 1);
    fr = zeros(N_samples, 1);

    %% loop begin
    wave_slice = zeros(N, 1);
    
    done = false;
    n_begin = 1;

    while ~done
        n_end = n_begin + N - 1;
        if n_end >= N_samples
            done = true;
            continue;
        end

        % original speaker
        wave_slice(:) = wave_0(n_begin:n_end).*w;
        angle_slice = angle_0(n_begin);
        [c_0, fl_0, rl_0, rr_0, fr_0] = vbap(wave_slice, angle_slice, N);
        c(n_begin:n_end) = c(n_begin:n_end) + c_0.*w;
        fl(n_begin:n_end) = fl(n_begin:n_end) + fl_0.*w;
        rl(n_begin:n_end) = rl(n_begin:n_end) + rl_0.*w;
        rr(n_begin:n_end) = rr(n_begin:n_end) + rr_0.*w;
        fr(n_begin:n_end) = fr(n_begin:n_end) + fr_0.*w;

        % virtual speakers
        [angle_v, delay_v, attenuation_v] = rir_params(angle_slice, fs);
        for ii=1:8
            slice_begin = n_begin-delay_v(ii);
            slice_end = slice_begin + N - 1;
            if slice_end < 1
                continue;
            end
            % virtual delay
            if slice_begin < 1
                N_corrupt = 1-slice_begin;% number of samples in the past of wave_0
                wave_slice(1:N_corrupt) = 0.0;
                wave_slice(N_corrupt+1:N) = wave_0(1:slice_end).*w(N_corrupt+1:N);
            else
                wave_slice(:) = wave_0(slice_begin:slice_end).*w;
            end
            % attenuation
            wave_slice(:) = wave_slice(:)/attenuation_v(ii);
            % virtual angle
            angle_slice = angle_v(ii);

            [c_v, fl_v, rl_v, rr_v, fr_v] = vbap(wave_slice, angle_slice, N);
            c(n_begin:n_end) = c(n_begin:n_end) + c_v.*w(1:n_end-n_begin+1);
            fl(n_begin:n_end) = fl(n_begin:n_end) + fl_v.*w(1:n_end-n_begin+1);
            rl(n_begin:n_end) = rl(n_begin:n_end) + rl_v.*w(1:n_end-n_begin+1);
            rr(n_begin:n_end) = rr(n_begin:n_end) + rr_v.*w(1:n_end-n_begin+1);
            fr(n_begin:n_end) = fr(n_begin:n_end) + fr_v.*w(1:n_end-n_begin+1);
        end

        n_begin = n_end - M + 1;% move window with overlap
    end
end
