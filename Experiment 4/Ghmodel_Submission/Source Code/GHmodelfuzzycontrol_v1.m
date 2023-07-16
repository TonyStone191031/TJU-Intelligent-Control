% In GHmodefuzzycontrol_v1, the fuzzy model "Ghfuzzy_v1.fis" is built with
% the use of GUI "Fuzzy Logic Designer".

% --------------------------前期准备--------------------------------
clear
% all files here
datafile1 = '2020-05-27-23-save.mat'; datafile2 = '2020-05-29-23-save.mat';
datafile3 = '2020-05-30-23-save.mat'; datafile4 = '2020-06-01-23-save.mat';
datafile5 = '2020-06-02-23-save.mat'; datafile6 = '2020-06-03-23-save.mat';
datafile7 = '2020-06-04-23-save.mat'; datafile8 = '2020-06-06-23-save.mat';
datafile9 = '2020-06-07-23-save.mat';

% load data of the greenhouse environment of one file
load(datafile9)
b = [0.0118; -0.5740];
T_in = Tin;
Vx_wind = V_wind*3;
Ia = I_out/54*0.51; % 太阳辐射通量密度 （wm2） 太阳光源， 1umol/m2/s=54lux=0.51w/m2
Iax_c = Ia;
Iax_f = Ia;
T_interval = 15*60; % 15min
As = 500;           % 温室覆盖材料表面积，also覆盖层总面积 m2  
Av = 100;           % 通风面积；
Ag = 100;           % 温室占地面积                    [m^2]
Hg = 8;             % 温室平均高度                  [ m ]
Vair = 1000;        % 温室体积
cair = 1.005;       % 空气比热容；[kJ/(kg·K)]
pair = 1.293;       % 空气密度；  密度/(kg/m^3)|t=20℃:    1.293
LAI = 2;            % 作物叶面积指数；
Lamda = 2450;       % KJkg-1,   水的汽化潜热；
Toua = 0.5;         % 覆盖材料透光系数  0.5；
kg = 0.05;          % 覆盖材料的热传递系数  w/m2/K;

% 部分传统控制参数初始化为全零，且长度和T_out一致。
Qcool_c = zeros(size(T_out,1),1);         % 制冷输入。取值[0, +∞)，取值越大，制冷效果越好。
Qheat_c = zeros(size(T_out,1),1);         % 制热输入。取值[0, +∞)，取值越大，制热效果越好。
RoofVent_c = zeros(size(T_out,1),1);      % 天窗输入。取值[0,1]，0表示完全关闭。取值越大，与外界的热量交换越大。
SideVent_c = zeros(size(T_out,1),1);      % 侧窗输入。取值[0,1]，0表示完全关闭。取值越大，与外界的热量交换越大。
ShadeCurtain_c = zeros(size(T_out,1),1);  % 遮阳网输入。取值0或1，0表示关闭。打开时，太阳光照被削弱。

Q_coef_c = zeros(size(T_out,1),1);

% 传统控制后台计算涉及的中间计算量
Qsolar_c = zeros(1,size(T_out,1));
Qcon_c = zeros(1,size(T_out,1));
Qplant_c = zeros(1,size(T_out,1));
Qvent_Roof_c = zeros(1,size(T_out,1));
Qvent_Side_c = zeros(1,size(T_out,1));
Qsoil_c = zeros(1,size(T_out,1));
Qheatx_c = zeros(1,size(T_out,1));
Qcoolx_c = zeros(1,size(T_out,1));
dQ_c = zeros(1,size(T_out,1));
dT_cal_c = zeros(1,size(T_out,1));
T_in_cal_c = zeros(1,size(T_out,1));
T_in_pred_c = zeros(1,size(T_out,1));

T_in_cal_c(1)=T_in(1);

% 部分模糊控制参数初始化为全零，且长度和T_out一致。
Qcool_f = zeros(size(T_out,1),1);         % 制冷输入。取值[0, +∞)，取值越大，制冷效果越好。
Qheat_f = zeros(size(T_out,1),1);         % 制热输入。取值[0, +∞)，取值越大，制热效果越好。
RoofVent_f = zeros(size(T_out,1),1);      % 天窗输入。取值[0,1]，0表示完全关闭。取值越大，与外界的热量交换越大。
SideVent_f = zeros(size(T_out,1),1);      % 侧窗输入。取值[0,1]，0表示完全关闭。取值越大，与外界的热量交换越大。
ShadeCurtain_f = zeros(size(T_out,1),1);  % 遮阳网输入。取值0或1，0表示关闭。打开时，太阳光照被削弱。

Q_coef_f = zeros(size(T_out,1),1);

% 模糊控制后台计算涉及的中间计算量
Qsolar_f = zeros(1,size(T_out,1));
Qcon_f = zeros(1,size(T_out,1));
Qplant_f = zeros(1,size(T_out,1));
Qvent_Roof_f = zeros(1,size(T_out,1));
Qvent_Side_f = zeros(1,size(T_out,1));
Qsoil_f = zeros(1,size(T_out,1));
Qheatx_f = zeros(1,size(T_out,1));
Qcoolx_f = zeros(1,size(T_out,1));
dQ_f = zeros(1,size(T_out,1));
dT_cal_f = zeros(1,size(T_out,1));
T_in_cal_f = zeros(1,size(T_out,1));
T_in_pred_f = zeros(1,size(T_out,1));

T_in_cal_f(1)=T_in(1);

% 目标设定
Temp_Ideal_UP = 28;  % 目标温度上限，开启制冷
Temp_Ideal_DOWN = 15;  %目标温度下限，开启加热

% --------------------------前期准备--------------------------------
% --------------------------传统控制--------------------------------

% Conventional Control
for i = 2 : size(T_out,1)
    ShadeCurtain_c(i) = 1;
    T_in_pred_c(i) = T_in_cal_c(i-1);
    %     控制策略写这里
    if T_in_pred_c(i) < Temp_Ideal_DOWN
        Qheat_c(i) = 20 * (Temp_Ideal_DOWN - T_in_pred_c(i));
        SideVent_c(i) = 0;
        RoofVent_c(i) = 0;
        Qcool_c(i) = 0;
    else
        SideVent_c(i) = 1;
        RoofVent_c(i) = 1;
    end    
    if T_in_pred_c(i) > Temp_Ideal_UP
        Qcool_c(i) = 80 * (T_in_pred_c(i) - Temp_Ideal_UP);
        SideVent_c(i) = 0;
        RoofVent_c(i) = 0;
        Qheat_c(i) = 0;
        if Ia(i) > 200
            ShadeCurtain_c(i) = 1;
        end
    end
    % 后台计算下一个时刻的温度变化状态
    if ShadeCurtain_c(i) == 1
        Iax_c(i) = 1/5 * Ia(i);
    end
    Qsolar_c(i) = As * Iax_c(i) * Toua * T_interval;   %太阳辐射吸收的能量；
    Qcon_c(i) = As * kg * (T_in_pred_c(i) - T_out(i)) * T_interval;    % 室内外空气通过覆盖材料热传导引起的交换能量；
    Qplant_c(i) = Ag * pair * cair * LAI * (0.08 * T_in_pred_c(i)) * T_interval;   %作物与室内换热的能量；
    Qvent_Roof_c(i) = Av * Vx_wind(i) * RoofVent_c(i) * (T_in_pred_c(i) - T_out(i)) * T_interval; %天窗通风交换的热量
    Qvent_Side_c(i) = Av * Vx_wind(i) * SideVent_c(i) * (T_in_pred_c(i) - T_out(i)) * T_interval;  %侧窗通风交换的热量
    Qsoil_c(i) = Ag * 0.05 * T_in_pred_c(i) * T_interval;   %土壤与室内空气换热的能量；
    Qheatx_c(i) = min(100,Qheat_c(i)) * 1000 * T_interval;  % 加热系统热量
    Qcoolx_c(i) = min(100,Qcool_c(i)) * 1000 * T_interval;
    dQ_c(i) = [Qsolar_c(i)-Qcon_c(i)-Qplant_c(i)-Qsoil_c(i)+Qheatx_c(i)-Qcoolx_c(i), Qvent_Roof_c(i)+Qvent_Side_c(i)] * [0.0118; -0.5740];
    dT_cal_c(i) = dQ_c(i)/(pair*Vair*cair)/T_interval;
    % T_in_cal(i) = max(T_out(i)+2, T_in_cal(i-1)+dT_cal(i));
    T_in_cal_c(i) = T_in_cal_c(i-1) + dT_cal_c(i);    % 取消了先前的max(...+2, ...)
end

% --------------------------传统控制--------------------------------
% --------------------------模糊控制--------------------------------

% Fuzzy Control
Ghfuzzy_v1 = readfis('Ghfuzzy_v1.fis');   % 导入模糊控制策略
Output_v1 = zeros(size(T_out,1),1);     % 模糊控制器的输出，有1个输出变量
dT_out = zeros(1,size(T_out,1));      % 室外温度（T_out）的变化量
for i = 2 : size(T_out,1)
    T_in_pred_f(i) = T_in_cal_f(i-1);   % 预测温度初始化为 上一时刻的计算温度
    dT_out(i) = T_out(i) - T_out(i-1);
    
    % 数据预处理，防止类似05-29出现的异常温度大波动现象（推测很可能是硬件故障）
    % 首先检查T_in是否异常，即室内温度传感器是否发生硬件故障
    if abs(T_in(i) - T_in(i-1)) > 10    % 室内温度有大波动的异常
        if (T_in(i-1) < 10 || T_in(i-1) > 50) && (T_in(i) >= 10 && T_in(i) <=50)   % T_in(i-1)异常，T_in(i)正常
            T_in_pred_f(i) = T_in(i);      % 忽略异常，重新赋值计算
        end
    end
    % 再检查dT_out是否异常，即T_out是否波动异常，即室外温度传感器是否发生硬件故障
    if abs(dT_out(i)) >= 10   % 室外温度数据发生异常波动
       if T_out(i) < 10 || T_out(i) > 35  % T_out(i)不处于通常的正常范围，说明T_out(i-1)正常，T_out(i)异常
           dT_out(i) = dT_out(i-1); % 这次异常，因此dT_out取上一次的值
       else     % T_out(i-1)异常
           dT_out(i) = T_out(i) - T_out(i-2); % 上一次异常，因此dT_out取这次减去再前面一次
       end
    end
    
    % 如下是控制策略，计算出控制变量(Qheat & Qcool; SideVent & RoofVent; ShadeCurtain)
    [Output_v1(i)] = evalfis(Ghfuzzy_v1, [T_in_pred_f(i), dT_out(i)]);
    Q_coef_f(i) = Output_v1(i);
    
    % Qheat & Qcool 的控制策略
    if Q_coef_f(i) > 0        % 说明室内温度过低或偏低，需要升高室内温度
        Qheat_f(i) = Q_coef_f(i) * abs(Temp_Ideal_DOWN-T_in_pred_f(i));
        Qcool_f(i) = 0;
    elseif Q_coef_f(i) < 0    % 说明室内温度过高或偏高，需要降低室内温度
        Qheat_f(i) = 0;
        Qcool_f(i) = abs(Q_coef_f(i) * (Temp_Ideal_UP-T_in_pred_f(i)));
        % 当室温超过最大允许值时，增大Qcool，加强降温力度
        if T_in_pred_f(i) > Temp_Ideal_UP % 室温超过最大允许值
            Qcool_f(i) = abs(Q_coef_f(i)) * (T_in_pred_f(i) - (Temp_Ideal_UP-3));   % 增为室温与25摄氏度的差值
        end
    else    % Qcoef(i) == 0，既不需要升温也不需要降温，Qheat(i) == Qcool(i) == 0
        SideVent_f(i) = 1;    % 打开窗户，增加交换热量
        RoofVent_f(i) = 1;
    end
    
    % SideVent & RoofVent 的控制策略
    % 当室内温度高于室外温度，且室内温度高于25度时，打开窗子来增加室内外热量交换，加强散热
    if T_in_pred_f(i) > T_out(i) && T_in_pred_f(i) > 25
        SideVent_f(i) = 1;
        RoofVent_f(i) = 1;
    end
    % 当室内温度低于室外温度，且室内温度低于18度时，打开窗子来增加室内外热量交换，加强产热
    if T_in_pred_f(i) < T_out(i) && T_in_pred_f(i) < 18
        SideVent_f(i) = 1;
        RoofVent_f(i) = 1;
    end
    
    % ShadeCurtain 的控制策略
    if T_in_pred_f(i) > Temp_Ideal_UP - 3     % 即25摄氏度
        if Ia(i) > 200  % 超过25度，且光照较强，就拉起帘子
            ShadeCurtain_f(i) = 1;
        end
        if T_in_pred_f(i) > Temp_Ideal_UP     % 即28摄氏度
            ShadeCurtain_f(i) = 1;    % 超过最大允许值，必须拉起帘子
        end
    end
    % 如上是控制策略，计算出控制变量(Qheat & Qcool; SideVent & RoofVent; ShadeCurtain)
    
    % 如下是后台需要根据控制策略计算下一个时刻的温度变化状态
    if ShadeCurtain_f(i) == 1
        Iax_f(i) = 1/3 * Ia(i);  %如果遮阳网打开，则光照为原来的1/3.
    end
    Qsolar_f(i) = As * Iax_f(i) * Toua * T_interval;   %太阳辐射吸收的能量；
    Qcon_f(i) = As * kg * (T_in_pred_f(i) - T_out(i)) * T_interval;    % 室内外空气通过覆盖材料热传导引起的交换能量；
    Qplant_f(i) = Ag * pair * cair * LAI * (0.08 * T_in_pred_f(i)) * T_interval;   %作物与室内换热的能量；
    Qvent_Roof_f(i) = Av * Vx_wind(i) * RoofVent_f(i) * (T_in_pred_f(i) - T_out(i)) * T_interval; %天窗通风交换的热量
    Qvent_Side_f(i) = Av * Vx_wind(i) * SideVent_f(i) * (T_in_pred_f(i) - T_out(i)) * T_interval;  %侧窗通风交换的热量
    Qsoil_f(i) = Ag * 0.05 * T_in_pred_f(i) * T_interval;   % 土壤与室内空气换热的能量；
    Qheatx_f(i) = min(100,Qheat_f(i)) * 1000 * T_interval;  % 将Qheatx限制在0 到100之间   % 加热系统热量   w
    Qcoolx_f(i) = min(100,Qcool_f(i)) * 1000 * T_interval;    % 同上
    dQ_f(i) = [Qsolar_f(i)-Qcon_f(i)-Qplant_f(i)-Qsoil_f(i)+Qheatx_f(i)-Qcoolx_f(i), Qvent_Roof_f(i)+Qvent_Side_f(i)]*[0.0118; -0.5740];  % 计算出温室的能量输入
    dT_cal_f(i) = dQ_f(i)/(pair*Vair*cair)/T_interval; % 温度变化，根据能量输出公式
    % T_in_cal(i) = T_in_cal(i-1) + dT_cal(i)，其中 T_in_cal(i-1) == T_in_pred(i)
    % 将T_in_cal(i-1)替换成T_in_pred(i)是因为T_in(i-1)出现数据异常时，T_in_pred(i)可以被重新赋值为正常的量
    % 但是T_in_cal(i-1)是最后画图需要用到的量，即使是异常时也要照常保留，所以不便重新赋值
    % 但是如果仍然用异常的T_in_cal(i-1)计算T_in_cal(i)就会影响之后的控制，所以用T_in_pred(i)进行代替
    T_in_cal_f(i) = T_in_pred_f(i) + dT_cal_f(i);
end

figure; 
plot(t,T_out,'b','LineWidth',2);
title('\bf室内外温度');
hold on
plot(t,T_in_cal_c,'c','LineWidth',2)
plot(t,T_in_cal_f,'r','LineWidth',2)
grid on
legend('室外温度','传统控制的室内温度','模糊控制的室内温度');

% --------------------------模糊控制--------------------------------
