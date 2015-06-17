function thePath = makePath(pathFormats, pathValues, num)

thePath = '..';

if isempty(num)
    
    num = length(pathFormats);
    
end

for i = 1:num

    nextFolder = sprintf(pathFormats{i}, pathValues{i});
    thePath = sprintf('%s/%s', thePath, nextFolder);
    
end

end
