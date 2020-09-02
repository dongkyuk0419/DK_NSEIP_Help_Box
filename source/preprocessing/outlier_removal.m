function [data_clean,data_outlier,index_clean,index_outlier] = outlier_removal(data,num_outlier)
%OUTLIER_REMOVAL Removes num_outlier number of outliers using kNN density
%estimation.
    if num_outlier < 1
        num_outlier = round(num_outlier*size(data,1));
    end
    k = 20;
%     p = k_NN_density_estimation(data,k);
    p = KDensitySlow(data,k);
    [~,index_p] = sort(p);
    index_outlier = index_p(1:num_outlier);
    data_outlier = data(index_outlier,:);
    index_clean = index_p(num_outlier+1:end);
    data_clean = data(index_clean,:);
end

