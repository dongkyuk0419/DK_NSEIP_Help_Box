function [X_tdr] = TDR_test(X, pca_info,N_subspace)  
    X_flat = reshape(X, [prod(size(X,1:2)),size(X,3)]);
    X_pca = reshape((pca_info.pcaD*(X_flat - pca_info.Xmean)')',size(X));
    X_pca_sub = X_pca(:,:,1:N_subspace);
    X_pca_sub_flat = reshape(X_pca_sub,[prod(size(X_pca_sub,1:2)),N_subspace]);
    X_T = X_pca_sub_flat * pca_info.dir_T';
    X_T = reshape(X_T,[size(X_pca_sub,1:2),size(pca_info.dir_T,1)]);
    

% Step 5: Condition Independent Componenets

    X_remain = X_pca_sub_flat;
    for i = 1:size(pca_info.dir_T,1)
        X_remain = X_remain - sum(X_pca_sub_flat.*repmat(pca_info.dir_T(i,:),size(X_pca_sub_flat,1),1),2) * pca_info.dir_T(i,:);
    end
    X_remain = X_remain-pca_info.X2mean;
    X_CI = reshape((X_remain * pca_info.dir_CI'),[size(X_pca_sub,1:2),size(pca_info.dir_CI,1)]);

    X_tdr = [];
    for i = 1:size(pca_info.dir_T,1)
        X_tdr(:,:,i) = X_T(:,:,1);
    end
    counter = 1;
    for i = size(pca_info.dir_T,1)+1:size(pca_info.dir_T,1)+size(pca_info.dir_CI,1)
        X_tdr(:,:,i) = X_CI(:,:,counter);
        counter = counter + 1;
    end
      
end