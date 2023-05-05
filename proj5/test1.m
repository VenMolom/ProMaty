function test1(N)

dobre = 0;
zle = 0;

linprog_iter = zeros(N, 1);
ipm_iter = zeros(N, 1);
norm_f = zeros(N, 1);
norm_x = zeros(N, 1);
norm_l = zeros(N, 1);
wkt = zeros(N, 1);

c = (1:8)';
b = [zeros(3, 1); ones(2, 1)];
lb = zeros(8, 1);

max_iter = 1000;
eps = 1e-8;
M = 1e8;

opt = optimoptions("linprog", "Display", "off");

n = 1;
while n <= N
    P = randi([0, 10], 3, 4);
    Q = randi([0, 10], 3, 4);

    A = [P, -Q; ones(1, 4), zeros(1, 4); zeros(1, 4), ones(1, 4)];
   
    [x, f, flag_lin, out, l] = linprog(-c, [], [], A, b, lb, [], opt);

    if flag_lin <= 0
        continue;
    end

    [x_ipm, f_ipm, flag_ipm, it_ipm, l_ipm] = IPM(c, A, b, max_iter, eps, M);
    
    if flag_lin >= 0
        l = l.eqlin;
    else 
        l = [];
    end

    linprog_iter(n) = out.iterations;
    ipm_iter(n) = it_ipm;
    norm_f(n) = norm(-f - f_ipm);
    norm_x(n) = norm(x - x_ipm);
    norm_l(n) = norm(l - l_ipm);
    wkt(n) = flag_ipm == 1;

    if (flag_lin >= 0 && flag_ipm >= 0) || (flag_lin < 0 && flag_ipm < 0)
        dobre = dobre + 1;
    else
        zle = zle + 1;
    end

    n = n + 1;
end

disp("Correct solutions:");
disp(dobre);
disp("Incorrect solutions:");
disp(zle);

t = tiledlayout(3, 2);

nexttile;
plot(ipm_iter)
title("Ilość iteracji metody IPM w kolejnych testach");

nexttile;
semilogy(norm_f)
title("Norma różnicy wartości funkcji z linprog i IPM w kolejnych testach");

nexttile;
semilogy(norm_x)
title("Norma różnicy rozwiązania z linprog i IPM w kolejnych testach");

nexttile;
semilogy(norm_l)
title("Norma różnicy mnożników Lagrange'a z linprog i IPM w kolejnych testach");

nexttile;
plot(wkt)
title("Spełnienie WKT w kolejnych testach (1 - spełnione)");

disp("Average iterations for linprog:");
disp(mean(linprog_iter));

disp("Average iterations for IPM:");
disp(mean(ipm_iter));

end