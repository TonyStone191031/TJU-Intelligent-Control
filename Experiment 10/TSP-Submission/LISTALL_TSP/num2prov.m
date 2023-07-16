function [prov] = num2prov(num)
% 将城市序号（num）转化为相应的城市名称（prov）输出

switch num
    case{1}
        prov = '山东';
    case{2}
        prov = '河北';
    case{3}
        prov = '吉林';
    case{4}
        prov = '黑龙江';
    case{5}
        prov = '辽宁';
    case{6}
        prov = '内蒙古';
    case{7}
        prov = '新疆';
    case{8}
        prov = '甘肃';
    case{9}
        prov = '宁夏';
    case{10}
        prov = '山西';
    case{11}
        prov = '陕西';
    case{12}
        prov = '河南';
    case{13}
        prov = '安徽';
    case{14}
        prov = '江苏';
    case{15}
        prov = '浙江';
    case{16}
        prov = '福建';
    case{17}
        prov = '广东';
    case{18}
        prov = '江西';
    case{19}
        prov = '海南';
    case{20}
        prov = '广西';
    case{21}
        prov = '贵州';
    case{22}
        prov = '湖南';
    case{23}
        prov = '湖北';
    case{24}
        prov = '四川';
    case{25}
        prov = '云南';
    case{26}
        prov = '西藏';
    case{27}
        prov = '青海';
    case{28}
        prov = '天津';
    case{29}
        prov = '上海';
    case{30}
        prov = '重庆';
    case{31}
        prov = '北京';
    case{32}
        prov = '台湾';
    case{33}
        prov = '香港';
    case{34}
        prov = '澳门';
end

end

