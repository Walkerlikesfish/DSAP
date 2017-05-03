function delay_eval = get_tdoa(wave1, wave2, fs)
    [wave_corr,wave_lag] = xcorr(wave1, wave2);
    [~, taps] = max(abs(wave_corr));
    delay_eval = wave_lag(taps)/fs;
end
