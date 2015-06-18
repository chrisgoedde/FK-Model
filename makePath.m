function thePath = makePath(pathFormats, pathValues, theString)

thePath = '..';

num = length(pathFormats);


if ~isempty(theString)
    
    for i = 1:num
        
        nextFormat = pathFormats{i};
        if length(nextFormat) >= length(theString) && ...
                strcmp(theString, nextFormat(1:length(theString)))
            
            num = i;
            break
            
        end
        
    end
    
end

for i = 1:num
    
    nextFolder = sprintf(pathFormats{i}, pathValues{i});
    thePath = sprintf('%s/%s', thePath, nextFolder);
    
end

end
