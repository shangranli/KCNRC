function [p_d_mat,project_mat,allmean]=PCA(initialize_mat,p)

%����:
     %  initialize_mat: ԭ��ά����
     %  p: Ҫ��ά������ά��
%���:
     %p_d_mat: ��ά���pά����
     %project_mat: ͶӰ����
     %allmean: ��ֵ
%%%%%%%%%%%%%%%%%%%%%  lisr666@qq.com  %%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%%%%%%%%%%%%  2017/5/16  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
    [features,rows]=size(initialize_mat);%ԭ���������(ά)����������
    allmean=mean(initialize_mat,2);%������ԭ����ľ�ֵ
    meanmat=zeros(features,rows);%��ʼ����ֵ����
    
    %�����ֵ��ԭ���������м�ȥ��ֵ
    for i=1:rows  
        meanmat(:,i)=initialize_mat(:,i)-allmean;
    end
    
    %���ò�ֵ���󹹽�Э������󣬼�C=meanmat*meanmat';
    %Ȼ�����C������ֵ����������������C��ά�����󣬼������̫��
    %��������ֵ�ֽ�ԭ�����Э�������C=meanmat*meanmat'������ֵ����������
    %����������meanmat'*meanmat������ֵ��������ԭЭ�������meanmat*meanmat'
    %������ֵ����������
    %[U,S,V]=svd(meanmat)
    
    [v,smat]=eig(meanmat'*meanmat);%���V���������ֵ
    %������ֵȡ�����ŵ������У�����������
    w=1:rows;
    for i=1:rows
        w(i)=smat(i,i);
    end
    
    project_mat=zeros(features,p);%��ʼ��ͶӰ����
    max_v=v(:,rows-p+1:rows); %ȡ��������ֵ��Ӧ����������
    %��������ֵ
    sigma=sqrt(w(rows-p+1:rows));
    %����ͶӰ����U_i=A*V_i/sqrt(sigma)
    for i=1:p
        project_mat(:,i)=meanmat*max_v(:,i)/sigma(i);
    end
    %���㽵ά��ľ���
    p_d_mat=project_mat'*meanmat;
    %L_2 ��һ
    for i=1:size(p_d_mat,2)
        p_d_mat(:,i)=p_d_mat(:,i)/norm(p_d_mat(:,i));
    end
end