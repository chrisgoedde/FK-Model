function plotEvA(varargin)

alpha = [];
gamma = [];
beta = [];

[ pathFormats, pathValues, runNumber ] = parseArguments(varargin{:});

geometryList = { 's0', 's1', 's2', 's3', 's4', 's5', 's6' };

topPathName = makePath(pathFormats, pathValues, 'spring =');

fileList = dir(topPathName);

[ spacingList, ~ ] = getFoldersAndValues(fileList, 'spacing =');

if isempty(spacingList)
    
    disp('No data files found!')
    return
    
end

PE = zeros(length(geometryList), length(spacingList));
ratioList = zeros(length(geometryList), length(spacingList));
chainLength = zeros(length(geometryList), length(spacingList));

for j = 1:length(spacingList)
    
    pathValues{9} = spacingList(j);
    
    newPathName = makePath(pathFormats, pathValues, []);
        
    fprintf('Looking for path %s\n', newPathName)
    
    for i = 1:length(geometryList)
            
        % fprintf('Loading file %s/%sConstants.mat\n', newPathName, geometryList{i})
        load(sprintf('%s/%sConstants.mat', newPathName, geometryList{i}))
        
        [ ~, phi, rho ] = loadDynamics(newPathName, geometryList{i}, runNumber);
        
        [ ~, offset, ~, tempPE, ~, ~, ~, ~, ~ ] = processChain(phi, rho, wavelengthFactor, alpha, delta, gamma, beta, epsilon);

        ratioList(i, j) = alpha(end)/(2*pi);
        PE(i, j) = tempPE(end)/N;
        
        chainLength(i, j) = (offset(end, end) - offset(1, end))/(2*pi*wavelengthFactor);
        if (chainLength(i ,j) > i) || chainLength(i, j) < i-1
            
            PE(i, j) = NaN;
            
        end
        fprintf('Length of %s with %.2f = %.2f\n', geometryList{i}, ratioList(i, j), chainLength(i, j));
            
    end
    
end

figure
hold on, box on, grid on
set(gca, 'fontsize', 12)

styleArray = { '*-', 'o-', 's-', 'd-', '+-', 'v-' };
cM = colormap(lines);

legendArray = cell(1, length(geometryList));

for i = 1:length(geometryList)
    
    plot(ratioList(i, :), PE(i, :), styleArray{mod(i,length(styleArray))+1}, ...
        'linewidth', 2, 'color', cM(mod(i, 7)+1,:))
    
    if i ~= 2
        legendArray{i} = sprintf('%d solitons', i-1);
    else
        legendArray{i} = sprintf('%d soliton', i-1);
    end
    
end

xlabel('(spring length)/\lambda')
ylabel('Dimensionless energy per molecule')
set(gca, 'xlim', [ 1 1.1 ])

title(sprintf('%d molecules, gamma = %.2f', N0, gamma(end)))

legend(legendArray, 'location', 'best')

setPrintSize(8, 6, true)
makePrint('../Pictures', 'EvA', 'pdf', true)

end