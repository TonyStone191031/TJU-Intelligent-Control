% 被控对象的s函数
function [sys,x0,str,ts] = plant_2(t,x,u,flag)
switch flag
case 0
    [sys,x0,str,ts] = mdlInitializeSizes;
case 1
    sys = mdlDerivatives(t,x,u);
case 3
    sys = mdlOutputs(t,x,u);
case {2,4,9}
    sys = []; 
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

function [sys,x0,str,ts] = mdlInitializeSizes
sizes = simsizes;           % 用于设置模块参数的结构体用simsizes来生成
sizes.NumContStates  = 2;   % 模块连续状态变量的个数
sizes.NumDiscStates  = 0;   % 模块离散状态变量的个数 
sizes.NumOutputs     = 2;   % 模块输出变量的个数（输出和输出的导数）
sizes.NumInputs      = 2;   % 模块输入变量的个数 （模块的控制变量）
sizes.DirFeedthrough = 0;   % 模块是否存在直接贯通
sizes.NumSampleTimes = 1;   % 模块的采样时间个数，至少是一个
sys = simsizes(sizes);      % 设置完后赋给sys输出 
x0  = [0;1];                % 初值
str = [];                   % 保留参数置[]
ts  = [0 0];                % 采样周期设为0表示是连续系统

function sys = mdlDerivatives(t,x,u)
A = [-2 3;1 1];
C = [1 0;0 1];
B = [1 1;0 1];
Gama = 0.95;
norm(eye(2) - C*B*Gama);      % Must be smaller than 1.0

U = [u(1);u(2)];
dx = A*x + B*U;
sys(1) = dx(1);
sys(2) = dx(2);

function sys = mdlOutputs(t,x,u)
sys(1) = x(1);
sys(2) = x(2);
