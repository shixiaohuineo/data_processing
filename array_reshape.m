function arr_out = array_reshape(arr_in, sz)
%%  arr_out = array_reshape(arr_in, sz) reshape the array and truncked 
%edited by shixiaohui
%email: shixiaohui@foxmail.com
    arr_out = [];
    if 0 ~= rem(sz,1)
        disp('warning! size should be an integer in function:array_reshape.');
        return;
    end
    arr_in = reshape(arr_in,1,[]);
    len_in = length(arr_in);
    len_out = len_in - rem(len_in, sz);
    arr_out = arr_in(1:len_out);
    arr_out = reshape(arr_out, [], sz);
end