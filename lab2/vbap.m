function [c, fl, rl, rr, fr] = vbap(mono_signal, theta_signal, N_window)
    theta_front = 30*pi/180;
    theta_rear = 110*pi/180;

    % order: c, fl, rl, rr, fr
    vec_basis = [1                 0                ;
                 cos(theta_front)  sin(theta_front) ;
                 cos(theta_rear)   sin(theta_rear)  ;
                 cos(-theta_rear)  sin(-theta_rear) ;
                 cos(-theta_front) sin(-theta_front)];

    gains = zeros(5, 1);

    N = size(mono_signal, 1);

    c = zeros(N, 1);
    fl = zeros(N, 1);
    rl = zeros(N, 1);
    rr = zeros(N, 1);
    fr = zeros(N, 1);

    % apply gain
    for start=1:N_window:N-N_window
        gains(:) = 0;

        theta = theta_signal(start);
        % pick pair of speakers
        % assume -pi < theta < pi
        if theta >= 0
            if (theta > theta_rear)
                index1 = 3;
                index2 = 4;
            elseif (theta > theta_front)
                index1 = 2;
                index2 = 3;
            else
                index1 = 1;
                index2 = 2;
            end
        else
            if (-theta > theta_rear)
                index1 = 3;
                index2 = 4;
            elseif (-theta > theta_front)
                index1 = 4;
                index2 = 5;
            else
                index1 = 1;
                index2 = 5;
            end
        end

        % compute gain
        vec1 = vec_basis(index1, :);
        vec2 = vec_basis(index2, :);
        vec_in = [cos(theta) sin(theta)];
        mat = [vec1; vec2];
        gains_1_2 = vec_in/mat;
        gains_1_2 = gains_1_2/norm(gains_1_2);
        gains(index1) = gains_1_2(1);
        gains(index2) = gains_1_2(2);

        c(start:start+N_window-1) = mono_signal(start:start+N_window-1)*gains(1);
        fl(start:start+N_window-1) = mono_signal(start:start+N_window-1)*gains(2);
        rl(start:start+N_window-1) = mono_signal(start:start+N_window-1)*gains(3);
        rr(start:start+N_window-1) = mono_signal(start:start+N_window-1)*gains(4);
        fr(start:start+N_window-1) = mono_signal(start:start+N_window-1)*gains(5);
    end
end
