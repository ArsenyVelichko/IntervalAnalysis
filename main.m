function main

close all;
testData = struct( 'Function', {}, 'InitialBox', {}, "Minimum", {});

testData(1).Function = @McCormick;
testData(1).InitialBox = infsup([-1.2, -2.6], [ 3, 3]);
testData(1).Minimum = [-0.54719, -1.54719];

% testData(2).Function = @Easom;
% testData(2).InitialBox = infsup([2, 3], [ 4, 5]);
% testData(2).Minimum = [pi, pi];

testData(2).Function = @Himmelblau;
testData(2).InitialBox = infsup([-5, -5], [ 5, 5]);
testData(2).Minimum = [3.0, 2.0;
    -2.805118,  3.131312;
    -3.779310, -3.283186;
    3.584428, -1.848126];

for data = testData
    [Z, WorkList] = globopt0(data.InitialBox, data.Function);

    ItNum = size(WorkList, 2);
    RadList = zeros(ItNum);
    DistList = zeros(ItNum);

    InitRad = max(rad(data.InitialBox));

    figure
    for k = 1 : ItNum
        Box = WorkList(k).Box;

        BoxRad = max(rad(Box));
        RadList(k) = BoxRad;

        bounds = [inf(Box(1)), inf(Box(2)), 2 * rad(Box(1)), 2 * rad(Box(2))];
        rectangle('Position', bounds);
        hold on

        midPoint = mid(Box);
        Comparator = @(i) Distance(midPoint, data.Minimum(i, :));
        DistList(k) = min(arrayfun(Comparator, 1 : size(data.Minimum, 1)));

        MarkerSize = sqrt(BoxRad / InitRad * 2000);
        plot(midPoint(1), midPoint(2), '.', 'MarkerSize', MarkerSize)
        hold on
    end
    hold on

    levels = 50;
    x = linspace(inf(data.InitialBox(1)), sup(data.InitialBox(1)));
    y = linspace(inf(data.InitialBox(2)), sup(data.InitialBox(2)));
    [X, Y] = meshgrid(x, y);
    Z = data.Function(X, Y);
    contour(X ,Y, Z, levels)

    figure
    semilogy(1 : ItNum, RadList);

    figure
    semilogy(1 : ItNum, DistList);

end

    function d = Distance(x, y)
        d = sqrt(sum((x - y).^2));
    end

end