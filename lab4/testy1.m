function testy1(p1, p2, N)

ns = [5, 10, 20, 50, 100];
ns_iter = zeros(length(ns), 2);
ns_norm = zeros(length(ns), 2);
ns_Hnorm = zeros(length(ns), 2);

eps = 1e-6;
max_iter = 10000;

for ni = 1:length(ns)
    n = ns(ni);
%     x0 = zeros(n, 1);

    for i = 1:N
        [A, b] = generate_problem(p1, p2, n);
        xExact = A \ b;
        f = @(x) fun(x, A, b);
        invA = inv(A);
        x0 = b;
        
        [x, ~, iter, h] = BFGS(f, x0, eps, "Anal", max_iter);
        ns_iter(ni, 1) = ns_iter(ni, 1) + iter;
        ns_norm(ni, 1) = ns_norm(ni, 1) + norm(xExact - x);
        ns_Hnorm(ni, 1) = ns_Hnorm(ni, 1) + norm(invA - h);

        [x, ~, iter, h] = BFGS(f, x0, eps, "Gold", max_iter);
        ns_iter(ni, 2) = ns_iter(ni, 2) + iter;
        ns_norm(ni, 2) = ns_norm(ni, 2) + norm(xExact - x);
        ns_Hnorm(ni, 2) = ns_Hnorm(ni, 2) + norm(invA - h);
    end
end

ns_iter = ns_iter / N;
ns_norm = ns_norm / N;
ns_Hnorm = ns_Hnorm / N;

X = categorical(ns);
figure(1)
bar(X, ns_iter);
title("Zależność średniej liczby iteracji od ilości zmiennych");
legend("analityczna", "złoty podział");

figure(2)
hBar = bar(X, ns_norm);
set(gca,'YScale','log')
title("Zależność średniej dokładności rozwiązania od ilości zmiennych");
legend("analityczna", "złoty podział");

figure(3)
hbar = bar(X, ns_Hnorm);
set(gca,'YScale','log')
title("Zależność średniej normy różnicy macierzy od ilości zmiennych");
legend("analityczna", "złoty podział");

display(ns_iter);
display(ns_norm);
display(ns_Hnorm);

end