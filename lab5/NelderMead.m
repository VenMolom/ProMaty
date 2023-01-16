function [x, flag] = NelderMead(f, x0, max_iter, eps)

a = 1;
b = 2;
y = 1/2;
d = 1/2;

lambda = 1;
iter = 0;
n = length(x0);
p = lambda * eye(n, n + 1) + x0;

pv = zeros(n+1, 1);
for i = 1:n+1
    pv(i) = f(p(:, i));
end

[pv, i] = sort(pv);
p = p(:, i);

while iter < max_iter
    pmax = p(:, end);
    pvmax = pv(end);
    pmin = p(:, 1);
    pvmin = pv(1);

    if max(max(abs(p - pmin))) < eps
        x = pmin;
        flag = 1;
        return;
    end

    pcenter = (sum(p, 2) - pmax) / n;
    pr = pcenter + a * (pcenter - pmax);

    % reflection
    pvr = f(pr);
    if pvr < pvmin
        % attempt expansion
        pe = pcenter + b * (pr - pcenter);
        pve = f(pe);
        if pve < pvr
            % expansion accepted
            p(:, end) = pe;
            pv(end) = pve;
        else
            % expansion failed - reflection
            p(:, end) = pr;
            pv(end) = pvr;
        end
    else
        if pvr < pvmax
            % reflection accepted
            p(:, end) = pr;
            pv(end) = pvr;
        else
            % attempt contraction
            pc = pcenter + y * (pmax - pcenter);
            pvc = f(pc);
            if pvc >= pvmax
                % contraction failed - reduction
                p = d * (p + pmin);
                for i = 1:n+1
                    pv(i) = f(p(:, i));
                end
            else
                % contraction accepted
                p(:, end) = pc;
                pv(end) = pvc;
            end
        end
    end

    [pv, i] = sort(pv);
    p = p(:, i);
    iter = iter + 1;
end

flag = 0;
x = pmin;

end

