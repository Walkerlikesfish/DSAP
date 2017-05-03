function theta = angle_eval(wave_pair1, wave_pair2, fs)
    N = size(wave_pair1, 1);
    theta = zeros(N, 1);

    c = 340;
    d = 0.1*sqrt(2);% pair distance
    N_window = 48000;% 500 ms resolution
    
    max_tdoa = d/c;

    for start=1:N_window:N-N_window
        tdoa1 = get_tdoa(wave_pair1(start:start+N_window, 1), wave_pair1(start:start+N_window, 2), fs);
        tdoa2 = get_tdoa(wave_pair2(start:start+N_window, 1), wave_pair2(start:start+N_window, 2), fs);
        if abs(tdoa1) > max_tdoa
            tdoa1 = 0.0;
        end
        if abs(tdoa2) > max_tdoa
            tdoa2 = 0.0;
        end
        vx = c*tdoa1/d; % cos of alpha1
        vy = c*tdoa2/d; % cos of alpha2
        theta_val = atan2(-vy, -vx); % stange reasons
        theta(start:start+N_window) = theta_val;
    end
end
