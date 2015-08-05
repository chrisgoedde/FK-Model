function [ values ] = findGeometries(string, rN, pathName)

fileList = dir(pathName);

values = [];
count = 0;

for i = 1:length(fileList)
    
    if fileList(i).name(1) == string
        
        count = count + 1;
        format = sprintf('%s%%dDynamics-%d.mat', string, rN);
        [ values(count), ~, ~ ] = sscanf(fileList(i).name, format); %#ok<AGROW>
        
    end
    
end

end