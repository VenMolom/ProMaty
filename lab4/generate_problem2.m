function [A, b] = generate_problem2(p1, p2, n)

p = [p1, p2];
while true
  A = randi(p, n);
  if rank(A) == n; break; end
end
Q = orth(A);
b = randi(p, n, 1);
D = diag(l);
A = Q * D * Q';

end

