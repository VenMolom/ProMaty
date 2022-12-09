function testy1(p1, p2, N)

ns = [5, 10, 20, 50, 100];
ns_iter = zeros(length(ns), 2);
ns_norm = zeros(length(ns), 2);
ns_Hnorm = zeros(length(ns), 2);

eps = 1e-6;
max_iter = 10000;

for ni = 1:length(ns)
    n = ns(ni);
    x0 = zeros(n, 1);
    iter = zeros(N, 2);
    Xnorm = zeros(N, 2);
    Hnorm = zeros(N, 2);

    for i = 1:N
        [A, b] = generate_problem(p1, p2, n);
        xExact = A \ b;
        f = @(x) fun(x, A, b);
        invA = inv(A);
        
        [x, ~, iterBFGS, h] = BFGS(f, x0, eps, "Anal", max_iter);
        iter(i, 1) = iterBFGS;
        Xnorm(i, 1) = norm(xExact - x);
        Hnorm(i, 1) = norm(invA - h);

        [x, ~, iterBFGS, h] = BFGS(f, x0, eps, "Gold", max_iter);
        iter(i, 2) = iterBFGS;
        Xnorm(i, 2) = norm(xExact - x);
        Hnorm(i, 2) = norm(invA - h);
    end

    ns_iter(ni, :) = median(iter);
    ns_norm(ni, :) = median(Xnorm);
    ns_Hnorm(ni, :) = median(Hnorm);
end

X = categorical(ns);
figure(1)
bar(X, ns_iter);
title("Zależność mediany liczby iteracji od ilości zmiennych");
legend("analityczna", "złoty podział");

figure(2)
hBar = bar(X, ns_norm);
set(gca,'YScale','log')
title("Zależność mediany dokładności rozwiązania od ilości zmiennych");
legend("analityczna", "złoty podział");

figure(3)
hbar = bar(X, ns_Hnorm);
set(gca,'YScale','log')
title("Zależność mediany normy różnicy macierzy od ilości zmiennych");
legend("analityczna", "złoty podział");

display(ns_iter);
display(ns_norm);
display(ns_Hnorm);

end