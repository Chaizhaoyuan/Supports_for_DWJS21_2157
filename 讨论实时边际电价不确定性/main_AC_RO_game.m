%��ɢ�����ֲ�³���Ż���������������������һ�κ�������
%�ھŸ�ʱ����濪ʼ��08:00-����08:00
%����Լ�������㷨
clear
clc
load DLMP_data
price_RT=1.5*[b_data(9:24);b_data(1:8)];
%�綯������������(08:00-09:00Ϊʱ��1)
EVdata=[6,40,15,10,24,105;6,32,16,2,9,132;3,24,8,11,23,89;6,24,12,13,22,97;6,40,25,1,8,101;6,40,16,12,23,175;3,24,8,10,24,35;10,40,20,2,8,88;10,40,18,11,24,112;10,64,25,11,23,66];
%��ͬ���͵綯�����ı���
ratio=EVdata(:,6)/1000;
data_SP.ratio=ratio;%��ʼ������������ֲ�
for iter=1:2
    result_MP(iter)=RO_MP_AC_uncertain_game(data_SP,price_RT);%���³��������
    result_MP.obj%Ŀ�꺯���Ͻ�
    data_MP=result_MP(iter);%�������⴫������
    result_SP(iter)=RO_SP_AC_uncertain_game(data_MP,price_RT);%���³��������
    data_SP.ratio=[data_SP.ratio,result_SP(iter).ratio];%��ӳ���
    result_SP.obj%Ŀ�꺯���½�
    abs(result_MP(iter).obj-result_SP(iter).obj)/result_MP(iter).obj
    if abs(result_MP(iter).obj-result_SP(iter).obj)/result_MP(iter).obj<=1e-6%���㾫�ȷ�Χ���˳�
        break
    end
end
Pb_DA=data_MP.Pb_DA;
Pb_RT=data_MP.Pb_RT;
Ps_RT=data_MP.Ps_RT;
Pb_DA=[Pb_DA(17:24,1);Pb_DA(1:16,1)];
Pb_RT=[Pb_RT(17:24,1);Pb_RT(1:16,1)];
Ps_RT=[Ps_RT(17:24,1);Ps_RT(1:16,1)];
plot(Pb_DA)
hold on
plot(Pb_RT,'r')
plot(-Ps_RT,'g')
legend('��ǰ����','ʵʱ����','ʵʱ�۵�')
xlim([1,24])
ylim([-550,550])