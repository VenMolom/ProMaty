function solve_both(P, Q)

% etap 1.
[x, flag] = solve_linprog(P, Q);

if flag == 1 
    display(x)
end

plot_result(P, Q, x);

% etap 2.
[x, flag] = solve_sympleks(P, Q, true);

if flag == 1 
    display(x)
end

plot_result(P, Q, x);

end

