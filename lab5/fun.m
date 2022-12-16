function [fval, grad] = fun(x, A, b)

fval = (A*x - b)' * (A*x - b);
grad = 2 * (A'*A)*x - 2*A'*b;

end

