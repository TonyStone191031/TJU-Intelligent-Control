% ���ò���
err_goal = 0.001; lr = 30;  % ѧϰ��
max_epoch = 10000;

X = [0.1 0.7 0.8 0.8 1.0 0.3 0.0 -0.3 -0.5 -1.5; 
     1.2 1.8 1.6 0.6 0.8 0.5 0.2 0.8 -1.5 -1.3];
T = [1 1 1 0 0 1 1 1 0 0;
     0 0 0 0 0 1 1 1 1 1];
[M, N] = size(X); [L, N] = size(T);
Wij = rand(L, M); y = 0; b = rand(L, 1);

% ѵ��
for epoch = 1 : max_epoch
    NETi = Wij * X;
    for j = 1 : N
        for i = 1 : L
            if NETi(i,j) >= b(i)    % ���㱾��ѵ����������
                y(i,j) = 1;
            else 
                y(i,j) = 0;
            end 
        end
    end
    
    % ���㱾��ѵ���е����
    E = T - y; EE = zeros(L, 1);
    for j = 1 : N
        for i = 1 : L
            EE(i) = EE(i) + abs(E(i,j));
        end
    end
    if EE < err_goal    % ѵ����ϣ�����ѵ��
        break
    end
    
    % ����ѵ��δ�ﵽ����Ҫ�󣬵�����������
    for i = 1 : L
        if EE(i,:) >= err_goal 
            Wij(i,:) = Wij(i,:) + lr * E(i,:) * X'; % ����������Ȩϵ��
            if i == 1
                b(i) = b(i) + sqrt(EE(i));  % �����������Ԫ����ֵ
            else
                b(i) = b(i) - sqrt(EE(i));  % �����������Ԫ����ֵ
            end
        end
    end
    
end

epoch,Wij,b     % ��ʾѵ������ʱ�ļ����������Ȩϵ������ֵ

% ѵ��������ѵ���������
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
    disp("right")   % ѵ������ﵽҪ��
else
    disp("false")   % ѵ�����δ�ﵽҪ��
end

y   % ���ѵ�����

% ��ͼ
x1 = -2 : 0.001 : 2;
plotpv(X,T)
hold on
x2 = 1/Wij(1,2) * (b(1) - Wij(1,1)*x1); plot(x1,x2)
x2 = 1/Wij(2,2) * (b(2) - Wij(2,1)*x1); plot(x1,x2)
xlim([-2,2])
ylim([-2,2])