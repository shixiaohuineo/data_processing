function yout = remove_drift(yin)
    [row,line] = size(yin);
    x = (1:row)';
    yout = NaN(row,line);
    for n = 1:line
        p = polyfit(x,yin(:,n),1);
        yfit = polyval(p,x);
        yout(:,n) = yfit-yin(:,n);
    end
end