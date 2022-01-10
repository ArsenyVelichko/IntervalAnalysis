function z = Easom(x, y)
z = -cos(x).*cos(y).*exp(-(x - pi).^2-(y - pi).^2);
end