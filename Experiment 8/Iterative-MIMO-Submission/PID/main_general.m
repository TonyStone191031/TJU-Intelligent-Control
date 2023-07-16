% 多入多出简单PD控制
clear
close all;

t = 0:0.01:1;   % 设置仿真时间
t = t';
k(1:101) = 0;   % 总共101个点
k = k';
T1(1:101) = 0; %控制系统输入，共两个输入都为列向量
T1 = T1';
T2 = T1;
T = [T1 T2];

k1(1:101) = 0;    %Total initial points k1变量的第1个到101个元素全部赋为0

k1 = k1';   %k1为列向量
E1(1:101) = 0;
E1 = E1';
E2 = E1;    %E2，E3，E4全为列向量
E3 = E1;
E4 = E1;
E = [E1 E2 E3 E4];  % 用来保存两个信号的误差和误差的导数项

M = 10;%%%%%%%%%%最大迭代次数，可以修改
times = zeros(1,M+1);
e1i = zeros(1,M+1);
e2i = zeros(1,M+1);
de1i = zeros(1,M+1);
de2i = zeros(1,M+1);

for i = 0:1:M    %  M迭代次数
 i              %在命令窗口显示迭代了多少了

sim('sim_mdl_general',[0,1]); % simulink仿真

% 迭代后输出
x1 = x(:,1);
x2 = x(:,2);

% 两个期望值和各自的导数项存放在xd中
x1d = xd(:,1);
x2d = xd(:,2);
dx1d = xd(:,3);
dx2d = xd(:,4);

% 误差和误差导数放在E中
e1 = E(:,1);
e2 = E(:,2);
de1 = E(:,3);
de2 = E(:,4);
e = [e1 e2]';
de = [de1 de2]';

figure(1);
subplot(211);   % subplot(m,n,i)将窗口分成m*n幅子图，第i幅为当前图，编号顺序为：从左到右从上到下
hold on;
plot(t,x1,'b',t,x1d,'r');   % 绘制第一个输出和期望轨迹，放在迭代过程中，有动态效果每迭代一次绘制一次，形象
legend('x1','x1d')
xlabel('time'); ylabel('x1, x1d');

subplot(212);   % 绘制第二个输出
hold on;
plot(t,x2,'b',t,x2d,'r');
legend('x2','x2d')
xlabel('time'); ylabel('x2, x2d');

j = i+1;
times(j) = i;   % 迭代的次数用数组表示 便于绘制迭代次数和误差的曲线
e1i(j) = max(abs(e1));
e2i(j) = max(abs(e2));
de1i(j) = max(abs(de1));
de2i(j) = max(abs(de2));
end          % 迭代过程结束

% 绘图
figure(2);
subplot(211);
plot(t,x1d,'r',t,x1,'b');   % 绘制第一个的输出和期望轨迹（最后迭代的）
legend('x1d','x1')
xlabel('time');ylabel('x1的输出跟踪');
subplot(212);   % 绘制第二个的输出和期望轨迹（最后迭代的）
plot(t,x2d,'r',t,x2,'b');
legend('x2d','x2')
xlabel('time'); ylabel('x2的输出跟踪');

figure(3);  % 绘制系统控制输入
subplot(211);
plot(t,T(:,1),'r');
xlabel('time'); ylabel('第一个控制输入');
subplot(212);
plot(t,T(:,2),'r');
xlabel('time'); ylabel('第二个控制输入');

figure(4);  % 绘制误差与迭代次数的关系
plot(times,e1i,'*-r',times,e2i,'o-b');
legend('e1i','e2i')
title('最大误差绝对值与迭代次数的关系');
xlabel('迭代次数'); ylabel('误差一和误差二');
