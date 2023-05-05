function [A, b] = generate_problem(p1, p2, n)

p = [p1, floor(sqrt(p2))];

while true
  A = randi(p, n);
  if rank(A) == n; break; end
end
A = A' * A;
b = randi(p, n, 1);

end

