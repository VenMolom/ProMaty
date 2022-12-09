function testy2()

% center values of clusters
cluster_centers = [10, 30, 50, 100, 1000];
K = length(cluster_centers);
% divergence of values from center
div = 0.1; % 10%

% size of problems
ns = [5, 10, 20, 50, 100];

% problems per cluster
N = 100;
iter = zeros(K, length(ns));

eps = 1e-6;
max_iter = 10000;

for i = 1:K
    center = cluster_centers(i);
    p = [floor((1 - div) * center), ceil((1 + div) * center)];
    %p = [floor(center - 5), ceil(center + 5)];
    
    for j = 1:N
        for k = 1:length(ns)
            n = ns(k);

            x0 = zeros(n, 1);
            l = randi(p, n, 1);
            [A, b] = generate_problem2(1, center, l);
            
            [~, ~, iterBFGS, ~] = BFGS(@(x) fun(x, A, b), x0, eps, "Anal", max_iter);
            iter(i, k) = iter(i, k) + iterBFGS;
        end
    end
end

iter = iter / N;

X = categorical(cluster_centers);
figure(1)
bar(X, iter);
title("Zależność średniej liczby iteracji od klastra");
legend("n = 5", "n = 10", "n = 20", "n = 50", "n = 100");

display(iter);

% Norma gradientu w kolejnych iteracjach

n = 10;
x0 = zeros(n, 1);
norms = zeros(8, K);
for i = 1:K
    center = cluster_centers(i);
    p = [floor((1 - div) * center), ceil((1 + div) * center)];
    
    l = randi(p, n, 1);
    [A, b] = generate_problem2(1, center, l);

    [~, ~, ~, ~, grad_norms] = BFGS(@(x) fun(x, A, b), x0, eps, "Anal", max_iter);
    norms(1:length(grad_norms), i) = grad_norms';
end

figure(2)
hbar = bar(1:8, norms);
set(gca,'YScale','log')
title("Wartość normy gradientu w kolejnych iteracjach");
legend("k = 10", "k = 30", "k = 50", "k = 100", "k = 1000");

end