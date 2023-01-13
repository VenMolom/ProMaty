function [x_ipm, f_ipm, exitflag, it, l_ipm] = IPM(x0, max_it, eps)



end

function [lambda, flag] = WKT(x, A, b, c, flag, eps)

% TODO: adjust and set lambda to hard 0 for unfulfilled constraints
[~, gradF] = fun(x, A, b);
[C, ~, gradC] = constraints(x, c);
G = [gradC, -eye(length(x))];

lambda = linsolve(G, -gradF);

complete = lambda(1) * C + lambda(2:end)' * -x;
if sum(lambda(lambda < -eps)) > 0 || ...
    C > 100 * eps || sum(x(-x > eps)) > 0 || ...
    abs(complete) > 100 * eps
    if flag == 1
        flag = 2;
    end
    return;
end

end