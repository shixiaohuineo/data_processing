function out_data = remove_badpoint(data,sigma)
%%
%该函数用于移除坏点
%data: raw data
%sigma: remove data beyond sigma
mean_data = mean(data);
stdvar = std(data);

out_data = data((data > mean_data - sigma*stdvar) & (data < mean_data + sigma*stdvar));
end