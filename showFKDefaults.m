function showFKDefaults

beta = [];
gamma = [];
alpha = [];

load(FKDefaults)

fprintf('\nCurrent defaults:\n\n')

disp([ 'Save Folder = ' folderName ])
disp([ 'N0 = ' num2str(N0, '%d') ])
disp([ 'Damping = ' num2str(beta, '%.2e') ])
disp([ 'Temperature = ' num2str(Theta, '%.2f') ])
disp([ 'S = ' num2str(S, '%d') ])
disp([ 'Mass = ' num2str(mu, '%.1f') ])
disp([ 'Forcing = ' num2str(epsilon, '%.3f') ])
fprintf('Push = (%d, %.3f, %.1f %.1f)\n', nPush, epsilonPush, tau0Push, taufPush)
fprintf('Pull = (%d, %.3f, %.1f %.1f)\n', nPull, epsilonPull, tau0Pull, taufPull)
disp([ 'Spring = (' num2str(gamma, '%.2f') ...
    ', ' num2str(alpha/(2*pi), '%.2f') ')' ])
disp([ 'Tug = (' num2str(dTug, '%.1f') ', ' num2str(taufTug, '%.1f') ...
        ', ' num2str(gammaTug, '%.2f') ')' ])
disp([ 'Substrate = (' num2str(M, '%d') ', ' num2str(Lambda, '%.2f')  ', ' ...
    num2str(Psi, '%.2f') ')' ])
disp([ 'Duration = ' num2str(tauf, '%.1f') ])
disp([ 'Integration Method = ' methodName ])
disp([ 'Geometry = ' geometry ])

end
