function [allan_result, PSD_linear] = stability(data,fs,f_normalize)
%%
%这个程序用于分析稳定度，输出艾伦方差和功率谱密度：
%作者：石晓辉
%时间：2015年10月29日
%版本：1.0

%input  data : 待处理数据
%	    fs   : 采样率，单位Hz

%output allan_deviation:输入数据的艾伦方差，单位和输入的单位一致，如果输入的数是无单位数据，那么输出也没有单位，
%                       如果输入的单位是V,那么输出的单位也是V
%                       allan_result.tau 是gate time;
%                       allan_result.ad  是输入数据的艾伦方差;
%                       allan_result.error_b 是艾伦方差的error bar;
%       PSD_linear     :输入数据的艾线性功率谱密度，单位为1/rtHz,如果输入的单位是Hz，那么输出的单位是Hz/rtHz，
%                       如果输入的单位是V，那么输出的单位是V/rtHz
%                       PSD_linear.f是傅里叶频率
%                       PSD_linear.psd是线性功率谱密度

%%
%确认输入数据的格式正确
data = to_col(data);

[m_fs, n_fs] = size(fs);
if (m_fs ~= 1 || n_fs ~= 1) 
    disp('second input parameter should be a num');
    return;
end
%移除线性漂移
%计算线性功率谱密度
%data = remove_drift(data);
%data = remove_quadratic(data);
%data = remove_badpoint(data,5);
%plot(data);
%%
% PSD_linear = lpsd_wrapper(data,fs);
[PSD_linear.psd, PSD_linear.f] = lpsd_wrapper(data,fs);

%计算艾伦方差
allan_data.freq = data/f_normalize;
allan_data.rate = fs;
%1  2     3     4     5     6     7     8     9  10    20    30    40    50    60    70    80    90
a = 1:9;
% a = [1,2,4];
tau_in = [a*1e-1,a,a*1e1,a*1e2,a*1e3,a*1e4];

%1,2,4,10,20,40...
% b = [1,2,4]
% tau_in = [b*1e-4,b*1e-3,b*1e-2,b*1e-1,b,b*1e1,b*1e2,b*1e3];
[ret_value, ~, eb, Tau] = allan(allan_data, tau_in, 'allan', 0);
allan_result.tau = Tau';
allan_result.ad  = ret_value';
allan_result.error_b = eb';
end

