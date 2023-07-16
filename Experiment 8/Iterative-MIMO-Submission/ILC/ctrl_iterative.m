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
sizes = simsizes;           % 用于设置模块参数的结构体用simsizes来生成
sizes.NumContStates  = 0;   % 模块连续状态变量的个数
sizes.NumDiscStates  = 0;   % 模块离散状态变量的个数
sizes.NumOutputs     = 2;   % 模块输出变量的个数
sizes.NumInputs      = 4;   % 模块输入变量的个数
sizes.DirFeedthrough = 1;   % 模块是否存在直接贯通（直接贯通我的理解是输入能  %直接控制输出） 
sizes.NumSampleTimes = 1;   % 模块的采样时间个数，至少是一个
sys = simsizes(sizes);      % 设置完后赋给sys输出 
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
Tol = L * e + Gamma * de;    % PD型迭代学习控制律

sys(1)=Tol(1);
sys(2)=Tol(2);
