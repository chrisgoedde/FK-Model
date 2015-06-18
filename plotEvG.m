function plotEvG(varargin)

alpha = [];
gamma = [];
beta = [];

[ pathFormats, pathValues, runNumber ] = parseArguments(varargin{:});

geometryList = { 'flat', 's1', 's2', 's3', 's4', 's5', 's6' };

topPathName = makePath(pathFormats, pathValues, 7);

fileList = dir(topPathName);

[ springList, ~ ] = getFoldersAndValues(fileList, 'spring =');

if isempty(springList)
    
    disp('No data files found!')
    return
    
end

PE = zeros(length(geometryList), length(springList));
gammaList = zeros(length(geometryList), length(springList));
chainLength = zeros(length(geometryList), length(springList));

for j = 1:length(springList)
    
    pathValues{8} = springList(j);
    
    newPathName = makePath(pathFormats, pathValues, []);
        
    fprintf('Looking for path %s\n', newPathName)
    
    for i = 1:length(geometryList)
            
        % fprintf('Loading file %s/%sConstants.mat\n', newPathName, geometryList{i})
        load(sprintf('%s/%sConstants.mat', newPathName, geometryList{i}))
        
        [ ~, phi, rho ] = loadDynamics(newPathName, geometryList{i}, runNumber);
        
        [ ~, offset, ~, tempPE, ~, ~, ~, ~, ~ ] = processChain(phi, rho, wavelengthFactor, alpha, delta, gamma, beta, epsilon);

        gammaList(i, j) = gamma(end);
        PE(i, j) = tempPE(end)/N;
        
        chainLength(i, j) = (offset(end, end) - offset(1, end))/(2*pi*wavelengthFactor);
        if (chainLength(i ,j) > i)
            
            PE(i, j) = NaN;
            
        end
        fprintf('Length of %s with %.2f = %.2f\n', geometryList{i}, gammaList(i, j), chainLength(i, j));
            
    end
    
end

figure
hold on, box on, grid on
set(gca, 'fontsize', 12)

styleArray = { '*-', 'o-', 's-', 'd-', '+-', 'v-' };
cM = colormap(lines);

legendArray = cell(1, length(geometryList));

for i = 1:length(geometryList)
    
    plot(gammaList(i, :), PE(i, :), styleArray{mod(i,length(styleArray))+1}, ...
        'linewidth', 2, 'color', cM(mod(i, 7)+1,:))
    
    if i ~= 2
        legendArray{i} = sprintf('%d solitons', i-1);
    else
        legendArray{i} = sprintf('%d soliton', i-1);
    end
    
end

xlabel('Dimensionless spring constant')
ylabel('Dimensionless energy per molecule')

title(sprintf('%d molecules, a/lambda = %.2f', N0, alpha(end)/(2*pi)))

legend(legendArray, 'location', 'best')

setPrintSize(8, 6, true)
makePrint('../Pictures', 'EvG', 'pdf', true)

end