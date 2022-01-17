A = kinterval([3 5;-1 -3], [4 6;1 1]);
b = kinterval([-3;-1],[4;2]);

opts.stepwise = 1;
opts.tau = 1;
fig = figure
[V, P] = EqnTol2D(inf(A), sup(A), inf(b), sup(b));
hold on

[x, opts] = subdiff(A, b, opts);  
opts.status.iteration
bounds = [inf(x(1)), inf(x(2)), 2 * rad(x(1)), 2 * rad(x(2))];
rectangle('Position', bounds, 'LineStyle', '--');
hold on
         
# Second and all the rest iterations
while ~opts.finish
    prev = bounds
    fprintf("-----\niteration: %d\n", opts.status.iteration);
    [x, opts] = subdiff(opts);
    [inf(x(1)), inf(x(2)), sup(x(1)), sup(x(2))]
    bounds = [inf(x(1)), inf(x(2)), 2 * rad(x(1)), 2 * rad(x(2))];
    rectangle('Position', bounds, 'LineStyle', '--');
    
    hold on
    plot(mid(x(1)), mid(x(2)))
    hold on
endwhile
r = rectangle('Position', bounds, 'FaceColor', 'r', 'EdgeColor', 'None'); 
set( get(r, 'children'), 'facealpha', 0.25 )

r = rectangle('Position', prev, 'FaceColor', 'b', 'EdgeColor', 'None'); 
set( get(r, 'children'), 'facealpha', 0.25 )

grid on
saveas(fig, 'Graphics/Newton2_boxes.png');
