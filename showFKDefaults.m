function showFKDefaults

load(FKDefaults)

fprintf('\nCurrent defaults:\n\n')

disp([ 'Save Folder = ' folderName ])
disp([ 'Type = ' num2str(theType, '%d') ])
disp([ 'N0 = ' num2str(N0, '%d') ])
disp([ 'Damping = ' num2str(eta, '%.2e') ' Hz' ])
disp([ 'Temperature = ' num2str(bathTemp, '%d') ' K' ])
disp([ 'S = ' num2str(S, '%d') ])
disp([ 'Forcing = ' num2str(f0, '%.2e') ' pN' ])
disp([ 'Push = (' num2str(nPush, '%d') ', ' num2str(fPush, '%.2e') ' pN, ' ...
    num2str(t0Push*1000, '%.1f') ' ps, ' num2str(tfPush*1000, '%.1f') ' ps)' ])
disp([ 'Pull = (' num2str(nPull, '%d') ', ' num2str(fPull, '%.2e') ' pN, ' ...
    num2str(t0Pull*1000, '%.1f') ' ps, ' num2str(tfPull*1000, '%.1f') ' ps)' ])
disp([ 'Spring = (' num2str(springFactor, '%.2e') ...
    ', ' num2str(spacingFactor, '%.2e') ')' ])
if tfTug >= 1
    disp([ 'Tug = (' num2str(dTug, '%.1f') ', ' num2str(strengthTug, '%.1f') ...
        ', ' num2str(tfTug, '%.1f') ' ns)' ])
else
    disp([ 'Tug = (' num2str(dTug, '%.1f') ', ' num2str(strengthTug, '%.1f') ...
        ', ' num2str(tfTug*1000, '%.1f') ' ps)' ])
end
disp([ 'Channel = (' num2str(M, '%d') ', ' num2str(Lambda, '%.2f')  ', ' ...
    num2str(Psi, '%.2f') ')' ])
if tf >= 1
    disp([ 'Duration = ' num2str(tf, '%.1f') ' ns' ])
else
    disp([ 'Duration = ' num2str(tf*1000, '%.1f') ' ps' ])
end
disp([ 'Integration Method = ' methodName ])
disp([ 'Geometry = ' geometry ])

end
