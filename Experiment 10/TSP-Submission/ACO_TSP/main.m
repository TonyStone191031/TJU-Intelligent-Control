% ACO for TSP
% main function

%% 清空环境变量
clear

%% 导入数据
% 各个省会或直辖市的经纬度
X =[117.00, 36.68     % 山东
    115.48, 38.03     % 河北
    125.35, 43.88     % 吉林
    127.63, 47.75     % 黑龙江
    123.38, 41.80     % 辽宁
    111.67, 41.82     % 内蒙古
    87.68,  43.77     % 新疆
    103.73, 36.03     % 甘肃
    106.27, 37.47     % 宁夏
    112.53, 37.87     % 山西
    108.95, 34.27     % 陕西
    113.65, 34.77     % 河南
    117.28, 31.86     % 安徽
    119.78, 32.05     % 江苏
    120.20, 30.27     % 浙江
    118.30, 26.08     % 福建
    113.23, 23.17     % 广东
    115.90, 28.68     % 江西
    110.35, 20.02     % 海南
    108.32, 22.82     % 广西
    106.72, 26.57     % 贵州
    113.00, 28.22     % 湖南
    114.30, 30.58     % 湖北
    104.07, 30.67     % 四川
    102.73, 25.05     % 云南
    91.00,  30.60     % 西藏
    96.75,  36.57     % 青海
    117.20, 39.13     % 天津
    121.55, 31.20     % 上海
    106.45, 29.57     % 重庆
    116.42, 39.92     % 北京
    121.30, 25.03     % 台湾
    114.10, 22.20     % 香港
    113.50, 22.20];   % 澳门

% % 由于MATLAB函数perms限制最多进行10个元素的全排列
% % 因此X保留前10行
% 
% X =[117.00, 36.68     % 山东
%     115.48, 38.03     % 河北
%     125.35, 43.88     % 吉林
%     127.63, 47.75     % 黑龙江
%     123.38, 41.80     % 辽宁
%     111.67, 41.82     % 内蒙古
%     87.68,  43.77     % 新疆
%     103.73, 36.03     % 甘肃
%     106.27, 37.47     % 宁夏
%     112.53, 37.87];   % 山西

%% 计算城市间相互距离
n = size(X,1);
D = zeros(n,n);
for i = 1:n
    for j = 1:n
        if i ~= j
            D(i,j) = sqrt(sum((X(i,:) - X(j,:)).^2));
        else
            D(i,j) = 0;      
        end
    end    
end

%% 初始化参数
m = 1000;                              % 蚂蚁数量50
alpha = 1;                           % 信息素重要程度因子
beta = 5;                            % 启发函数重要程度因子
rho = 0.1;                           % 信息素挥发因子
Q = 1;                               % 常系数
Eta = 1./D;                          % 启发函数
Tau = ones(n,n);                     % 信息素矩阵
Table = zeros(m,n);                  % 路径记录表
iter = 1;                            % 迭代次数初值
iter_max = 200;                      % 最大迭代次数
Route_best = zeros(iter_max,n);      % 各代最佳路径       
Length_best = zeros(iter_max,1);     % 各代最佳路径的长度  
Length_ave = zeros(iter_max,1);      % 各代路径的平均长度  

%% 迭代寻找最佳路径
while iter <= iter_max
    % 随机产生各个蚂蚁的起点城市
      start = zeros(m,1);
      for i = 1:m
          temp = randperm(n);
          start(i) = temp(1);
      end
      Table(:,1) = start; 
      % 构建解空间
      X_index = 1:n;
      % 逐个蚂蚁路径选择
      for i = 1:m
          % 逐个城市路径选择
         for j = 2:n
             tabu = Table(i,1:(j - 1));           % 已访问的城市集合(禁忌表)
             allow_index = ~ismember(X_index,tabu);
             allow = X_index(allow_index);  % 待访问的城市集合
             P = allow;
             % 计算城市间转移概率
             for k = 1:length(allow)
                 P(k) = Tau(tabu(end),allow(k))^alpha * Eta(tabu(end),allow(k))^beta;
             end
             P = P/sum(P);
             % 轮盘赌法选择下一个访问城市
             Pc = cumsum(P);     
            target_index = find(Pc >= rand); 
            target = allow(target_index(1));
            Table(i,j) = target;
         end
      end
      % 计算各个蚂蚁的路径距离
      Length = zeros(m,1);
      for i = 1:m
          Route = Table(i,:);
          for j = 1:(n - 1)
              Length(i) = Length(i) + D(Route(j),Route(j + 1));
          end
          Length(i) = Length(i) + D(Route(n),Route(1));
      end
      % 计算最短路径距离及平均距离
      if iter == 1
          [min_Length,min_index] = min(Length);
          Length_best(iter) = min_Length;  
          Length_ave(iter) = mean(Length);
          Route_best(iter,:) = Table(min_index,:);
      else
          [min_Length,min_index] = min(Length);
          Length_best(iter) = min(Length_best(iter - 1),min_Length);
          Length_ave(iter) = mean(Length);
          if Length_best(iter) == min_Length
              Route_best(iter,:) = Table(min_index,:);
          else
              Route_best(iter,:) = Route_best((iter-1),:);
          end
      end
      % 更新信息素
      Delta_Tau = zeros(n,n);
      % 逐个蚂蚁计算
      for i = 1:m
          % 逐个城市计算
          for j = 1:(n - 1)
              Delta_Tau(Table(i,j),Table(i,j+1)) = Delta_Tau(Table(i,j),Table(i,j+1)) + Q/Length(i);
          end
          Delta_Tau(Table(i,n),Table(i,1)) = Delta_Tau(Table(i,n),Table(i,1)) + Q/Length(i);
      end
      Tau = (1-rho) * Tau + Delta_Tau;
    % 迭代次数加1，清空路径记录表
    iter = iter + 1;
    Table = zeros(m,n);
end

%% 结果显示
[Shortest_Length,index] = min(Length_best);
Shortest_Route = Route_best(index,:);
disp(['最短距离:' num2str(Shortest_Length)]);
OutputPath(Shortest_Route);

%% 绘图
figure(1)
plot([X(Shortest_Route,1);X(Shortest_Route(1),1)],...
     [X(Shortest_Route,2);X(Shortest_Route(1),2)],'o-');
grid on
for i = 1:size(X,1)
    text(X(i,1),X(i,2),['   ' num2str(i)]);
end
text(X(Shortest_Route(1),1),X(Shortest_Route(1),2),'       起点');
text(X(Shortest_Route(end),1),X(Shortest_Route(end),2),'       终点');
xlabel('城市位置横坐标')
ylabel('城市位置纵坐标')
title(['蚁群算法优化路径(最短距离:' num2str(Shortest_Length) ')'])
figure(2)
plot(1:iter_max,Length_best,'b',1:iter_max,Length_ave,'r:')
legend('最短距离','平均距离')
xlabel('迭代次数')
ylabel('距离')
title('各代最短距离与平均距离对比')
