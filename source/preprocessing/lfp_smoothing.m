function [lfp_smooth] = lfp_smoothing(lfp,smoothing_time_window)
%LFP_SMOOTHING Summary of this function goes here
%   lfp: cell containing LFP
    N = length(lfp);
    lfp_smooth = cell(N,1);
    % Data Smoothing
    for i = 1:N
        temp = zeros(size(lfp{i},1)-smoothing_time_window+1,size(lfp{i},2));
        for ii = 1:size(temp,1)
            temp(ii,:) = mean(lfp{i}(ii:ii+smoothing_time_window-1,:),1);
        end
        lfp_smooth{i} = temp;
        clear temp
    end    
end

