function Z = Tol(x, A, b)
Z = min(rad(b) - mag(mid(b) - A * x));
end