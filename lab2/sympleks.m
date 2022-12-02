function [x, fval, flag, iter] = sympleks(f, A, b, opts)
%SYMPLEKS Attempts to solve the  linear programming problem using simplex 
% method. Finds max(f'x) fulfilling requirements Ax = b and x > 0.
% verbose - flag describing if function should display internal state at
% every iteration.

% x - found solution, or empty vector if none.
% fval - value of objective function at x.
% flag - describes exit conditions. Similar to `linprog`.
% iter - amount of iterations before method came to stop.

m = length(b);
n = length(f);
n_prim = m + n;
f_prim = [zeros(n, 1); -ones(m, 1)];
A_prim = [A, eye(m)];

epsilon = opts.epsilon;
verbose = opts.verbose;

if verbose
    disp("Solving for acceptable base solution");
end

[x, flag, iter, A, b, xb] = sympleks_base(f_prim, A_prim, b, [n+1:n+m]', opts);

s = x(n+1:end);
if flag <= 0
    x = [];
    fval = NaN;
    return
end

if  ~isempty(s(abs(s) > epsilon))
    x = [];
    fval = NaN;
    flag = -2;

    if verbose
        disp("No solution exists");
    end
    return
end

first_phase_iter = iter;

% check if there is any fake variable in base, if yes then change it to
% first variable outside of base
while ~isempty(xb(xb > n))
    x(xb) = NaN;
    [~, k] = min(x, [], 'omitnan');
    xbb = xb;
    xbb(xbb <= n) = NaN;
    [~, r] = min(xbb, [], 'omitnan');

    % b reduction
    for i = [1:r-1, r+1:m]
        b(i) = b(i) - (A(i, k) ./ A(r, k)) .* b(r);
    end
    b(r) = b(r) / A(r, k);
    
    % gauss reduction
    AR = zeros(m, n_prim);
    for i = [1:r-1, r+1:m]
        AR(i, :) = A(i, :) - (A(r, :) / A(r, k)) * A(i, k);
    end

    AR(r, :) = A(r, :) / A(r, k);
    xb(r) = k;
    A = AR;

    first_phase_iter = first_phase_iter + 1;
end

if verbose 
    disp("Found base solution")
    x = zeros(n, 1);
    x(xb) = b;
    disp(x)

    disp("Solving for optimal solution");
end
A = A(:, 1:n);
[x, flag, iter] = sympleks_base(f, A, b, xb, opts);
fval = f'*x;
iter = iter + first_phase_iter;

end