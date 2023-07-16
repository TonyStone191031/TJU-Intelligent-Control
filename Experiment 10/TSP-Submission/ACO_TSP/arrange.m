function [R] = arrange(R)
% arrange函数不改变行向量R中的元素，但是对R中元素的顺序进行重新排列
% 排列会保留R中元素的内部顺序，但是使得R从1开始，使最后显示出的路径总以1为起点
%   例如：输入R = [5 2 3 1 4]，输出R = [1 4 5 2 3]，R中元素的内部顺序不变

N = size(R,2);
new_R = zeros(1,N);

for i = 1 : N
    if R(i) == 1
        pos_1 = i;  % pos_1是输入的R中1的位置
        break
    end
end

k = 1;
for i = pos_1 : N
    new_R(k) = R(i);
    k = k + 1;
end

if pos_1 ~= 1
    for i = 1 : pos_1 - 1
        new_R(k) = R(i);
        k = k + 1;
    end
end

R = new_R;

end

