function result_SP=RO_SP_DC_uncertain_game(data_MP,price_RT)
%% ��������
N=50;%�綯��������
%�������(08:00-09:00Ϊʱ��1)
%�綯������������(08:00-09:00Ϊʱ��1)
EVdata=[6,40,15,10,24,105;6,32,16,2,9,132;3,24,8,11,23,89;6,24,12,13,22,97;6,40,25,1,8,101;6,40,16,12,23,175;3,24,8,10,24,35;10,40,20,2,8,88;10,40,18,11,24,112;10,64,25,11,23,66];
%����õ��Ĳ�ͬ���͵綯�����ı���
ratio_initial=EVdata(:,6)/1000;%����ֲ�
%% ��ģ
pch=data_MP.pch;pdis=data_MP.pdis;price_EV=data_MP.price_EV;Pb_DA=data_MP.Pb_DA;price_DA=data_MP.price_DA;%³������������
Pch=sdpvar(24,1);%����ϵͳ���
Pdis=sdpvar(24,1);%����ϵͳ�ŵ�
S_ESS=sdpvar(24,1);%����ϵͳ����״̬
Pb_RT=sdpvar(24,1);%ʵʱ������
Ps_RT=sdpvar(24,1);%ʵʱ�۵���
ratio=sdpvar(10,1);%��ͬ���͵綯�����ķֲ�
C_ESS=[0<=Pch<=250,0<=Pdis<=250,200<=S_ESS<=950,
    S_ESS(1)==500+0.95*Pch(1)-Pdis(1)/0.95,
    S_ESS(2:24)==S_ESS(1:23)+0.95*Pch(2:24)-Pdis(2:24)/0.95,
    S_ESS(24)==500];%����ϵͳԼ������
C_CS=[0<=Pb_RT<=500,0<=Ps_RT<=500,Pb_DA+Pb_RT+Pdis+N*pdis*ratio==Ps_RT+Pch+N*pch*ratio];%������Լ������
obj_inner=sum(-(price_RT+0.001).*Pb_RT+(price_RT-0.001).*Ps_RT);%�ڲ�����Ŀ�꺯��(���)
Constraints_inner=[C_ESS,C_CS];%�ڲ�����Լ������
ops=sdpsettings('kkt.dualbound',0);%�����ж�ż�߽����
[KKTsystem,details]=kkt(Constraints_inner,-obj_inner,ratio,ops);%�ڲ������KKT����
C_RO=[sum(ratio)==1,0<=ratio<=1,sum(abs(ratio-ratio_initial))<=log(20/(1-0.99))*10/2000,abs(ratio-ratio_initial)<=log(20/(1-0.99))/2000];%��ɢ��������Լ��
%% ���
Constraints_outer=[KKTsystem,C_RO];%�������Լ������
obj_outer=-price_DA'*Pb_DA+sum(-(price_RT+0.001).*Pb_RT+(price_RT-0.001).*Ps_RT)+N*price_EV'*(pch-pdis)*ratio;%�������Ŀ�꺯��(�����̵�����)
ops=sdpsettings('solver','gurobi','gurobi.FeasibilityTol',1e-9,'gurobi.IntFeasTol',1e-9,'gurobi.MIPGap',1e-9,'gurobi.OptimalityTol',1e-9);%���������,MILP����
result=optimize(Constraints_outer,obj_outer,ops)%�����С������
result_SP.ratio=double(ratio);result_SP.obj=double(obj_outer);
end

