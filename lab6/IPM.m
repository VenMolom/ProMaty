function [x_ipm, f_ipm, exitflag, it, l_ipm] = IPM(c, A, b, max_it, eps, M)

n = length(c);
m = length(b);

x = ones(n, 1);
y = ones(m, 1);
z = ones(n, 1);

delta = 0.1;
beta = 0.999;
k = 0.2;
iter = 0;

while iter < max_it
   
    % check STOP conditions
    ro = b - A * x;
    sigma = c - A' * y + z;
    gamma = z' * x;
    
    if max(x) > M
        % primary problem unbounded
        exitflag = -1;
        x_ipm = [];
        f_ipm = 0;
        it = iter;
        l_ipm = [];
        return;
    end

    if max(y) > M
        % dual problem unbounded
        exitflag = -2;
        x_ipm = [];
        f_ipm = 0;
        it = iter;
        l_ipm = [];
        return;
    end

    if sum(ro) < eps && sum(sigma) < eps && gamma < eps
        % dual problem unbounded
        exitflag = WKT(c, A, b, x, y, z, eps, 2);
        x_ipm = x;
        f_ipm = c' * x;
        it = iter;
        l_ipm = y;
        return;
    end

    % update rk
    r = delta * (z' * x) / n;
    delta = k * delta;

    % calculate dk
    X1 = diag(1./x);
    Z = diag(z);
    K = [zeros(m, m) A; A', X1*Z];
    l = [ro - r * 1./y; sigma + r * 1./x - z];

    sol = linsolve(K, l);
    dy = sol(1:m);
    dx = sol(m+1:end);
    dz = X1 * (r * ones(n, 1) - diag(x) * Z * ones(n, 1) - Z * dx);

    %calculate alpha
    xdx = x ./ dx;
    zdz = z ./ dz;
    ap = min([1, -beta * xdx(dx < 0)']);
    ad = min([1, -beta * zdz(dz < 0)']);
    
    % update tk
    x = x + ap * dx;
    y = y + ad * dy;
    z = z + ad * dz;

    iter = iter + 1;

end

exitflag = WKT(c, A, b, x, y, z, eps, 0);
x_ipm = x;
f_ipm = c' * x;
it = iter;
l_ipm = y;

end

function exitflag = WKT(c, A, b, x, y, z, eps, startflag)

% check constraints
w = norm(A * x - b);
% check grad
q = norm(c - A' * y + z);

if q < eps && w < eps && sum(x < -eps) == 0 && sum(z < -eps) == 0
    exitflag = 1;
    return
end

exitflag = startflag;

end