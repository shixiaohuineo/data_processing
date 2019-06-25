function [allan_result, PSD_linear] = stability(data,fs,f_normalize)
%%
%����������ڷ����ȶ��ȣ�������׷���͹������ܶȣ�
%���ߣ�ʯ����
%ʱ�䣺2015��10��29��
%�汾��1.0

%input  data : ����������
%	    fs   : �����ʣ���λHz

%output allan_deviation:�������ݵİ��׷����λ������ĵ�λһ�£��������������޵�λ���ݣ���ô���Ҳû�е�λ��
%                       �������ĵ�λ��V,��ô����ĵ�λҲ��V
%                       allan_result.tau ��gate time;
%                       allan_result.ad  ���������ݵİ��׷���;
%                       allan_result.error_b �ǰ��׷����error bar;
%       PSD_linear     :�������ݵİ����Թ������ܶȣ���λΪ1/rtHz,�������ĵ�λ��Hz����ô����ĵ�λ��Hz/rtHz��
%                       �������ĵ�λ��V����ô����ĵ�λ��V/rtHz
%                       PSD_linear.f�Ǹ���ҶƵ��
%                       PSD_linear.psd�����Թ������ܶ�

%%
%ȷ���������ݵĸ�ʽ��ȷ
data = to_col(data);

[m_fs, n_fs] = size(fs);
if (m_fs ~= 1 || n_fs ~= 1) 
    disp('second input parameter should be a num');
    return;
end
%�Ƴ�����Ư��
%�������Թ������ܶ�
%data = remove_drift(data);
%data = remove_quadratic(data);
%data = remove_badpoint(data,5);
%plot(data);
%%
% PSD_linear = lpsd_wrapper(data,fs);
[PSD_linear.psd, PSD_linear.f] = lpsd_wrapper(data,fs);

%���㰬�׷���
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

