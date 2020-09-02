function [tdr,pca_info] = TDR_train(X, Target, N_subspace)  
% This function applies TDR to a train set that consists of 
% raw lfp X, and targets
% I assume that the targets are not one hot encoded
% Inputs:
%   X: raw lfp (it actually can be anything) [Trials x Time x Channels]
%   Target: Targets (or can be replaced with any stimulus) [Trials x 1]
%   N_subspace: Number of subspace to be used [1]
%       possible improvements: maybe variance (ex choose pcs responsible
%       for 90% of the variance)


% Pre allocation
    pca_info = {};
    
% Step 1: One hot encode the targets
    [Target_one_hot] = one_hot_encoding(Target);
    N_Target = size(Target_one_hot,2);
    
% Step 2: Identify the pca subspace
    X_flat = reshape(X, [prod(size(X,1:2)),size(X,3)]);
    pca_info.Xmean = mean(X_flat,1);
    [pca_info.pcaD,~,~] = pca(X_flat);
    X_pca = reshape((pca_info.pcaD*(X_flat - pca_info.Xmean)')',size(X));
    % X_pca_sub = X_pca(:,:,1:N_subspace);

% Step 3: Identify the regression subspace
    F = [Target_one_hot,ones(N,1)];
    beta = zeros(N_Target+1,size(X,3),size(X,2));
    beta_pca = zeros(N_Target,N_subspace,size(X,2));
    % linear regression
    for i = 1:size(X,3)
        beta(:,i,:) = (pinv(F*F')*F)'*X(:,:,i);
    end
    % subspace projection
    for i = 1:N_Target
        temp = pca_info.pcaD*squeeze(beta(i,:,:));
        beta_pca(i,:,:) = temp(1:N_subspace,:);    
    end
    % regression subspace identificatin
    beta_max = zeros(N_Target,N_subspace);
    for i = 1:N_Target
        % I will use L2 norm to compare the norms
        [~,index] = max(sum(squeeze(beta_pca(i,:,:)).^2,1));
        beta_max(i,:) = beta_pca(i,:,index);
    end
% Step 4: Orthogonalization 
    [tdr,~] = qr(beta_max');
    tdr = tdr(:,N_Target);
end