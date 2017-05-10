function [c, fl, rl, rr, fr] = vbap(mono, theta)
    theta_front = 30*pi/180;
    theta_rear = 110*pi/180;
    
    % order: c, fl, rl, rr, fr
    vec_basis = [1                 0                ;
                 cos(theta_front)  sin(theta_front) ;
                 cos(theta_rear)   sin(theta_rear)  ;
                 cos(-theta_rear)  sin(-theta_rear) ;
                 cos(-theta_front) sin(-theta_front)];

    gains = zeros(5, 1);

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

    % apply gain
    c = mono*gains(1);
    fl = mono*gains(2);
    rl = mono*gains(3);
    rr = mono*gains(4);
    fr = mono*gains(5);
end
