function [rerate_r]=orl_kcnrc_G(p,tr_dat,tt_dat,tr_lab)
kappa=0.1;
eta=0.001;
rerate_r=p;
rate=1;
t=3;
for f=p
    right_r=0;
    r=1:max(tr_lab);%存放残差
    
    %降维
    [Dictionary,project_mat,allmean]=PCA(tr_dat,f); 

    [B_T_B]=Guassian_kernel(Dictionary,Dictionary,t);
    

    distand=1:size(tr_dat,2);
    %% 
    for i=1:size(tt_dat,2)%开始测试
        if ~mod(i,50)
            disp(['test,no.',num2str(i),',all,',num2str(size(tt_dat,2))]);
        end
        testvector=tt_dat(:,i)-allmean;
        protest=project_mat'*testvector;
        protest=protest/norm(protest);
        phi_y=Guassian_kernel(protest,protest,t);
   
        for j=1:size(Dictionary,2)
            phi_x=Guassian_kernel(Dictionary(:,j),Dictionary(:,j),t);
             phi_xy=Guassian_kernel(protest,Dictionary(:,j),t);
            distand(j)=sqrt(phi_y-2*phi_xy+phi_x);
        end
        dist_matrix=diag(distand);

        [B_T_Phi]=Guassian_kernel(Dictionary,protest,t);

        xp=(B_T_B+kappa*eye(size(B_T_B,2))+eta*dist_matrix)\B_T_Phi;
%% 
 %%%%%%%%%%%%%%%%%%%%%%%%%分类%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
        for k=1:max(tr_lab) 
            r(k)=norm(B_T_Phi-B_T_B(:,tr_lab==k)*xp(tr_lab==k,:),2)^2/sum(xp(tr_lab==k,:).*xp(tr_lab==k,:));%计算残差
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