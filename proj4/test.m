function test(N)

rng('shuffle');

fmincon_iter = zeros(1, N);
zfk_fminsearch_iter = zeros(1, N);
zfk_nelder_iter = zeros(1, N);

zfk_fminsearch_norm = zeros(1, N);
zfk_nelder_norm = zeros(1, N);

zfk_fminsearch_ros = 0;
zfk_nelder_ros = 0;

n = 10;

x0 = zeros(n, 1);
eps = 1e-8;

fmin_opts = optimoptions(@fmincon,'Algorithm','interior-point', ...
    'SpecifyObjectiveGradient',true, ...
    'SpecifyConstraintGradient',true, ...
    'OptimalityTolerance', eps, ...
    'StepTolerance', eps, ...
    'Display', 'none');
lb = zeros(n, 1);
ub = Inf(n, 1);

w = 10;

fminsearch_opts = optimset('fminsearch');
fminsearch_opts = optimset(fminsearch_opts, 'TolX', eps, 'TolFun', eps, 'MaxFunEvals', 10000, 'Display', 'none');

for i = 1:N
    [A, b, c] = generate_problem(n);

    [x_con, ~, ~, opts] = fmincon(@(x) fun(x, A, b), x0, [], [], [], [], ...
    lb, ub, @(x) constraints(x, c), fmin_opts);

    [x_search, flag_search, it_search, lambda_search] = ZFK(A, b, c, w, @(f, x) fminsearch(f, x, fminsearch_opts), x0, eps);
    [x_nelder, flag_nelder, it_nelder, lambda_nelder] = ZFK(A, b, c, w, @(f, x) NelderMead(f, x, 10000, eps), x0, eps);
    
    fmincon_iter(i) = opts.iterations;
    zfk_fminsearch_iter(i) = it_search;
    zfk_nelder_iter(i) = it_nelder;

    zfk_fminsearch_norm(i) = norm(x_search - x_con);
    zfk_nelder_norm(i) = norm(x_nelder - x_con);

    if flag_search == 1
        zfk_fminsearch_ros = zfk_fminsearch_ros + 1;
    end

    if flag_nelder == 1
        zfk_nelder_ros = zfk_nelder_ros + 1;
    end
end

figure
histogram(zfk_fminsearch_iter);
title("Histogram iteracji dla metody ZFK + fminsearch");

figure
histogram(zfk_nelder_iter);
title("Histogram iteracji dla metody ZFK + Nelder-Mead");


figure
histogram(zfk_fminsearch_norm, 20);
title("Histogram błędów dla metody ZFK + fminsearch");

figure
histogram(zfk_nelder_norm, 20);
title("Histogram błędów dla metody ZFK + Nelder-Mead");

disp("Average iterations for fmincon:");
disp(mean(fmincon_iter));
disp("Average iterations for ZFK with fminsearch:");
disp(mean(zfk_fminsearch_iter));
disp("Average iterations for ZFK with Nelder-Mead:");
disp(mean(zfk_nelder_iter));

disp("Average solution error for ZFK with fminsearch:");
disp(mean(zfk_fminsearch_norm));
disp("Average solution error for ZFK with Nelder-Mead:");
disp(mean(zfk_nelder_norm));

disp("Count of optimal solutions found by ZFK with fminsearch:");
disp(zfk_fminsearch_ros);
disp("Count of optimal solutions found by ZFK with Nelder-Mead:");
disp(zfk_nelder_ros);

end