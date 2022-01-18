close all

addpath('C:\lib\IntOctaveExampleUtils')

x = [2; 5; 7; 11];    
y = [5; 8; 10; 13];        
epsilon = [1.7; 1.3; 2.4; 2.2];  

X = [ x.^0 x ];                               # ������� �������� ���������� ��� beta1 � beta2
lb = [-inf 0];                                # ������ ������� beta1 � beta2
irp_steam = ir_problem(X, y, epsilon, lb);    # �������� ����������, ���������� �������� ������ 
                                              #               ���������� ������������ ���������
fig = figure;
## ����������� ������������� ��������������� ���������
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

## �������� ������
h1 = plot(b_maxdiag(1), b_maxdiag(2), 'ro')
h2 = plot(b_gravity(1), b_gravity(2), 'k+')
h3 = plot(b_lsm(1), b_lsm(2), 'gx')
legend([h1, h2, h3],'����� ����. ���������', '����� �������', '������ ���')

saveas(fig, 'Graphics/InformSet.png');
fig = figure;
xlimits = [-5 15];
ir_plotmodelset(irp_steam, xlimits)     # ������� ���������� ������������
hold on
ir_scatter(irp_steam,'b*')              # ������������ ���������
#ir_plotline(b_maxdiag, xlimits, 'r-')   # ����������� � �����������, ���������� ��� ����� ���������� ��������� ��
#ir_plotline(b_gravity, xlim, 'b--')     # ����������� � �����������, ���������� ��� ����� ������� ��  
#ir_plotline(b_lsm, xlim, 'b--')         # ����������� � �����������, ���������� ���
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