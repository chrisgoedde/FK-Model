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
disp([ 'Spring = ' num2str(springFactor, '%.2e') ])
disp([ 'Spacing = ' num2str(spacingFactor, '%.2e') ])
disp([ 'Duration = ' num2str(tf, '%d') ' ns' ])
disp([ 'Integration Method = ' methodName ])
disp([ 'Geometry = ' geometry ])

end
