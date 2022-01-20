function rw = Rwid(x, y)
rw = (min(sup(x), sup(y)) - max(inf(x), inf(y))) /...
     (max(sup(x), sup(y)) - min(inf(x), inf(y)));
end
