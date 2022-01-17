A = [infsup(1, 2), infsup(1, 2); 1, -infsup(2, 4); infsup(0, 2), 0];
B = [infsup(2, 4); 0; infsup(0, 2)];

x = linspace(0, 3);

line1 = @(x) (mid(B(1)) - mid(A(1, 1)) * x) / mid(A(1, 2));
line2 = @(x) (mid(B(2)) - mid(A(2, 1)) * x) / mid(A(2, 2));

plot(x, line1(x))
hold on
plot(x, line2(x))
hold on
xline( mid(B(3)) / mid(A(3, 1)))
%%
[maxVal, maxPoint] = tolsolvty(inf(A), sup(A), inf(B), sup(B));
levels = 25;
x = linspace(0.8, 1.6);
y = linspace(0, 1);
[X, Y] = meshgrid(x, y);

Z = zeros(size(X, 1), size(X, 2));
for i = 1:size(Z, 1)
    for j = 1:size(Z,2)
        Z(i, j) = Tol([X(i, j); Y(i, j)], A, B);
    end
end

fig = figure
contour(X,Y, Z, levels);
colorbar
hold on
plot(maxPoint(1), maxPoint(2), '*')
hold on
saveas(fig, 'Graphics/maxTol.png')
%%
[maxVal, maxPoint] = tolsolvty(inf(A), sup(A), inf(B), sup(B));

EyeInt = infsup(-1, 1);
bias = [EyeInt; EyeInt; EyeInt];
FixedB = B + (abs(maxVal) * 1.2) * bias;

[maxVal, maxPoint] = tolsolvty(inf(A), sup(A), inf(FixedB), sup(FixedB));

minCond = MinCond(A);

ive = @ (A, b) minCond*norm(maxPoint)*maxVal/norm(mag(b));
rve = @ (A, b) minCond*maxVal;

fig = figure;

levels = 20;
x = linspace(0.8, 1.6);
y = linspace(0, 1);
[X, Y] = meshgrid(x, y);

Z = zeros(size(X, 1), size(X, 2));
for i = 1:size(Z, 1)
    for j = 1:size(Z,2)
        Z(i, j) = Tol([X(i, j); Y(i, j)], A, FixedB);
    end
end


EqnTol2D(inf(A), sup(A), inf(FixedB), sup(FixedB));
hold on

iveVal = ive(A, FixedB)
rveVal = rve(A, FixedB)
iveInt = [midrad(maxPoint(1), iveVal);midrad(maxPoint(2), iveVal)];
rveInt = [midrad(maxPoint(1), rveVal);midrad(maxPoint(2), rveVal)];
plotintval([iveInt, rveInt], 'n')
hold on

contour(X,Y, Z, levels);
hold on
plot(maxPoint(1), maxPoint(2), '*')
hold on
colorbar

saveas(fig, 'Graphics/biasCorr.png')
%%
[maxVal1, maxPoint1] = tolsolvty(inf(A), sup(A), inf(B), sup(B));
K = abs(maxVal) * 1.2;
E = [0.3, 0.3;0 1; 0.6 0];
%min(rad(A) * maxPoint)
E * maxPoint1
FixedA = infsup(inf(A) + E, sup(A) - E);

[maxVal2, maxPoint2] = tolsolvty(inf(FixedA), sup(FixedA), inf(B), sup(B));

fig = figure

levels = 20;
x = linspace(1, 1.8);
y = linspace(0.1, 0.9);
[X, Y] = meshgrid(x, y);

Z = zeros(size(X, 1), size(X, 2));
for i = 1:size(Z, 1)
    for j = 1:size(Z,2)
        Z(i, j) = Tol([X(i, j); Y(i, j)], FixedA, B);
    end
end

EqnTol2D(inf(FixedA), sup(FixedA), inf(B), sup(B));
hold on


contour(X,Y, Z, levels);
hold on
plot(maxPoint2(1), maxPoint2(2), '*')
hold on
colorbar
saveas(fig, 'Graphics/matrixCorr.png')

%%
[maxVal1, maxPoint1] = tolsolvty(inf(A), sup(A), inf(B), sup(B));

fig = figure;
plot(maxPoint1(1), maxPoint1(2), '*')
hold on

line1 = @(x) (mid(B(1)) - mid(A(1, 1)) * x) / mid(A(1, 2));
line2 = @(x) (mid(B(2)) - mid(A(2, 1)) * x) / mid(A(2, 2));

x = linspace(0.8, 1.6);

plot(x, line1(x))
hold on
plot(x, line2(x))
hold on
xline( mid(B(3)) / mid(A(3, 1)))
hold on

eList = [0 : 0.05 : 0.5];

plotList = [];

for e = eList

E = [e, e;0 2 * e; 2 *e 0];
%min(rad(A) * maxPoint)
E * maxPoint1
FixedA = infsup(inf(A) + E, sup(A) - E);

[maxVal2, maxPoint2] = tolsolvty(inf(FixedA), sup(FixedA), inf(B), sup(B));
maxPoint2
h = plot(maxPoint2(1), maxPoint2(2), 'o');
plotList = [plotList h];
hold on

end

grid on

legend(plotList, arrayfun(@(x) num2str(x), eList, 'UniformOutput',false))
saveas(fig, 'Graphics/fullCorr.png')
%%
[maxVal1, maxPoint1] = tolsolvty(inf(A), sup(A), inf(B), sup(B));

fig = figure;
plot(maxPoint1(1), maxPoint1(2), '*')
hold on

line1 = @(x) (mid(B(1)) - mid(A(1, 1)) * x) / mid(A(1, 2));
line2 = @(x) (mid(B(2)) - mid(A(2, 1)) * x) / mid(A(2, 2));

x = linspace(0.8, 1.6);

plot(x, line1(x))
hold on
plot(x, line2(x))
hold on
xline( mid(B(3)) / mid(A(3, 1)))
hold on

eList = [0 : 0.07 : 0.35];

plotList = [];

for e = eList

E = [e, e;0 1; 0.35 0];
%min(rad(A) * maxPoint)
E * maxPoint1
FixedA = infsup(inf(A) + E, sup(A) - E);

[maxVal2, maxPoint2] = tolsolvty(inf(FixedA), sup(FixedA), inf(B), sup(B));
maxPoint2
h = plot(maxPoint2(1), maxPoint2(2), 'o');
plotList = [plotList h];
hold on

end

grid on

legend(plotList, arrayfun(@(x) num2str(x), eList, 'UniformOutput',false))
saveas(fig, 'Graphics/row1Corr.png')
%%
[maxVal1, maxPoint1] = tolsolvty(inf(A), sup(A), inf(B), sup(B));

fig = figure;
plot(maxPoint1(1), maxPoint1(2), '*')
hold on

line1 = @(x) (mid(B(1)) - mid(A(1, 1)) * x) / mid(A(1, 2));
line2 = @(x) (mid(B(2)) - mid(A(2, 1)) * x) / mid(A(2, 2));

x = linspace(0.8, 1.6);

plot(x, line1(x))
hold on
plot(x, line2(x))
hold on
xline( mid(B(3)) / mid(A(3, 1)), 'Color', [0.4940 0.1840 0.5560])
hold on

eList = [0 : 0.2 : 1];

plotList = [];

for e = eList

E = [0.25, 0.25;0 e; 0.35 0];
%min(rad(A) * maxPoint)
E * maxPoint1
FixedA = infsup(inf(A) + E, sup(A) - E);

[maxVal2, maxPoint2] = tolsolvty(inf(FixedA), sup(FixedA), inf(B), sup(B));
maxPoint2
h = plot(maxPoint2(1), maxPoint2(2), 'o');
plotList = [plotList h];
hold on

end

grid on

legend(plotList, arrayfun(@(x) num2str(x), eList, 'UniformOutput',false))
saveas(fig, 'Graphics/row2Corr.png')

%%
[maxVal1, maxPoint1] = tolsolvty(inf(A), sup(A), inf(B), sup(B));

fig = figure;
plot(maxPoint1(1), maxPoint1(2), '*')
hold on

line1 = @(x) (mid(B(1)) - mid(A(1, 1)) * x) / mid(A(1, 2));
line2 = @(x) (mid(B(2)) - mid(A(2, 1)) * x) / mid(A(2, 2));

x = linspace(0.8, 1.6);

plot(x, line1(x))
hold on
plot(x, line2(x))
hold on
xline( mid(B(3)) / mid(A(3, 1)), 'Color', [0.4940 0.1840 0.5560])
hold on

eList = [0 : 0.1 : 0.6];

plotList = [];

for e = eList

E = [0.25, 0.25;0 1; e 0];
%min(rad(A) * maxPoint)
E * maxPoint1
FixedA = infsup(inf(A) + E, sup(A) - E);

[maxVal2, maxPoint2] = tolsolvty(inf(FixedA), sup(FixedA), inf(B), sup(B));
maxPoint2
h = plot(maxPoint2(1), maxPoint2(2), 'o');
plotList = [plotList h];
hold on

end

grid on

legend(plotList, arrayfun(@(x) num2str(x), eList, 'UniformOutput',false))
saveas(fig, 'Graphics/row3Corr.png')