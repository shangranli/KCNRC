function [rerate_r]=orl_kcnrc_P(p,tr_dat,tt_dat,tr_lab)
kappa=0.05;
eta=0.9;
rerate_r=p;
rate=1;
d=2;

for f=p
    right_r=0;
    r=1:max(tr_lab);%��Ųв�
    
    %��ά
    [Dictionary,project_mat,allmean]=PCA(tr_dat,f); 
    [B_T_B]=Polynomial_kernel(Dictionary,Dictionary,d);

    distand=1:size(tr_dat,2);
    %% 
    for i=1:size(tt_dat,2)%��ʼ����
        if ~mod(i,50)
            disp(['test,no.',num2str(i),',all,',num2str(size(tt_dat,2))]);
        end
        testvector=tt_dat(:,i)-allmean;
        protest=project_mat'*testvector;
        protest=protest/norm(protest);
        phi_y=Polynomial_kernel(protest,protest,d);
   
        for j=1:size(Dictionary,2)
            phi_x=Polynomial_kernel(Dictionary(:,j),Dictionary(:,j),d);
            phi_xy=Polynomial_kernel(protest,Dictionary(:,j),d);
            distand(j)=sqrt(phi_y-2*phi_xy+phi_x);
        end
        dist_matrix=diag(distand);

        [B_T_Phi]=Polynomial_kernel(Dictionary,protest,d);
        xp=(B_T_B+kappa*eye(size(B_T_B,2))+eta*dist_matrix)\B_T_Phi;
%% 
 %%%%%%%%%%%%%%%%%%%%%%%%%����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
        for k=1:max(tr_lab) 
            r(k)=norm(B_T_Phi-B_T_B(:,tr_lab==k)*xp(tr_lab==k,:),2)^2/sum(xp(tr_lab==k,:).*xp(tr_lab==k,:));%����в�
        end
        [min_r,index_r]=min(r);
        if index_r == tr_lab(i)
            right_r=right_r+1;
        end
          
    end  
    %% 
%%%%%%%%%%%%%%%%%%%%%% ����ʶ���� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    rerate_r(rate)=right_r/size(tt_dat,2);
    rate=rate+1;
end