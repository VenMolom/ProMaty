function test(N)

dobre = 0;
zle = 0;

linprog_iter = zeros(1, N);
sympleks_iter = zeros(1, N);

solution_type_count = zeros(1, 3);

f = zeros(8, 1);
lb = zeros(8, 1);
beq = [zeros(3, 1); ones(2, 1)];
opt = optimoptions("linprog", "Algorithm", "dual-simplex", "Display", "off");
for n = 1:N
    P = randi([0, 10], 3, 4);
    Q = randi([0, 10], 3, 4);

    Aeq = [P, -Q; ones(1, 4), zeros(1, 4); zeros(1, 4), ones(1, 4)];
   
    [~, ~, flag_lin, out] = linprog(f, [], [], Aeq, beq, lb, [], opt);
    [~, ~, flag_sym, iter_sym] = sympleks(f, Aeq, beq, SymplexOptions(false, 1e-10));
    
    if (flag_lin > 0 && flag_sym > 0) || (flag_lin == flag_sym)
        dobre = dobre + 1;
        linprog_iter(n) = out.iterations;
        sympleks_iter(n) = iter_sym;

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