function [ZPx, ZDy, Val, ZDinfo, iter] = sympleks(c, A, b, g, opts)
%SYMPLEKS Attempts to solve the linear programming problem first solving
% dual problem. Finds max(c'x) fulfilling requirements Ax <= b and x <= g.

% ZPx - found solution for prime problem, or empty vector if none.
% ZDy - found solution for dual problem, or empty vector if none.
% V - value of objective function at x, or NaN if no solution found.
% ZDinfo - describes exit conditions. 1 - Solution found, 0 - No solution
% found.
% iter - amount of iterations made.

m = length(b);
n = length(c);

Ad = [A', eye(n)];
bd = c;
cd = [b; g];
xb = (n + 1 : 2 * n)';

verbose = opts.verbose;

if ~isempty(bd(bd < 0))
    Val = NaN;
    ZDinfo = 0;
    ZPx = [];
    ZDy = [];
    iter = 0;

    if verbose 
        disp("No point satisfies the constraints");
    end

    return;
end

[ZDy, flag, iter, A, ~, yb] = sympleks_base(-cd, Ad, bd, xb, opts);
if flag > 0
    ZPx = (cd(yb)' * A(:, n + 1 : end))';
    Val = cd'*ZDy;
    ZDinfo = 1;

    if verbose 
        display(ZDy);
        display(ZPx);
        display(Val);
    end
else
    Val = NaN;
    ZDinfo = 0;
    ZPx = [];
    ZDy = [];
end

end