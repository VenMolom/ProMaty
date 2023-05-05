function [A, b, c] = generate_problem(n)

m = 2*n;
A = randi([-10, 10], m, n);
b = randi([-10, 10], m, 1);
c = rand() * 0.9 + 0.1;

end

