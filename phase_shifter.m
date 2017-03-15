function y = phase_shifter(x, positive)
    y = imag(hilbert(x));
    % 1 time: 90 degrees shift
    if ~positive
        y = imag(hilbert(y));
        y = imag(hilbert(y));
        % 3 times in total: -90 degrees shift
    end
end
