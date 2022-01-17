close all

addpath('C:\lib\IntOctaveExampleUtils')

x = [2; 5; 7; 11];    
y = [5; 8; 10; 13];        
epsilon = [1.7; 1.3; 2.4; 2.2];  

X = [ x.^0 x ];                               # матрица значений переменных при beta1 и beta2
lb = [-inf 0];                                # нижние границы beta1 и beta2
irp_steam = ir_problem(X, y, epsilon, lb);    # создание переменной, содержащей описание задачи 
                                              #               построения интервальной регрессии
fig = figure;
## Графическое представление информационного множества
ir_plotbeta(irp_steam)
grid on
set(gca, 'fontsize', 12)
xlabel('\beta_1')
ylabel('\beta_2')

b_int = ir_outer(irp_steam)


vertices = ir_beta2poly(irp_steam)
[rhoB, b1, b2] = ir_betadiam(irp_steam)
b_int = ir_outer(irp_steam)
b_maxdiag = (b1 + b2) / 2   
b_gravity = mean(vertices)   
b_lsm = (X \ y)'             

## Точечные оценки
h1 = plot(b_maxdiag(1), b_maxdiag(2), 'ro')
h2 = plot(b_gravity(1), b_gravity(2), 'k+')
h3 = plot(b_lsm(1), b_lsm(2), 'gx')
legend([h1, h2, h3],'центр наиб. диагонали', 'центр тяжести', 'оценка МНК')

saveas(fig, 'Graphics/InformSet.png');
fig = figure;
xlimits = [-5 15];
ir_plotmodelset(irp_steam, xlimits)     # коридор совместных зависимостей
hold on
ir_scatter(irp_steam,'b*')              # интервальные измерения
#ir_plotline(b_maxdiag, xlimits, 'r-')   # зависимость с параметрами, оцененными как центр наибольшей диагонали ИМ
#ir_plotline(b_gravity, xlim, 'b--')     # зависимость с параметрами, оцененными как центр тяжести ИМ  
#ir_plotline(b_lsm, xlim, 'b--')         # зависимость с параметрами, оцененными МНК
#ir_scatter(ir_problem(Xp,ypmid,yprad),'ro')
xlabel('x')
ylabel('y')

grid on
set(gca, 'fontsize', 12)
saveas(fig, 'Graphics/Corridor.png');
fig = figure;
x_p = [-3; 1; 4; 9; 14];
ir_plotmodelset(irp_steam, xlimits)
hold on
ir_scatter(irp_steam,'b*')
hold on 
X_p = [x_p.^0 x_p];
y_p = ir_predict(irp_steam, X_p);
ypmid = mean(y_p,2);
yprad = 0.5 * (y_p(:,2) - y_p(:,1));
ir_scatter(ir_problem(X_p,ypmid,yprad),'k*');
grid on
xlabel('x')
ylabel('y')
saveas(fig, 'Graphics/Predictions.png');