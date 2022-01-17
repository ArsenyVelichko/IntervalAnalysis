function MinCond = MinCond(A)
m = size(A,1);
n = size(A,2);

NN = 30;

Matr1 = ones(m,n); Matr2 = ones(m,n);

MinCond = Inf;
for i = 1:NN
    EPM = randi([0,1],m,n);
end

for i = 1:m
    for j = 1:n
        if EPM(i,j) == 0
            Matr1(i,j) = inf(A(i,j));
            Matr2(i,j) = sup(A(i,j));
        else
            Matr1(i,j) = sup(A(i,j));
            Matr2(i,j) = inf(A(i,j));
        end
    end
end

c1 = cond(Matr1,2);
c2 = cond(Matr2,2);
if MinCond > c1
    MinCond = c1;
end
if MinCond > c2
    MinCond = c2;
end
end