function out = lpsd_wrapper(y,fs)
%%
    %out = lpsd_wrapper(y,fs)
    %fs : sampling rate
    %y  : input data to calculate log scale power spectrum density,
    %out:out.psd, out.f
    %     and y should be a 1 dim data, in the unit of V2/Hz
%%
    [m,n] = size(y);
    if (m ~= 1) && (n ~= 1)
        disp('wrong input of y');
        return
    end
    y = remove_drift(y);
    N = length(y);  % number of data points in the timeseries
    fmin = fs/N;    % lowest frequency of interest
    fmax = fs/2;    % highest frequency of interest
    Jdes = 500;    % desired number of points in the spectrum

    Kdes = 10;     % desired number of averages
    Kmin = 2;       % minimum number of averages

    xi = 0.5;       % fractional overlap
    % PS : vervor uncalibrated power spectrum, it will be calibrated by C
    % f  : vector of frequencies corresponding to PS
    % C  : structure containing calibration factors to calibrate Pxx
    %      into either power spectral density or power spectrum.
    [PS, fo, C] = lpsd(y, @hanning, fmin, fmax, Jdes, Kdes, Kmin, fs, xi);
    psd_out = PS .* C.PSD;
    
    out.psd = psd_out';
    out.f   = fo';
    
    figure
    loglog(out.f ,out.psd);
    grid on;
return 