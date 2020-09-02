function [Target_one_hot] = one_hot_encoding(Target)
%ONE_HOT_ENCODING the function one hot encodes targets
% Input:
%       Target = [Trial x 1]
% Output:
%       Target_one_hot = [Trial x # of Targets]
    
    N = size(Target,1);
    Target_one_hot = zeros(N,size(unique(Target),1));
    for i = 1:N
        Target_one_hot(i,Target(i)) = 1;
    end
end

