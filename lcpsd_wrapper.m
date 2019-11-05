function [psd_out, freq] = lcpsd_wrapper(amp_a, amp_b,fs)
%%[psd_out, freq] = lcpsd_wrapper(amp_a, amp_b,fs)
    %fs : sampling rate
    %y  : input data to calculate log scale power spectrum density,
    %     and y should be a 1 dim data
    
    [m,n] = size(amp_a);

    if (m ~= 1) && (n ~= 1)
        disp('wrong input of amp');
        return
    end
    
    amp_a = remove_drift(amp_a);
    amp_b = remove_drift(amp_b);
    
    N = length(amp_a);  % number of data points in the timeseries
    fmin = fs/N;    % lowest frequency of interest
    fmax = fs/2;    % highest frequency of interest
    Jdes = 400;    % desired number of points in the spectrum
%     fmin = 10;
%     fmax = 1e4;
%     Jdes = 400;
    Kdes = 20;     % desired number of averages
    Kmin = 2;       % minimum number of averages

    xi = 0.5;       % fractional overlap
    % PS : vervor uncalibrated power spectrum, it will be calibrated by C
    % f  : vector of frequencies corresponding to PS
    % C  : structure containing calibration factors to calibrate Pxx
    %      into either power spectral density or power spectrum.
    [PS, fo, C] = lcpsd(amp_a, amp_b, @hanning, fmin, fmax, Jdes, Kdes, Kmin, fs, xi);
    psd_out = to_col(PS .* C.PSD);
    freq = to_col(fo);
return 