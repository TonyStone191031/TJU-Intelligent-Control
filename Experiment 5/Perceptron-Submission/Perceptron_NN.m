% 设置参数
err_goal = 0.001; lr = 30;  % 学习率
max_epoch = 10000;

X = [0.1 0.7 0.8 0.8 1.0 0.3 0.0 -0.3 -0.5 -1.5; 
     1.2 1.8 1.6 0.6 0.8 0.5 0.2 0.8 -1.5 -1.3];
T = [1 1 1 0 0 1 1 1 0 0;
     0 0 0 0 0 1 1 1 1 1];
[M, N] = size(X); [L, N] = size(T);
Wij = rand(L, M); y = 0; b = rand(L, 1);

% 训练
for epoch = 1 : max_epoch
    NETi = Wij * X;
    for j = 1 : N
        for i = 1 : L
            if NETi(i,j) >= b(i)    % 计算本轮训练的输出结果
                y(i,j) = 1;
            else 
                y(i,j) = 0;
            end 
        end
    end
    
    % 计算本轮训练中的误差
    E = T - y; EE = zeros(L, 1);
    for j = 1 : N
        for i = 1 : L
            EE(i) = EE(i) + abs(E(i,j));
        end
    end
    if EE < err_goal    % 训练完毕，结束训练
        break
    end
    
    % 本轮训练未达到分类要求，调整输出层参数
    for i = 1 : L
        if EE(i,:) >= err_goal 
            Wij(i,:) = Wij(i,:) + lr * E(i,:) * X'; % 调整输出层加权系数
            if i == 1
                b(i) = b(i) + sqrt(EE(i));  % 调整输出层神经元的阈值
            else
                b(i) = b(i) - sqrt(EE(i));  % 调整输出层神经元的阈值
            end
        end
    end
    
end

epoch,Wij,b     % 显示训练结束时的计算次数、加权系数和阈值

% 训练结束，训练结果检验
X1 = X;
for j = 1 : N
    for i = 1 : L
        if NETi(i,j) >= b(i)
            y(i,j) = 1;
        else 
            y(i,j) = 0;
        end 
    end
end

if y == T
    disp("right")   % 训练结果达到要求
else
    disp("false")   % 训练结果未达到要求
end

y   % 输出训练结果

% 画图
x1 = -2 : 0.001 : 2;
plotpv(X,T)
hold on
x2 = 1/Wij(1,2) * (b(1) - Wij(1,1)*x1); plot(x1,x2)
x2 = 1/Wij(2,2) * (b(2) - Wij(2,1)*x1); plot(x1,x2)
xlim([-2,2])
ylim([-2,2])