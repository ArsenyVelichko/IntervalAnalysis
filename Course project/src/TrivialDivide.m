function [Z, WorkList] = TrivialDivide(X, RealFunc)
% 
%   Простейший интервальный адаптивный алгоритм глобальной оптимизации.
%   Решает задачу минимизации целевой функции, интервальное расширение 
%   которой задаётся встроенной функцией ObjFunc (см. строки 101 и ниже
%   этой программы). Область определения, которая имеет форму бруса 
%   (прямоугольного параллелепипеда со сторонами, параллельными осям 
%   координат), передаётся через входную переменную X типа 'интервал'. 
%  
%   Подробнее о реализованном методе и его модификациях можно прочитать,
%   к примеру, в книгах 
%
%       Kearfott R.B. Rigorous Global Search: Continuous Problems
%         - Dordrecht: Kluwer, 1996.
%       Hansen E., Walster G.W. Global optimization using interval 
%         analysis. - New York: Marcel Dekker, 2004.
%       Шарый С.П. Конечномерный интервальный анализ. - XYZ: 2011.
%         Электронная книга, доступная на http://www.nsc.ru/interval
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  MaxStepNumber = 200;  %   ограничение на количество итераций алгоритма 
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   "обынтерваливаем", на всякий случай, введённые данные
%  
  X = intval(X);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%   запускаем собственно интервальный алгоритм глобальной оптимизации
%  
  
%   инициализируем счётчик числа шагов 
NStep = 1; 
   
%   находим интервальную оценку области значений целевой функции 
%   на исходном брусе X области определения 
Y = ObjFunc(X);

UpperEst = sup(Y);  %   UpperEst - верхняя граница значений целевой функции
                    %              на заданной области определения X  

%   инициализируем рабочий список записью-структурой, содержащей
%   исходный брус X и оценку целевой функции снизу на нём  
WorkList(1) = struct( 'Box', X, 'Estim', inf(Y) );
  
while ( NStep < MaxStepNumber ) 
    
%   находим в рабочем списке ведущую запись (которая соответствует
%   наименьшей нижней оценке области значений), её номер обозначаем 
%   через Leading, а ведущую (наименьшую) оценку обозначаем LeadEst 
   
    LL = size(WorkList,2);  %   определение длины рабочего списка
    LeadEst = UpperEst;     %   инициализируем LeadEst значением UpperEst
    for k = 1:LL
        p = WorkList(k).Estim;
        if p < LeadEst
            LeadEst = p;
            Leading = k; 
        end
    end
%display(Leading)
    %   для наглядности выводим, если нужно, результаты текущего шага
%     display(NStep) 
%     display(LeadEst) 
%     display(WorkList(Leading).Box) 
    
    %   порождаем потомки ведущего бруса D1 и D2,
    %   делаем их сначала равными ведущему брусу
    D1 = WorkList(Leading).Box;   D2 = D1;    
    
    %   находим самую длинную компоненту ведущего бруса
    [radmax,imax] = max(rad(D1)); 
    
    if radmax == 0
        break
    end

    %   дробим самую длинную компоненту в D1 и D2 пополам 
    s = D1(imax); 
    D1(imax) = infsup(inf(s),mid(s)); 
    D2(imax) = infsup(mid(s),sup(s)); 
    
    %   находим для брусов-потомков интервальные оценки 
    %   областей значений целевой функции 
    Y1 = ObjFunc(D1);   Y2 = ObjFunc(D2);  
    
    %   формируем записи-потомки Rec1 и Rec2 и помещаем их в рабочий список 
    Rec1 = struct( 'Box', D1, 'Estim', inf(Y1) );
    Rec2 = struct( 'Box', D2, 'Estim', inf(Y2) );
    WorkList = [ WorkList  Rec1  Rec2 ];
    
    %   удаляем бывшую ведущую запись из рабочего списка
    WorkList(Leading) = [];  
    %   увеличиваем счётчик шагов 
    NStep = NStep + 1;  
  
end
  
Z = LeadEst;

  function Y = ObjFunc(X)
    Y = RealFunc(X(1), X(2));
  end
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  