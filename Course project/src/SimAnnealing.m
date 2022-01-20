function [Z, WorkList] = SimAnnealing(X, RealFunc)
Y = ObjFunc(X);

InitMin = inf(Y);

MinEstVal = InitMin;
WorkList(1) = struct( 'Box', X, 'Estim', inf(Y) );

CurrTemp = 10;
FinalTemp = 10^-32;
TempStep = 0.8;

TempLevelN = 500;

clamp = @(x, lo, hi) min(max(x, lo), hi);

    function Idx = StepFunc(X, Estim)
        sigma = norm(2 * rad(X));
        WorkSize = size(WorkList, 2);
        bias = abs(WorkSize * normrnd(0, sigma) / (3 * sigma));
        Idx = clamp(WorkSize - int16(bias), 1, WorkSize);
    end

    function P = Prob(EstY, EstZ)
        DeltaEst = EstZ - EstY;
        if (DeltaEst <= 0)
            P = 1;
        else
            P = exp(-DeltaEst / CurrTemp);
        end
    end

while CurrTemp > FinalTemp
    rejected = 0;
    for i = 1 : TempLevelN
        NewIdx = StepFunc(WorkList(end).Box, WorkList(end).Estim);

        if rand() <= Prob(WorkList(end).Estim, WorkList(NewIdx).Estim)
            D1 = WorkList(NewIdx).Box;   D2 = D1;

            [radmax,imax] = max(rad(D1));

            if radmax == 0
                break
            end

            s = D1(imax);
            D1(imax) = infsup(inf(s),mid(s));
            D2(imax) = infsup(mid(s),sup(s));

            Y1 = ObjFunc(D1);   Y2 = ObjFunc(D2);

            MinVal1 = inf(Y1);
            MinVal2 = inf(Y2);

            Rec1 = struct( 'Box', D1, 'Estim', MinVal1 );
            Rec2 = struct( 'Box', D2, 'Estim', MinVal2 );

            WorkList(NewIdx) = [];

            if (MinVal1 < MinVal2)  
                MinEstVal = MinVal1;
                WorkList = [WorkList Rec2  Rec1];

            else 
                MinEstVal = MinVal2;
                WorkList = [WorkList Rec1  Rec2];
            end
        else
            rejected = rejected + 1;
        end

    end
    rejected / TempLevelN
    CurrTemp = TempStep * CurrTemp
end

Z = MinEstVal;

    function Y = ObjFunc(X)
        Y = RealFunc(X(1), X(2));
    end

end