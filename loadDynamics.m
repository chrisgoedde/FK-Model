function [ tau, phi, rho ] = loadDynamics(thePath, geometry, dataSet) %#ok<STOUT>
    
    if dataSet == 0
        
        loadfileName = sprintf('%s/%sDynamics.mat', thePath, geometry);
        
    else
        
        loadfileName = sprintf('%s/%sDynamics-%d.mat', thePath, geometry, dataSet);
        
    end
    
    fprintf('Loading %s.\n', loadfileName)
    
    load(loadfileName)
    
end