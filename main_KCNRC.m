tic
clear;
%% 
%%%%%%%%%%%%%%%%% orl人脸库 %%%%%%%%%%%%%%%%%
%下载数据集
disp('****下载数据集...****');
download_ORL(); 

load ORL_dat1;
p=[10,25,50,80]; 

allfor=1;

CNRC_r=zeros(1,4);
KCNRC_G_r=zeros(1,4);
KCNRC_P_r=zeros(1,4);
for j = 1:allfor
    disp(j);
randnum=randperm(10);
train_rand=[];
test_rand=[];
tr_lab=[];
for i=1:max(img_lab1)
    class_index=find(img_lab1==i);
    tr_rand_index=randnum(1:5);
    te_rand_index=randnum(6:10);
    tr_rand=class_index(tr_rand_index);
    te_rand=class_index(te_rand_index);
    train_rand=[train_rand tr_rand];
    test_rand=[test_rand te_rand];
    
    train_lab=img_lab1(class_index(1:5));
    tr_lab=[tr_lab train_lab];
end
tr_dat=img_dat1(:,train_rand);
tt_dat=img_dat1(:,test_rand);

[orl_CNRC_r]=orl_cnrc(p,tr_dat,tt_dat,tr_lab);

[orl_kcnrc_G_r]=orl_kcnrc_G(p,tr_dat,tt_dat,tr_lab);
[orl_kcnrc_P_r]=orl_kcnrc_P(p,tr_dat,tt_dat,tr_lab);
CNRC_r=CNRC_r+orl_CNRC_r;

KCNRC_G_r=KCNRC_G_r+orl_kcnrc_G_r;
KCNRC_P_r=KCNRC_P_r+orl_kcnrc_P_r;
end

CNRC_r=CNRC_r./allfor;

KCNRC_G_r=KCNRC_G_r./allfor;
KCNRC_P_r=KCNRC_P_r./allfor;

plot(p,CNRC_r,'k:',p,KCNRC_P_r,'k-.',p,KCNRC_G_r,'k-');
xlabel('Feature Dimension');
ylabel('Recognition Rate');
legend('CNRC','KCNRC(Polynomial)','KCNRC(Guassian)','Location','southeast');


% plot(p,CNRC_r,'k:',p,KCNRC_P_r,'k-.',p,KCNRC_G_r,'k-');
% xlabel('Feature Dimension');
% ylabel('Recognition Rate');
% legend('CNRC','KCNRC(Polynomial)','KCNRC(Guassian)','Location','southeast');
%% 
%%%%%%%%%%%%%%%%% extended yale 人脸库 %%%%%%%%%%%%%%%%%
% load extended_yale_dat;
% 
% CNRC_r=zeros(1,4);
% KCNRC_G_r=zeros(1,4);
% % KCNRC_P_r=zeros(1,4);
% 
% allfor=20;
% 
% p=[30,56,120,504];
% for j = 1:allfor
%     disp(j);
% train_rand=[];
% test_rand=[];
% tr_lab=[];
% for i=1:max(imglabel)
%     class_index=find(imglabel==i);
%     peoplenum=length(find(imglabel==i));
%     randnum=randperm(peoplenum);
%     tr_rand_index=randnum(1:32);
%     te_rand_index=randnum(33:peoplenum);
%     tr_rand=class_index(tr_rand_index);
%     te_rand=class_index(te_rand_index);
%     train_rand=[train_rand tr_rand];
%     test_rand=[test_rand te_rand];
%     
%     train_lab=imglabel(class_index(1:32));
%     tr_lab=[tr_lab train_lab];
% end
% tr_dat=imgmat(:,train_rand);
% tt_dat=imgmat(:,test_rand);
% 
% [e_yale_CNRC_r]=e_yale_cnrc(p,imglabel,test_rand,tr_dat,tt_dat,tr_lab);
%  
% [e_yale_kcnrc_G_r]=e_yale_kcnrc_G(p,imglabel,test_rand,tr_dat,tt_dat,tr_lab);
% [e_yale_kcnrc_P_r]=e_yale_kcnrc_P(p,imglabel,test_rand,tr_dat,tt_dat,tr_lab);
% 
% CNRC_r=CNRC_r+e_yale_CNRC_r;
% 
% KCNRC_G_r=KCNRC_G_r+e_yale_kcnrc_G_r;
% KCNRC_P_r=KCNRC_P_r+e_yale_kcnrc_P_r;
% end
% 
% 
% 
% CNRC_r=CNRC_r./allfor;
% 
% KCNRC_G_r=KCNRC_G_r./allfor;
% KCNRC_P_r=KCNRC_P_r./allfor;

% plot(p,CNRC_r,'k:',p,KCNRC_P_r,'k-.',p,KCNRC_G_r,'k-');
% xlabel('Feature Dimension');
% ylabel('Recognition Rate');
% legend('CNRC','KCNRC(Polynomial)','KCNRC(Guassian)','Location','southeast');
toc