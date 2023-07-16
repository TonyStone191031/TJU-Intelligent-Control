%% 输出路径函数
%输入：R 路径
function p = OutputPath(R)
R = arrange(R); % 新添加函数，为了保证路径R总从1开始
R = [R, R(1)];
N = length(R);

p=num2str(R(1));
for i = 2 : N
    p = [p ,'—>', num2str(R(i))];
end
disp(p)

p_prov = num2prov(R(i));
for i = 2 : N
    p_prov = [p_prov, '—>', num2prov(R(i))];
end
disp(p_prov)
