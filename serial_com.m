clc;
clear all;
close all;
delete(instrfindall);

 %设置串口参数
 s = serial('com1');
 set(s, 'baudRate', 460800);%设置波特率
 set(s, 'inputBufferSize', 5000);%设置缓存大小
 fopen(s);%打开串口

 serial_data = [];%串口数据
 rem = [];

 fid = fopen('test3.txt','w+');%保存串口数据的文件
 
 for n = 1:100
     data = fread(s);
     fprintf(fid, '%d\t',data);%写入每次读取的串口数据
	 
     [dataout, newrem] = decode422(data, rem);%对收到的串口数据进行解码

     rem = newrem;
     serial_data = [serial_data; dataout];
 end
 fclose(fid);

save('serial_data.txt','serial_data','-ascii');%保存解码后的数据
 
 %%解码
 function [dataout, rem] = decode422(datain, lastrem)
    ser_data = [lastrem; datain];
    dataout = [];
    n = 1;
    while true
        if ser_data(n) == 128 && check(ser_data(n+1:n+9))
            pn = bitget(ser_data(n+5), 4, 'int8');
            ser_data(n+5) = bitset(ser_data(n+5), 4, 0);
            tmp = ser_data(n+1) + ser_data(n+2)*128 + ser_data(n+3)*128*128 ...
                             + ser_data(n+4) *128*128*128+ ser_data(n+5)*128*128*128*128;
            if pn == 1
                tmp = tmp-128*128*128*128*8;
            end
            dataout = [dataout; tmp];
            n = n+ 10;
        else 
            n = n+1;
        end
        
        if n > length(ser_data)-20
            rem = ser_data(n:end);
            return;
        end
    end
 end
 %校验
 function flag = check(rawdata)
    flag = false;
    
    tmp = bitxor(rawdata(1),rawdata(2));
    tmp = bitxor(tmp,rawdata(3));
    tmp = bitxor(tmp,rawdata(4));
    tmp = bitxor(tmp,rawdata(5));
    
    tmp2 = bitxor(rawdata(7), rawdata(8));
    if tmp == rawdata(6) && tmp2 == rawdata(9)
        flag = true;
    end
 end