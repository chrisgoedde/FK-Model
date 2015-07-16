function index = findFormat(pathFormats, string)

index = [];

for i = 1:length(pathFormats)
    
    if length(string) < length(pathFormats{i}) ...
            && strncmp(string, pathFormats{i}, length(string))
        
        index = i;
        break
        
    end
    
end

end