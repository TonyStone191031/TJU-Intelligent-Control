% GA for solving TSP
% main function

clear

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

NIND=100;       %种群大小
MAXGEN=200;
Pc=0.9;         %交叉概率
Pm=0.10;        %变异概率
GGAP=0.9;      %代沟(Generation gap)
D=Distance(X);  %生成距离矩阵
N=size(D,1);    %(34*34)
%% 初始化种群
Chrom=InitPop(NIND,N);
%% 在二维图上画出所有坐标点
% figure
% plot(X(:,1),X(:,2),'o');
%% 画出随机解的路线图
DrawPath(Chrom(1,:),X)
pause(0.0001)
%% 输出随机解的路线和总距离
disp('初始种群中的一个随机值:')
OutputPath(Chrom(1,:));
Rlength=PathLength(D,Chrom(1,:));
disp(['总距离：',num2str(Rlength)]);
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
%% 优化
gen=0;
figure;
hold on;box on
xlim([0,MAXGEN])
title('优化过程')
xlabel('代数')
ylabel('最优值')
ObjV=PathLength(D,Chrom);  %计算路线长度
preObjV=min(ObjV);
while gen<MAXGEN
    %% 计算适应度
    ObjV=PathLength(D,Chrom);  %计算路线长度
    % fprintf('%d   %1.10f\n',gen,min(ObjV))
    line([gen-1,gen],[preObjV,min(ObjV)]);pause(0.0001)
    preObjV=min(ObjV);
    FitnV=Fitness(ObjV);
    %% 选择
    SelCh=Select(Chrom,FitnV,GGAP);
    %% 交叉操作
    SelCh=Recombin(SelCh,Pc);
    %% 变异
    SelCh=Mutate(SelCh,Pm);
    %% 逆转操作
    SelCh=Reverse(SelCh,D);
    %% 重插入子代的新种群
    Chrom=Reins(Chrom,SelCh,ObjV);
    %% 更新迭代次数
    gen=gen+1 ;
end
%% 画出最优解的路线图
ObjV=PathLength(D,Chrom);  %计算路线长度
[minObjV,minInd]=min(ObjV);
DrawPath(Chrom(minInd(1),:),X)
%% 输出最优解的路线和总距离
disp('最优解:')
p=OutputPath(Chrom(minInd(1),:));
disp(['总距离：',num2str(ObjV(minInd(1)))]);
disp('-------------------------------------------------------------')
