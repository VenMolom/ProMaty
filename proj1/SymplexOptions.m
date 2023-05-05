classdef SymplexOptions
    properties
        verbose {mustBeNumericOrLogical}
        epsilon {mustBeNumeric}
        iterations {mustBeNumeric}
    end

    methods        
        function obj = SymplexOptions(verbose, epsilon, iterations)
            if nargin == 2
                obj.verbose = verbose;
                obj.epsilon = epsilon;
                obj.iterations = 1000;
            end
            if nargin == 3
                obj.verbose = verbose;
                obj.epsilon = epsilon;
                obj.iterations = iterations;
            end
        end
    end
end

