function x = solve_fminunc(A, b, x0)

opts = optimoptions('fminunc', 'Algorithm', 'quasi-Newton', 'Display','iter', 'GradObj', 'on');
x = fminunc(@(x) fun(x, A, b), x0, opts);

end

