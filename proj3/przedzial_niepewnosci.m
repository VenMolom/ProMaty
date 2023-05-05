function [a0, a_max] = przedzial_niepewnosci(F, e)

a1 = 0;
delta = e;
a_test = a1 + delta;
iter = 0;

if F(a1) <= F(a_test)
    a3 = a_test;
else
    a2 = a_test;
    a3 = a2 + delta;
    
    while ~test3P(F, a1, a2, a3)
        iter = iter + 1;
        delta = 2 * delta;
        a3 = a2 + delta;
    end
end

a0 = 0;
a_max = a3;

end

function result = test3P(F, a1, a2, a3)

result = F(a1) > F(a2) && F(a2) < F(a3);

end