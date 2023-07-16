function [sys,x0,str,ts] = ctrl_iterative(t,x,u,flag)
switch flag
case 0
    [sys,x0,str,ts] = mdlInitializeSizes;
case 3
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end 

function [sys,x0,str,ts] = mdlInitializeSizes
sizes = simsizes;           % ��������ģ������Ľṹ����simsizes������
sizes.NumContStates  = 0;   % ģ������״̬�����ĸ���
sizes.NumDiscStates  = 0;   % ģ����ɢ״̬�����ĸ���
sizes.NumOutputs     = 2;   % ģ����������ĸ���
sizes.NumInputs      = 4;   % ģ����������ĸ���
sizes.DirFeedthrough = 1;   % ģ���Ƿ����ֱ�ӹ�ͨ��ֱ�ӹ�ͨ�ҵ������������  %ֱ�ӿ�������� 
sizes.NumSampleTimes = 1;   % ģ��Ĳ���ʱ�������������һ��
sys = simsizes(sizes);      % ������󸳸�sys��� 
x0  = [];
str = [];
ts  = [0 0];

function sys = mdlOutputs(t,x,u)
e1=u(1);e2=u(2);
de1=u(3);de2=u(4);

e = [e1 e2]';
de = [de1 de2]';

l = 1.00;
L = l * eye(2);
gamma = 0.60;
Gamma = gamma * eye(2);
Tol = L * e + Gamma * de;    % PD�͵���ѧϰ������

sys(1)=Tol(1);
sys(2)=Tol(2);
