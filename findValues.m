function [ values, folderIndex ] = findValues(string, pathFormats, pathValues)

folderIndex = findFormat(pathFormats, string);

if isempty(folderIndex) || folderIndex == 1
    
    fprintf('Couldn''t find <%s> in pathFormats.\n', string)
    return
    
end

parentIndex = folderIndex - 1;

topPathName = makePath(pathFormats, pathValues, pathFormats{parentIndex});

fileList = dir(topPathName);

values = {};
folder = {};
count = 0;

for i = 1:length(fileList)
    
    if fileList(i).name(1) ~= '.'
        
        count = count + 1;
        [ values{count}, ~, ~ ] = sscanf(fileList(i).name, ...
            stripPeriods(pathFormats{folderIndex})); %#ok<AGROW>
        values{count} = (values{count})'; %#ok<AGROW>
        folder{count} = fileList(i).name; %#ok<AGROW>
        
    end
    
end

    function s = stripPeriods(string)
        
        C = strsplit(string, '.');
        for k = 2:length(C)
            temp = C{k};
            C{k} = temp(2:end);
        end
        s = strjoin(C, '');
        
    end

end