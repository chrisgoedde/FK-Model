function [ x, f ] = kde(data)
% function [ x, f ] = kde(data)
% Calculate the kernel density estimate for data set data, returning two
% row vectors with 1001 elements

% Make sure data is a column vector

data = reshape(data, [ length(data), 1 ]);

dataSTD = std(data);
dataMin = min(data);
dataMax = max(data);

% Make the width of each gaussian proportional to the standard deviation of
% data

gW = dataSTD;

x = linspace(dataMin-3*sqrt(dataSTD), dataMax+3*sqrt(dataSTD), 1001);

x = repmat(x, [ length(data), 1 ]);
data = repmat(data, [ 1, length(x) ]);

f = exp(-(x-data).^2/(2*gW))/(sqrt(2*pi*gW));

f = mean(f,1);
x = x(1,:);

whos

end