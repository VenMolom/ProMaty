function [x, flag] = NelderMead(f, x0, max_iter, eps)

a = 1;
b = 2;
y = 1/2;
d = 1/2;

lambda = 1;
iter = 0;
n = length(x0);
p = lambda * eye(n, n + 1) + x0;

while iter < max_iter
    pv = zeros(n+1, 1);
    for i = 1:n+1
        pv(i) = f(p(:, i));
    end

    [pvmin, idx] = min(pv);
    pmin = p(:, idx);
    pv(idx) = -Inf;

    [pvmax, idx] = max(pv);
    pmax = p(:, idx);
    
    norms = zeros(n+1, 1);
    for i = 1:n+1
        norms(i) = norm(pmin - p(i), 2);
    end

    if max(norms) < eps
        x = pmin;
        flag = 1;
        return;
    end

    pcenter = 1 / n * (sum(p, 2) - pmax);
    pr = pcenter + a * (pcenter - pmax);

    pvr = f(pr);
    if pvr < pvmin
        pe = pcenter + b * (pr - pcenter);
        if f(pe) < pvr
            pmax = pe;
        else
            pmax = pr;
        end
    else
        if pvmin <= pvr && pvr < pvmax
            pmax = pr;
        else
            pc = pcenter + y * (pmax - pcenter);
            if pc >= pvmax
                % redukcja
                p = d * (p + pmin);
                iter = iter + 1;
                continue;
            else
                pmax = pc;
            end
        end
    end

    p(:, idx) = pmax;
    iter = iter + 1;
end

flag = 0;
x = pmin;

end

