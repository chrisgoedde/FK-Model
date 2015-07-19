function saveDynamics(thePath, geometry, runNumber, tau, phi, rho) %#ok<INUSD>
    
    if ~exist(thePath, 'dir')
        
        mkdir(thePath);
        
    end
    
    savefileName = sprintf('%s/%sDynamics-%d.mat', thePath, geometry, runNumber);
    
    save(savefileName, 'tau', 'phi', 'rho')
    
    fprintf('Saved data to %s.\n', savefileName)
    
end