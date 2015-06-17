function [ value, folder ] = getFoldersAndValues(fileList, format)

value = [];
tempFolder = {};
count = 0;

% We need the length of the format string to know where to start parsing
% the folder names.

fL = length(format);

for i = 1:length(fileList)
        
    if length(fileList(i).name) > fL+1
        
        theName = fileList(i).name;
        
        if strcmp(theName(1:fL), format)
            
            count = count + 1;
            
            index = fL+2;
            while ~isspace(theName(index))
                
                index = index + 1;
                if index > length(theName)
                    
                    break
                    
                end
                
            end
            value(count) = str2double(theName(fL+2:(index-1))); %#ok<AGROW>
            tempFolder{count} = fileList(i).name; %#ok<AGROW>
        end
        
    end
    
end

folder = cell(1, length(value));
[ value, index ] = sort(value, 'ascend');

for i = 1:length(value);
    
    folder{i} = tempFolder{index(i)};
    
end

end
