% ACO for TSP
% main function

%% ��ջ�������
clear

%% ��������
% ����ʡ���ֱϽ�еľ�γ��
X =[117.00, 36.68     % ɽ��
    115.48, 38.03     % �ӱ�
    125.35, 43.88     % ����
    127.63, 47.75     % ������
    123.38, 41.80     % ����
    111.67, 41.82     % ���ɹ�
    87.68,  43.77     % �½�
    103.73, 36.03     % ����
    106.27, 37.47     % ����
    112.53, 37.87     % ɽ��
    108.95, 34.27     % ����
    113.65, 34.77     % ����
    117.28, 31.86     % ����
    119.78, 32.05     % ����
    120.20, 30.27     % �㽭
    118.30, 26.08     % ����
    113.23, 23.17     % �㶫
    115.90, 28.68     % ����
    110.35, 20.02     % ����
    108.32, 22.82     % ����
    106.72, 26.57     % ����
    113.00, 28.22     % ����
    114.30, 30.58     % ����
    104.07, 30.67     % �Ĵ�
    102.73, 25.05     % ����
    91.00,  30.60     % ����
    96.75,  36.57     % �ຣ
    117.20, 39.13     % ���
    121.55, 31.20     % �Ϻ�
    106.45, 29.57     % ����
    116.42, 39.92     % ����
    121.30, 25.03     % ̨��
    114.10, 22.20     % ���
    113.50, 22.20];   % ����

% % ����MATLAB����perms����������10��Ԫ�ص�ȫ����
% % ���X����ǰ10��
% 
% X =[117.00, 36.68     % ɽ��
%     115.48, 38.03     % �ӱ�
%     125.35, 43.88     % ����
%     127.63, 47.75     % ������
%     123.38, 41.80     % ����
%     111.67, 41.82     % ���ɹ�
%     87.68,  43.77     % �½�
%     103.73, 36.03     % ����
%     106.27, 37.47     % ����
%     112.53, 37.87];   % ɽ��

%% ������м��໥����
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

%% ��ʼ������
m = 1000;                              % ��������50
alpha = 1;                           % ��Ϣ����Ҫ�̶�����
beta = 5;                            % ����������Ҫ�̶�����
rho = 0.1;                           % ��Ϣ�ػӷ�����
Q = 1;                               % ��ϵ��
Eta = 1./D;                          % ��������
Tau = ones(n,n);                     % ��Ϣ�ؾ���
Table = zeros(m,n);                  % ·����¼��
iter = 1;                            % ����������ֵ
iter_max = 200;                      % ����������
Route_best = zeros(iter_max,n);      % �������·��       
Length_best = zeros(iter_max,1);     % �������·���ĳ���  
Length_ave = zeros(iter_max,1);      % ����·����ƽ������  

%% ����Ѱ�����·��
while iter <= iter_max
    % ��������������ϵ�������
      start = zeros(m,1);
      for i = 1:m
          temp = randperm(n);
          start(i) = temp(1);
      end
      Table(:,1) = start; 
      % ������ռ�
      X_index = 1:n;
      % �������·��ѡ��
      for i = 1:m
          % �������·��ѡ��
         for j = 2:n
             tabu = Table(i,1:(j - 1));           % �ѷ��ʵĳ��м���(���ɱ�)
             allow_index = ~ismember(X_index,tabu);
             allow = X_index(allow_index);  % �����ʵĳ��м���
             P = allow;
             % ������м�ת�Ƹ���
             for k = 1:length(allow)
                 P(k) = Tau(tabu(end),allow(k))^alpha * Eta(tabu(end),allow(k))^beta;
             end
             P = P/sum(P);
             % ���̶ķ�ѡ����һ�����ʳ���
             Pc = cumsum(P);     
            target_index = find(Pc >= rand); 
            target = allow(target_index(1));
            Table(i,j) = target;
         end
      end
      % ����������ϵ�·������
      Length = zeros(m,1);
      for i = 1:m
          Route = Table(i,:);
          for j = 1:(n - 1)
              Length(i) = Length(i) + D(Route(j),Route(j + 1));
          end
          Length(i) = Length(i) + D(Route(n),Route(1));
      end
      % �������·�����뼰ƽ������
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
      % ������Ϣ��
      Delta_Tau = zeros(n,n);
      % ������ϼ���
      for i = 1:m
          % ������м���
          for j = 1:(n - 1)
              Delta_Tau(Table(i,j),Table(i,j+1)) = Delta_Tau(Table(i,j),Table(i,j+1)) + Q/Length(i);
          end
          Delta_Tau(Table(i,n),Table(i,1)) = Delta_Tau(Table(i,n),Table(i,1)) + Q/Length(i);
      end
      Tau = (1-rho) * Tau + Delta_Tau;
    % ����������1�����·����¼��
    iter = iter + 1;
    Table = zeros(m,n);
end

%% �����ʾ
[Shortest_Length,index] = min(Length_best);
Shortest_Route = Route_best(index,:);
disp(['��̾���:' num2str(Shortest_Length)]);
OutputPath(Shortest_Route);

%% ��ͼ
figure(1)
plot([X(Shortest_Route,1);X(Shortest_Route(1),1)],...
     [X(Shortest_Route,2);X(Shortest_Route(1),2)],'o-');
grid on
for i = 1:size(X,1)
    text(X(i,1),X(i,2),['   ' num2str(i)]);
end
text(X(Shortest_Route(1),1),X(Shortest_Route(1),2),'       ���');
text(X(Shortest_Route(end),1),X(Shortest_Route(end),2),'       �յ�');
xlabel('����λ�ú�����')
ylabel('����λ��������')
title(['��Ⱥ�㷨�Ż�·��(��̾���:' num2str(Shortest_Length) ')'])
figure(2)
plot(1:iter_max,Length_best,'b',1:iter_max,Length_ave,'r:')
legend('��̾���','ƽ������')
xlabel('��������')
ylabel('����')
title('������̾�����ƽ������Ա�')
