function [X_dpca] = apply_dpca(X,W)
%APPLY_DPCA Summary of this function goes here
%   Detailed explanation goes here
    X_dpca = [];
    for i = 1:size(X,1)
        temp = squeeze(X(i,:,:));
        temp = temp - mean(mean(temp));
        X_dpca(i,:,:) = temp*W;
    end
end

