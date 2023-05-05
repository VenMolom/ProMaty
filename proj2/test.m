function test(N, only_solvable)

dobre = 0;
zle = 0;

linprog_iter = zeros(1, N);
sympleks_iter = zeros(1, N);

solution_type_count = zeros(1, 3);

m = 5;
n = 5;

opt = optimoptions("linprog", "Algorithm", "dual-simplex", "Display", "off");
lb = repmat(-Inf, n, 1);

i = 1;
while i <= N
    [A, b, c, g] = generate_problem(m, n);

    [~, fval_lin, flag_lin, out] = linprog(-c, A, b, [], [], lb, g, opt);

    if only_solvable && flag_lin <= 0
        continue;
    end

    [~, ~, fval_sym, flag_sym, iter_sym] = sympleks(c, A, b, g, SymplexOptions(false, 1e-10));
    
    if (flag_lin > 0 && flag_sym > 0 && abs(fval_sym + fval_lin) < 10e-10) || (flag_lin <= 0 && flag_sym == 0)
        dobre = dobre + 1;
        linprog_iter(i) = out.iterations;
        sympleks_iter(i) = iter_sym;

        if flag_lin > 0
            solution_type_count(1) = solution_type_count(1) + 1;
        elseif flag_lin == -2
            solution_type_count(2) = solution_type_count(2) + 1;
        elseif flag_lin == -3
            solution_type_count(3) = solution_type_count(3) + 1;
        end
    else
        zle = zle + 1;
    end
    i = i + 1;
end

disp("Correct solutions:");
disp(dobre);
disp("Incorrect solutions:");
disp(zle);

figure
histogram(linprog_iter);
title("Histogram iteracji dla metody linprog");

figure
histogram(sympleks_iter);
title("Histogram iteracji dla metody sympleks");

disp("Average iterations for linprog:");
disp(mean(linprog_iter));

disp("Average iterations for sympleks:");
disp(mean(sympleks_iter));

figure
bar(solution_type_count);
xt = get(gca, 'XTick');
set(gca, 'XTick', xt, 'XTickLabel', {'Posiadające RO', 'Sprzeczne', 'Nieograniczone'})
title("Rozkład typów zadań");

end