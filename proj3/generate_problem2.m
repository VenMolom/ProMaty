function [A, b] = generate_problem2(p1, p2, l)

p = [p1, p2];
n = length(l);
while true
  Q = randi(p, n);
  if rank(Q) == n; break; end
end
Q = orth(Q);
D = diag(l);
A = Q * D * Q';

b = randi(p, n, 1);

end