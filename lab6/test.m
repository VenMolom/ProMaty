function test(N)

dobre = 0;
zle = 0;

linprog_iter = zeros(N, 1);
ipm_iter = zeros(N, 1);
norm_f = zeros(N, 1);
norm_x = zeros(N, 1);
norm_l = zeros(N, 1);

c = (1:8)';
b = [zeros(3, 1); ones(2, 1)];
lb = zeros(8, 1);

max_iter = 1000;
eps = 1e-8;
M = 1e8;

opt = optimoptions("linprog", "Algorithm", "interior-point", "Display", "off");
for n = 1:N
    P = randi([0, 10], 3, 4);
    Q = randi([0, 10], 3, 4);

    A = [P, -Q; ones(1, 4), zeros(1, 4); zeros(1, 4), ones(1, 4)];
   
    [x, f, flag_lin, out, l] = linprog(-c, [], [], A, b, lb, [], opt);
    [x_ipm, f_ipm, flag_ipm, it_ipm, l_ipm] = IPM(c, A, b, max_iter, eps, M);
    
    if flag_lin >= 0
        l = l.eqlin;
    else 
        l = [];
    end

    linprog_iter(n) = out.iterations;
    ipm_iter(n) = it_ipm;
    norm_f(n) = norm(f - f_ipm);
    norm_x(n) = norm(x - x_ipm);
    norm_l(n) = norm(l - l_ipm);

    if norm_x(n) > 1e-4 || norm_l(n) > 1e-4;
        a = 5;
    end

    if (flag_lin >= 0 && flag_ipm >= 0) || (flag_lin < 0 && flag_ipm < 0)
        dobre = dobre + 1;
    else
        zle = zle + 1;
    end
end

disp("Correct solutions:");
disp(dobre);
disp("Incorrect solutions:");
disp(zle);

figure(1)
plot(ipm_iter)
title("Ilość iteracji metody IPM w kolejnych testach");

figure(2)
semilogy(norm_f)
title("Norma różnicy wartości funkcji z linprog i IPM w kolejnych testach");

figure(3)
semilogy(norm_x)
title("Norma różnicy rozwiązania z linprog i IPM w kolejnych testach");

figure(4)
semilogy(norm_l)
title("Norma różnicy mnożników Lagrange'a z linprog i IPM w kolejnych testach");

disp("Average iterations for linprog:");
disp(mean(linprog_iter));

disp("Average iterations for IPM:");
disp(mean(ipm_iter));

end