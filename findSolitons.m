function [ number, position ] = findSolitons(offset, factor)

% offset = offset(:, end);
offsetDiff = (offset(end, :) - offset(1, :))/(2*pi*factor);
number = floor(abs(offsetDiff)).*sign(offsetDiff);

position = round(offset(1,:)/(2*pi*factor)) + number/2;

% if number == 0
%     
%     position2 = round(mean(offset)/(2*pi*factor));
%     
% elseif mod(number, 2)
%     
%     position2 = 0.5*(ceil(mean(offset)/(2*pi*factor)) ...
%         + floor(mean(offset)/(2*pi*factor)));
%     
% else
%     
%     position2 = round(mean(offset)/(2*pi*factor));
%     
% end

end
