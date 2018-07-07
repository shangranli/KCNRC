function [rerate_r]=orl_cnrc(p,tr_dat,tt_dat,tr_lab)
kappa=0.001;
eta=0.01;
rerate_r=p;
rate=1;
% [d_tr_dat,project_mat,allmean]=PCA(tr_dat,100); 
for f=p
    
    disp(['>>orl_crc,',num2str(f)]);
    
    right_r=0;
    
    %训练集pca降维
%     [T,Dictionary]=lfda(d_tr_dat,tr_lab',f);
    [Dictionary,project_mat,allmean]=PCA(tr_dat,f); 
    r=1:max(tr_lab);%存放残差
    distand=1:size(tr_dat,2);
    %% 
    for i=1:size(tt_dat,2)%开始测试
        if ~mod(i,50)
            disp(['...orl_cnrc,test,no.',num2str(i),',all,',num2str(size(tt_dat,2))]);
        end
        testvector=tt_dat(:,i)-allmean;
        protest=project_mat'*testvector;
        protest=protest/norm(protest);
        
        for j=1:size(tr_dat,2)
            distand(j)=norm(protest-Dictionary(:,j));
        end
        dist_matrix=diag(distand);
        
        xp=(Dictionary'*Dictionary+kappa*eye(size(Dictionary,2))+eta*dist_matrix)\Dictionary'*protest;
%% 
 %%%%%%%%%%%%%%%%%%%%%%%%%分类%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        beta=zeros(size(tr_dat,2),1);
        for k=1:max(tr_lab) 
            beta(tr_lab==k,:)=xp(tr_lab==k,:);
            r(k)=norm(protest-Dictionary*beta,2)/norm(beta(tr_lab==k,:));
            beta=zeros(size(tr_dat,2),1);
        end
        [min_r,index_r]=min(r);
        if index_r == tr_lab(i)
            right_r=right_r+1;
        end
          
    end  
    %% 
%%%%%%%%%%%%%%%%%%%%%% 计算识别率 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    rerate_r(rate)=right_r/size(tt_dat,2);
    rate=rate+1;
end