function plot_result(P, Q, x, n)
%PLOT_RESULT Plot results of two tetrahedrons intersection.

idx = [1 2 3; 2 3 4; 1 3 4; 1 2 4];

figure(n)
view(3)
axis auto
grid on

if ~isempty(x)
    scatter3(x(1), x(2), x(3), 100, 'black', 'filled');
end

patch('Vertices', P', 'Faces', idx, 'FaceVertexCData', (1:4)', 'FaceColor', 'flat', 'FaceAlpha', .5)
patch('Vertices', Q', 'Faces', idx, 'FaceVertexCData', (5:8)', 'FaceColor', 'flat', 'FaceAlpha', .5)

end

