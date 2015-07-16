function [ xg, yg, zg ] = makeGrid(x, y, z)

xu = sort(unique(x));
yu = sort(unique(y));

[ xg, yg ] = meshgrid(xu, yu);
zg = NaN(size(xg));

for i = 1:length(x)
    
    match = (xg == x(i)) + (yg == y(i));
    [ match, row ] = max(match);
    [ ~, col ] = max(match);
    zg(row(col), col) = z(i);
    
end

end