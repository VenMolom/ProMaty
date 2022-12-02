function [alfa_gold, it_gold] = gold(F, a0, a_max, eps, iter_max)

c = (sqrt(5) - 1) / 2;

iter = 0;
a = a0;
b = a_max;

x1 = b - c * (b - a);
x2 = a + c * (b - a);

fx1 = F(x1);
fx2 = F(x2);

while iter < iter_max
    iter = iter + 1;

    if abs(b - a) < eps
        break;
    end

    if fx1 < fx2
        b = x2;
        x2 = x1;
        x1 = b - c * (b - a);
        fx2 = fx1;
        fx1 = F(x1);
    else
        a = x1;
        x1 = x2;
        x2 = a + c * (b - a);
        fx1 = fx2;
        fx2 = F(x2);
    end
end

alfa_gold = (a + b) / 2;
it_gold = iter;

end

