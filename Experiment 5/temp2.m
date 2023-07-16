err_goal = 0.001; lr = 30;
max_epoch = 10000;

X = [0.1 0.7 0.8 0.8 1.0 0.3 0.0 -0.3 -0.5 -1.5; 
     1.2 1.8 1.6 0.6 0.8 0.5 0.2 0.8 -1.5 -1.3];
T = [1 1 1 0 0 1 1 1 0 0;
     0 0 0 0 0 1 1 1 1 1];
[M, N] = size(X); [L, N] = size(T);
Wij = rand(L, M);  y = 0; b = rand(L);

for epoch = 1 : max_epoch
    NETi = Wij * X;
    for j = 1 : N
        for i = 1 : L
            if NETi(i,j) >= b(i)
                y(i,j) = 1;
            else 
                y(i,j) = 0;
            end 
        end
    end
    
    E = T - y; EE = zeros(L,1);
    for j = 1 : N
        for i = 1 : L
            EE(i) = EE(i) + abs (E(i,j));
        end
    end
    if EE < err_goal
        break
    end
    for i = 1 : L
        if EE(i,:) >= err_goal 
            Wij(i,:) = Wij(i,:) + lr * E(i,:) * X';
            if i == 1
                b(i) = b(i) + sqrt(EE(i));
            else
                b(i) = b(i) - sqrt(EE(i));
            end
        end
    end
    
end

epoch,Wij,b

%ÑéÖ¤
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
    disp("right")
else
    disp("false")
end

y