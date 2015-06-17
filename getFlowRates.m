function [ flowRate, numSets ] = getFlowRates(newPathName, geometry)

numSets = 1;

while true
    
    fileName = sprintf('%s/%sDynamics-%d.mat', newPathName, geometry, numSets);
    if PathExists(fileName)
        
        fprintf('Loading file %s\n', fileName)
        [ ~, ~, ~, ~, rhoAvg] = loadDynamics(newPathName, geometry, numSets);
        
        rhoAvg = mean(rhoAvg);
        flowRate(numSets) = mean(rhoAvg(end-600:end)); %#ok<AGROW>
        numSets = numSets + 1;
        
    else
        
        break
        
    end
    
end

end