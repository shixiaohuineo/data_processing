%test_lcpsd
clc
clear all;

N = 1e5;

a = rand(N,1);
b = rand(N,1);

figure
plot(a);
hold on;
plot(b);

[cpsd,~] = lcpsd_wrapper(a,b,1);
[psd, freq] = lpsd_wrapper(a,1);

figure;
loglog(freq,abs(psd));
hold on;
loglog(freq,abs(cpsd),'p');
