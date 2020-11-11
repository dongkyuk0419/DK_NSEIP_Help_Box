function [X_tdr, pca_info,explained_variance] = TDR_train(X, Target, N_subspace, N_T, N_CI)  
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
    X_flat = X(:,:);
    X_flat = reshape(X, [prod(size(X,1:2)),size(X,3)]);
    pca_info.Xmean = mean(X_flat,1);
    [pca_info.pcaD,a,b] = pca(X_flat);
    X_pca = reshape((pca_info.pcaD*(X_flat - pca_info.Xmean)')',size(X));
    X_pca_sub = X_pca(:,:,1:N_subspace);

% Step 3: Identify the regression subspace
    F = [Target_one_hot,ones(size(X,1),1)];
    beta = zeros(N_Target+1,size(X,3),size(X,2));
    beta_pca = zeros(N_Target,N_subspace,size(X,2));
    % linear regression
    for i = 1:size(X,3)
        beta(:,i,:) = pinv(F)*X(:,:,i);
    end
    % subspace projection
    for i = 1:N_Target
        temp = pca_info.pcaD*squeeze(beta(i,:,:));
        beta_pca(i,:,:) = temp(1:N_subspace,:);    
    end
    % regression subspace identificatin
    beta_max = zeros(N_Target,N_subspace);
    val = zeros(N_Target,1);
    for i = 1:N_Target
        % I will use L2 norm to compare the norms
        [val(i),index] = max(sum(squeeze(beta_pca(i,:,:)).^2,1));
        beta_max(i,:) = beta_pca(i,:,index);
    end

% Sort by explained variance
    X_pca_sub_flat = reshape(X_pca_sub,[prod(size(X_pca_sub,1:2)),N_subspace]);
    Total_variance = sum(sum(sum(X_pca_sub_flat.^2)));
    
    for i = 1:8
        explained_variance(i) = sum(sum(sum((X_pca_sub_flat - X_pca_sub_flat*beta_max(i,:)'*pinv(beta_max(i,:)')).^2)));
    end
    
    [~,index] = sort(explained_variance,'descend');
%     [~,index] = sort(val,'descend');
    B = beta_max(index,:)';
       
% Step 4: Orthogonalization 
    [tdr,~] = qr(B);
    tdr = tdr(:,1:N_T)';
    pca_info.dir_T = tdr;
    explained_var = 1-explained_variance(index(1:N_T))/Total_variance;
    
% Step 5: Condition Independent Componenets
    X_T = X_pca_sub_flat * tdr';
    X_T = reshape(X_T,[size(X_pca_sub,1:2),N_T]);
    
    X_remain = X_pca_sub_flat;
    for i = 1:size(tdr,1)
        X_remain = X_remain - sum(X_pca_sub_flat.*repmat(tdr(i,:),size(X_pca_sub_flat,1),1),2) * tdr(i,:);
    end
    pca_info.X2mean = mean(X_remain,1);
        
    [pca_info.pcaD2,~,D] = pca(X_remain);
    pca_info.dir_CI = pca_info.pcaD2(:,1:N_CI)';
    X_pca2 = reshape((pca_info.pcaD2*(X_remain - pca_info.X2mean)')',size(X_pca_sub));
    
    X_tdr = zeros([size(X,1:2),N_T+N_CI]);
    
    pca_var = D.^2./sum(D.^2) * (1-sum(explained_var));
    
    for i = 1:N_T
        X_tdr(:,:,i) = X_T(:,:,1);
    end
    counter = 1;
    for i = N_T+1:N_T+N_CI
        X_tdr(:,:,i) = X_pca2(:,:,counter);
        counter = counter + 1;
    end
    
    explained_variance = [explained_var,pca_var(1:N_CI)'];
    
end