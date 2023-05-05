function [x, iter] = NS(fun, x0, eps, max_iter)

iter = 0;
x = x0;
while iter < max_iter
    iter = iter + 1;
    [~, grad, A] = fun(x);
    d = -grad;

    if norm(d) < eps 
        break; 
    end

    a = -grad' * d / (d' * A * d);

    if a < eps || norm(a * d) < eps
        break; 
    end

    x = x + a * d;
end

end

