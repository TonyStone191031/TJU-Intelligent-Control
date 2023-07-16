% This file is the basic model for building a BP-PID control system, with
% Sigmoid introduced as the Activation Function of the hidden layer and the
% output layer. The input is the step input.

% v2 differs from v1 in the initial value of wi and wo.

eta = 1.00; % 学习速率
alpha = 0.05;   % 惯性系数
IN = 4; % 输入层的神经元个数
H = 5; % 隐含层的神经元个数
OUT = 3;    % 输出层的神经元个数

% 初始化隐含层权值 weight_input
wi = [-1.0989   -0.0475   -0.3452   -0.5441;
      -0.1470    0.1134   -0.1749   -0.6774;
      -0.5615   -0.5237   -0.8579   -0.3335;
       0.0251    0.5219   -0.7025   -0.4241;
      -0.7572   -0.1239   -0.4831   -0.5466];
% wi = 0.50 * rands(H, IN);
wi_1 = wi; wi_2 = wi; wi_3 = wi;

% 初始化输出层权值 weight_output
wo = [ 0.5875    0.3870    0.7375    0.9470    0.9214;
       0.7782    0.3825    0.9322    0.9424    1.0308;
       0.8848    0.4161    0.8329    0.2440    0.8414];
% wo = 0.50 * rands(OUT, H);
wo_1 = wo; wo_2 = wo; wo_3 = wo;

x = [0 0 0];    % 定义数组并初始化
u_1 = 0; u_2 = 0; u_3 = 0; u_4 = 0; u_5 = 0;
y_1 = 0; y_2 = 0; y_3 = 0;  % 初始化对象输出

oh = zeros(H, 1);   % 隐含层输出 output_hide
I = oh;
error_1 = 0; error_2 = 0;

ts = 0.001; % 采样周期
tnum = 250;
% 初始化
time = zeros(tnum, 1);
rin = zeros(tnum, 1);
a = zeros(tnum, 1);
yout = zeros(tnum, 1);
error = zeros(tnum, 1);
Kp = zeros(tnum, 1);
Ki = zeros(tnum, 1);
Kd = zeros(tnum, 1);
du = zeros(tnum, 1);
u = zeros(tnum, 1);
dyu = zeros(tnum, 1);   % y(k) 对 u(k) 的偏导
dk = zeros(1, OUT);
delta3 = zeros(1, OUT);
dO = zeros(1, H);
delta2 = zeros(1, H);

for k = 1 : 1 : tnum
    time(k) = k * ts;
    rin(k) = 1;
    a(k) = 1.2 * (1 - 0.8*exp(-0.1*k));
    yout(k) = a(k) * y_1/(1 + y_1^2) + u_1;
    error(k) = rin(k) - yout(k);
    xi = [rin(k), yout(k), error(k), 1];    % 神经网络输入
    x(1) = error(k) - error_1;
    x(2) = error(k);
    x(3) = error(k) - 2*error_1 + error_2;
    epid = [x(1); x(2); x(3)];
    I = xi * wi';   % 隐含层输入
    
    for j = 1 : H
        oh(j) = (exp(I(j)) - exp(-I(j))) / (exp(I(j)) + exp(-I(j)));  % 隐含层输出(正负对称的Sigmoid函数)
    end
    K = wo * oh;    % 输出层输入
    for n = 1 : OUT
        K(n) = 1 / (1 + exp(-K(n)));  % 输出层输出(非负的Sigmoid函数)
    end
    Kp(k) = K(1); Ki(k) = K(2); Kd(k) = K(3);   % 输出层输出的PID三个系数
    Kpid = [Kp(k), Ki(k), Kd(k)];
    
    du(k) = Kpid * epid;
    
    u(k) = u_1 + du(k);
    
    % 限制输出
    if u(k) >= 10
        u(k) = 10;
    end
    if u(k) <= -10
        u(k) = -10;
    end
    
    dyu(k) = sign((yout(k) - y_1) / (u(k) - u_1 + 0.0000001));
    
    % 输出层权值整定
    for j = 1 : OUT
        dk(j) = exp(-K(j)) / (1 + exp(-K(j)))^2;
    end
    for n = 1 : OUT
        delta3(n) = error(k) * dyu(k) * epid(n) * dk(n);
    end    
    
    for n = 1 : OUT
        for i = 1 :H
            d_wo = eta * delta3(n) * oh(i) + alpha * (wo_1 - wo_2);
        end
    end
    wo = wo_1 + d_wo;
    
    % 隐含层权值整定
    for i = 1 : H
        dO(i) = 4/(exp(I(i)) + exp(-I(i)))^2;
    end
    segma = delta3 * wo;
    for i = 1 : H
        delta2(i) = dO(i) * segma(i);
    end
    d_wi = eta * delta2' * xi + alpha * (wi_1 - wi_2);
    wi = wi_1 + d_wi;
    
    % 参数更新
    u_5 = u_4; u_4 = u_3; u_3 = u_2; u_2 = u_1; u_1 = u(k);
    y_3 = y_2; y_2 = y_1; y_1 = yout(k);
    wo_3 = wo_2; wo_2 = wo_1; wo_1 = wo;
    wi_3 = wi_2; wi_2 = wi_1; wi_1 = wi;
    error_2 = error_1; error_1 = error(k);
    
end

% 绘图
figure(1)
plot(time, rin, 'r', time, yout, 'b');
title('控制系统的输入输出');
xlabel('time'); ylabel('rin, yout');
legend('系统输入','系统输出');

figure(2)
plot(time, error, 'r'); title('误差');
xlabel('time'); ylabel('error');

figure(3)
plot(time, u, 'r'); title('控制器输出');
xlabel('time'); ylabel('u');

figure(4)
subplot(3,1,1); plot(time, Kp, 'r');
xlabel('time'); ylabel('Kp');
subplot(3,1,2); plot(time, Ki, 'g');
xlabel('time'); ylabel('Ki');
subplot(3,1,3); plot(time, Kd, 'b');
xlabel('time'); ylabel('Kd');
title('PID参数');
