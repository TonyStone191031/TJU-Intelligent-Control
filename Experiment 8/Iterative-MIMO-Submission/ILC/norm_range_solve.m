B = [1 1;0 1];
C = [1 0;0 1];
I = eye(2);
gamma_min = 0;  % since norm(eye(2)) == 1
gamma = gamma_min;
gamma1 = gamma + 0.0001;   % initialize
k = 0;

while 1
    if norm(I - C*B*gamma1*eye(2)) >= 1 || k > 1000000000
        break
    end
    gamma = gamma1;
    gamma1 = gamma + 0.0001;
    k = k + 1;
end
if k == 1000000001
    gamma_max = NaN;
else
    gamma_max = gamma;
end

gamma_min, gamma_max

if isnan(gamma_max)
    return
end

norm_gamma = zeros(1, round((gamma_max - gamma_min)*10000));

for gamma = (gamma_min+0.0001) : 0.0001 : (gamma_max+0.0001)
    i = round(gamma * 10000);
    norm_gamma(i) = norm(I - C*B*gamma*eye(2));
end

plot(norm_gamma);
x_tick = gamma_min : 0.1 : (gamma_max+0.0001);
set(gca, 'xticklabel', x_tick);
xlabel('\gamma'); ylabel('norm(I-C*B*\Gamma)');