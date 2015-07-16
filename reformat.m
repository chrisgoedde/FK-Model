function reformat(oldFormat, newFormat, varargin)

[ pathFormats, pathValues, ~ ] = parseArguments(varargin{:});

load(FKDefaults, 'geometry')

head = strtok(oldFormat, '=');
[ values, index ] = findValues(head, pathFormats, pathValues);

for i = 1:length(values)
    
    pathValues{index} = values{i};
    pathFormats{index} = oldFormat;
    oldPathName = makePath(pathFormats, pathValues, head);
    pathFormats{index} = newFormat;
    newPathName = makePath(pathFormats, pathValues, head);

    fprintf('Moving <%s>\nto <%s>\n', oldPathName, newPathName)
    movefile(oldPathName, newPathName)
    
end

end