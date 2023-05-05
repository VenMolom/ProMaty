function [C,Ceq, gradC, gradCeq] = constraints(x, c)

C = x' * x - c;
gradC = 2 * x;
Ceq = 0;
gradCeq = zeros(length(x), 1);

end
