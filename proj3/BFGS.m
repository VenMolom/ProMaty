function [xBFGS, fval, it, last_h, grad_norms] = BFGS(fun, x0, eps, step_alg, max_iter)

I = eye(length(x0));
H = I;
x = x0;
iter = 0;
[~, grad, A] = fun(x);
grad_norms = [];

while iter < max_iter
    iter = iter + 1;
    
    if norm(grad) < eps 
        break;
    end

    grad_norms = [grad_norms, norm(grad)];
    d = -H * grad;

    if step_alg == "Anal"
        a = -grad' * d / (d' * A * d);
    elseif step_alg == "Gold" 
        F = @(ak) fun(x + ak * d);
        [a0, a_max] = przedzial_niepewnosci(F, 0.05);
        a = gold(F, a0, a_max, 1e-6, max_iter);
    else
        assert(false, "Wrong step algorithm");
    end

    if a < eps || norm(a * d) < eps
        break; 
    end
    
    s = a * d;
    x = x + s;
    
    prevGrad = grad;
    [~, grad] = fun(x);

    r = grad - prevGrad;
    H = (I - (s * r') / (s' * r)) * H * (I - (r * s') / (s' * r)) + (s * s') / (s' * r);
end

xBFGS = x;
fval = fun(x);
it = iter;
last_h = H;

end

