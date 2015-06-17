function saveDynamics(thePath, geometry, runNumber, tau, phi, rho, phiAvg, rhoAvg) %#ok<INUSD>

if ~PathExists(thePath)
    
    mkdir(thePath);
    
end
    
savefileName = sprintf('%s/%sDynamics-%d.mat', thePath, geometry, runNumber);
    
save(savefileName, 'tau', 'phi', 'rho', 'phiAvg', 'rhoAvg')

fprintf('Saved data to %s.\n', savefileName)

end