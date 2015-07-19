function showFKDefaults
    
    beta = [];
    gamma = [];
    alpha = [];
    
    load(FKDefaults)
    
    fprintf('\nCurrent defaults:\n\n')
    
    disp([ 'Save Folder = ' folderName ])
    disp([ 'Save Type = ' folderType ])
    disp([ 'N0 = ' num2str(N0, '%d') ])
    disp([ 'Damping = ' num2str(beta, '%.2e') ])
    disp([ 'Temperature = ' num2str(Theta, '%.2f') ])
    disp([ 'S = ' num2str(S, '%d') ])
    disp([ 'Mass = ' num2str(mu, '%.1f') ])
    disp([ 'Forcing = ' num2str(epsilon, '%.2e') ])
    fprintf('Push = (%d, %.1f, %.1f %.1f)\n', nPush, epsilonPush, tau0Push, taufPush)
    fprintf('Pull = (%d, %.1f, %.1f %.1f)\n', nPull, epsilonPull, tau0Pull, taufPull)
    disp([ 'Spring = (' num2str(gamma, '%.1f') ...
        ', ' num2str(alpha/(2*pi), '%.3f') ')' ])
    disp([ 'Tug = (' num2str(dTug, '%.2f') ', ' num2str(taufTug, '%.1f') ...
        ', ' num2str(gammaTug, '%.1f') ')' ])
    disp([ 'Substrate = (' num2str(M, '%d') ', ' num2str(Lambda, '%.2f')  ', ' ...
        num2str(Psi, '%.2f') ')' ])
    disp([ 'Duration = ' num2str(tauf, '%.1f') ])
    disp([ 'Integration Method = ' methodName ])
    disp([ 'Geometry = ' geometry ])
    
end
