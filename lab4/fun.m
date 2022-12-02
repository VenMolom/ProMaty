function [f, g, h] = fun(x, A, b)

f = 0.5 * (x' * A * x) - b' * x;
g = A * x - b;
h = A;

end

