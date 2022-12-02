function [x, flag, iter, A, b, xb] = sympleks_base(f, A, b, base, opts)
    n = length(f);
    m = length(b);
    c = f;
    xb = base;

    epsilon = opts.epsilon;
    verbose = opts.verbose;
    iterations = opts.iterations;

    % standart simplex iteration
    for iter = 1:iterations
        cb = c(xb);
    
        z = cb' * A;
        zc = z - c';

        if verbose
            print_sympleks_table(iter, xb, A, b, c, z, zc);
        end
    
        [w, k] = min(zc);
    
        % check if any z-c is < 0
        if w >= 0 
            flag = 1;
            x = zeros(n, 1);
            x(xb) = b;

            if verbose
                disp("Optimal solution found");
            end

            return
        end
    
        column = A(:, k);
        rows = column > epsilon;
        
        % check if any value in selected column is <= 0
        if isempty(column(rows)) 
            flag = -3;
            x = zeros(n, 1);
            x(xb) = b;

            if verbose
                disp("Problem is unbound");
            end
            return
        end
    
        column(~rows) = NaN;
        [~, r] = min(b./column, [], 'omitnan');

        % b reduction
        for i = [1:r-1, r+1:m]
            b(i) = b(i) - (A(i, k) ./ A(r, k)) .* b(r);
        end
        b(r) = b(r) / A(r, k);
        
        % gauss reduction
        AR = zeros(m, n);
        for i = [1:r-1, r+1:m]
            AR(i, :) = A(i, :) - (A(r, :) / A(r, k)) * A(i, k);
        end

        AR(r, :) = A(r, :) / A(r, k);
        xb(r) = k;
        A = AR;
    end

    if verbose
        disp("Maximum number of iterations reached");
    end

    x = [];
    flag = 0;
end

function print_sympleks_table(iter, xb, A, b, c, z, zc)
    fprintf('Iteration %d:\n', iter);
    
    [m, n] = size(A);
    columns = [(repmat("x", 1, n) + (1:n)) "b"];
    rows = ["c"; repmat("x", m, 1) + xb; "z"; "z - c"];

    table = array2table([c' NaN; A b; z NaN; zc NaN], 'VariableNames', columns, 'RowNames', rows);

    format short
    disp(table);
end
