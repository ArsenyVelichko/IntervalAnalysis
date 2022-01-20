function main

close all;

methodsData = struct('Name', {}, 'Method', {});

methodsData(1).Name = 'TrivialDivide';
methodsData(1).Method = @TrivialDivide;

% methodsData(2).Name = 'SimAnnealing';
% methodsData(2).Method = @SimAnnealing;

testData = struct('Name', '', 'Function', {}, 'InitialBox', {}, "Minimum", {});

% testData(1).Name = 'McCormick';
% testData(1).Function = @McCormick;
% testData(1).InitialBox = infsup([-1.5, -3], [ 4, 4]);
% testData(1).Minimum = [-0.54719, -1.54719];

% testData(1).Name = 'Camel';
% testData(1).Function = @Camel;
% testData(1).InitialBox = infsup([-3, -2], [ 3, 2]);
% testData(1).Minimum = [0.08984, -0.71266; -0.08984,  0.71266];


testData(1).Function = @Easom;
testData(1).Name = 'Easom';
testData(1).InitialBox = infsup([2, 3], [ 4, 5]);
testData(1).Minimum = [pi, pi];
%
% testData(1).Name = 'Himmelblau';
% testData(1).Function = @Himmelblau;
% testData(1).InitialBox = infsup([-5, -5], [ 5, 5]);
% testData(1).Minimum = [3.0, 2.0;
%     -2.805118,  3.131312;
%     -3.779310, -3.283186;
%     3.584428, -1.848126];

for mData = methodsData
    for tData = testData
        [Z, WorkList] = mData.Method(tData.InitialBox, tData.Function);
        Z
        WorkList(end).Box

        ItNum = size(WorkList, 2);
        RadList = zeros(ItNum);
        DistList = zeros(ItNum);
        RwidList = zeros(ItNum - 1);

        InitRad = max(rad(tData.InitialBox));

        fig = figure;
        for k = 1 : ItNum
            Box = WorkList(k).Box;

            BoxRad = max(rad(Box));
            RadList(k) = BoxRad;

            bounds = [inf(Box(1)), inf(Box(2)), 2 * rad(Box(1)), 2 * rad(Box(2))];
            rectangle('Position', bounds);
            hold on

            midPoint = mid(Box);
            Comparator = @(i) Distance(midPoint, tData.Minimum(i, :));
            DistList(k) = min(arrayfun(Comparator, 1 : size(tData.Minimum, 1)));

            MarkerSize = sqrt(BoxRad / InitRad * 2000);
            plot(midPoint(1), midPoint(2), '.', 'MarkerSize', MarkerSize)
            hold on

            if k < ItNum
                RwidList(k) = Rwid(WorkList(k).Estim, WorkList(k+1).Estim);
            end
        end
        hold on

        levels = 50;
        x = linspace(inf(tData.InitialBox(1)), sup(tData.InitialBox(1)));
        y = linspace(inf(tData.InitialBox(2)), sup(tData.InitialBox(2)));
        [X, Y] = meshgrid(x, y);
        Z = tData.Function(X, Y);

        contour(X ,Y, Z, levels);
        xlabel('x')
        ylabel('y')

        saveas(fig, strcat('Graphics/', mData.Name, '_', tData.Name, '_algo.png'))
        step = 4 * int16(log(ItNum))
        fig = figure;

        semilogy(1 : step : ItNum, RadList(1 : step : ItNum));
        xlabel('Итерация')
        ylabel('Радиус бруса')
        saveas(fig, strcat('Graphics/', mData.Name, '_', tData.Name, '_bar_rad.png'))

        fig = figure;
        semilogy(1 : step : ItNum, DistList(1 : step : ItNum));
        xlabel('Итерация')
        ylabel('Расстояние до минимума')
        saveas(fig, strcat('Graphics/', mData.Name, '_', tData.Name, '_dist_to_min.png'))

        fig = figure;
        semilogy(1 : ItNum, RwidList);
        xlabel('Итерация')
        ylabel('Относительная широта')
        saveas(fig, strcat('Graphics/', mData.Name, '_', tData.Name, '_rwid.png'))

    end
end
    function d = Distance(x, y)
        d = sqrt(sum((x - y).^2));
    end

end