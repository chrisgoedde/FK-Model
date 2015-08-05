function [ number, position ] = findSolitons(offset, factor)
    
    offsetDiff = (offset(end, :) - offset(1, :))/(2*pi*factor);
    number = round(abs(offsetDiff)).*sign(offsetDiff);
    
    a = round(mean(offset)/(2*pi*factor));
    b = (round(offset(1,:)/(2*pi*factor)) + number/2);
    
    position =  a .* (number == 0) +  b .* (number ~= 0);
    
end
