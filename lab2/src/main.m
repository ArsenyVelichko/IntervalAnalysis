close all

a = 3;
b = 2;

c = infsup(30, 31);
k = infsup(0.8, 1);

A = [a, b; 1, -k];
b = [c; 0];

fig = figure;
EqnWeak2D(inf(A), sup(A), inf(b), sup(b))
hold on
grid on

xlabel('x_1')
ylabel('x_2')
saveas(fig, 'Graphics/Linear_area.png')

lamdba = inv(mid(A));
C = eye(2) - lamdba * A
mag(C)
max(eig(mag(C)))
eta = norm(mag(C), 'inf')
theta = norm(mag(lamdba*b), 'inf') / (1 - eta)

n = 10;
x = [midrad(theta, theta / 2); midrad(theta, theta / 2)]

WorkList = x;
for i = 1:n-1
    x = intersect(lamdba * b + C * x, x);
    WorkList = [WorkList x];
end

plotintval(WorkList, 'n')
hold on
grid on
xlabel('x_1')
ylabel('x_2')
saveas(fig, 'Graphics/Linear_boxes.png')

EndPoint = mid(WorkList(:, end));

Distance = @(x, y) sqrt(sum((x - y).^2));

n = size(WorkList, 2);
RadList = zeros(2, n);
DistList = zeros(n);
for k = 1:n
    Box = WorkList(:, k);

    RadList(:, k) = rad(Box);
    DistList(k) = Distance(mid(Box), EndPoint);
end

fig = figure;
semilogy(1 : n, RadList(1, :));
hold on
semilogy(1 : n, RadList(2, :));
xlabel('Итерация')
ylabel('Радиус бруса')
legend('x_1', 'x_2')
saveas(fig, 'Graphics/Linear_bar_rad.png')

fig = figure;
semilogy(1 : n, DistList);
xlabel('Итерация')
ylabel('Расстояние до конечной точки')
saveas(fig, 'Graphics/Linear_dist_to_end.png')

%%
a = 3;
b = 2;

c = infsup(30, 31);
k = infsup(0.8, 1);

J = @(X) [a, b; 1 / X(2), -X(1) / (X(2)^2)];
x = [infsup(5, 8); infsup(5, 8)];
lambda = @(X) inv(J(mid(x)));
C = @(X) eye(2) - lambda(X) * J(X);

mag(C(x))
max(eig(mag(C(x))))
F = @(X) [a * X(1) + b * X(2) - c;X(1)/ X(2) - k];
K = @(X) mid(X) - lambda(X) * F(mid(X)) - C(X) * (X - mid(X));

n = 150;
fig = figure;
WorkList = x;
for i = 1:n-1
    x = intersect(K(x), x);
    WorkList = [WorkList x];
end

A = [a, b; 1, -k];
b = [c; 0];
EqnWeak2D(inf(A), sup(A), inf(b), sup(b))

hold on
plotintval(WorkList, 'n');

n = size(WorkList, 2);
RadList = zeros(2, n);
DistList = zeros(n);
for k = 1:n
    Box = WorkList(:, k);

    RadList(:, k) = rad(Box);
    DistList(k) = Distance(mid(Box), EndPoint);
end

xlabel('x_1')
ylabel('x_2')
hold on
grid on
saveas(fig, 'Graphics/NonLinear_boxes.png')

fig = figure;
semilogy(1 : n, RadList(1, :));
hold on
semilogy(1 : n, RadList(2, :));
xlabel('Итерация')
ylabel('Радиус бруса')
legend('x_1', 'x_2')
saveas(fig, 'Graphics/NonLinear_bar_rad.png')

fig = figure;
semilogy(1 : n, DistList);
xlabel('Итерация')
ylabel('Расстояние до конечной точки')
saveas(fig, 'Graphics/NonLinear_dist_to_end.png')