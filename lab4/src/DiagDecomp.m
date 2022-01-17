close all
addpath('C:\lib\kinterval')
addpath('C:\lib\IntLinInc2D')

C = kinterval([2, -2;-2, 2], [4, 1;1, 4]);
d = kinterval([-2;-2],[2;2]);

D = diag(diag(C));
E = innerminus(C, D);


n = 10;
x = kinterval([-2; -2], [2; 2]);
fig = figure;

[V, P] = EqnTol2D(inf(C), sup(C), inf(d), sup(d));
hold on
plot([inf(x(1)), inf(x(1)), sup(x(1)), sup(x(1)), inf(x(1))], ...
     [inf(x(2)), sup(x(2)), sup(x(2)), inf(x(2)), inf(x(2))])
hold on
plot(mid(x(1)), mid(x(2)))
hold on
x_set = [x];
D_inv = diag(inv(diag(C)));
for i=1:n-1
    x = D_inv * innerminus(d, E * x);
    x_set = [x_set x];
    plot([inf(x(1)), inf(x(1)), sup(x(1)), sup(x(1)), inf(x(1))],...
         [inf(x(2)), sup(x(2)), sup(x(2)), inf(x(2)), inf(x(2))])
    hold on
    plot(mid(x(1)), mid(x(2)))
    hold on
end
grid on
saveas(fig, 'Graphics/Decomp_boxes.png');

fig = figure;
rads = rad(x_set);
plot(1:n, rads(1, :))
hold on
plot(1:n, rads(2, :))
hold on
grid on
legend('x_1', 'x_2')
xlabel('Номер итерации')
ylabel('Радиус бруса')
saveas(fig, 'Graphics/Decomp_radius.png');