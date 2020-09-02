function [data_LM,index_out] = downsample_data(data,index_clean,N_lm)
%DOWNSAMPLE_DATA Summary of this function goes here
%   Detailed explanation goes here

    [N,d] = size(data);
    if N_lm<1
        N_lm = round(N_lm*N);
    end
    data_LM = nan(N_lm,d);
    index_LM = nan(N_lm,1);

    % select a random point
%     index_LM(1) = randi(N);
    index_LM(1) = 1;
    data_LM(1,:) = data(index_LM(1),:);
    index_avai = (1:N).';
    index_avai(index_LM(1))= []; % remove chosen point

    for i = 2:N_lm
        group_dist = ones(size(index_avai,1),1)*9999999;
        for k = 1:i-1
            temp = euclidean_distance(data_LM(k,:),data(index_avai,:));
            temp_i = group_dist>temp;
            group_dist(temp_i) = temp(temp_i);
        end
        [~,index_max]= max(group_dist);
        index_LM(i) = index_avai(index_max);
        index_avai(index_max)=[];
        data_LM(i,:) = data(index_LM(i),:);
    end
    index_out = index_clean(index_LM,:);
end

