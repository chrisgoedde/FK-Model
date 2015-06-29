function plotSolitonStatistics(varargin)

alpha = [];
gamma = [];
beta = [];

[ pathFormats, pathValues, ~ ] = parseArguments(varargin{:});

load(FKDefaults, 'geometry')

readPathName = makePath(pathFormats, pathValues, []);

if ~exist(sprintf('%s/%sConstants.mat', readPathName, geometry), 'file')
    
    fprintf('No appropriate run at %s.\n', readPathName);
    return
    
end

load(sprintf('%s/%sConstants.mat', readPathName, geometry));

runNumber = 1;

while exist(sprintf('%s/%sDynamics-%d.mat', readPathName, geometry, runNumber), 'file')

    [ ~, phi, ~, ~, ~ ] = loadDynamics(readPathName, geometry, runNumber);
    
    [ ~, offset ] = findChainPosition(phi, wavelengthFactor, alpha);

    [ tNumber, pNumber ] = findSolitons(offset, wavelengthFactor);
    
    solitonNumber(runNumber) = tNumber(end); %#ok<AGROW>
    solitonPosition(runNumber) = pNumber(end); %#ok<AGROW>
    
    runNumber = runNumber + 1;
    
end

runNumber = runNumber - 1;

theTitle = makeTitle(alpha, beta, gamma, kB*bathTemp/V0, epsilon0Pull, epsilon0Push, runNumber);

[ sN, sP ] = meshgrid(min(solitonNumber):max(solitonNumber), ...
    min(solitonPosition):0.5:max(solitonPosition));

numRuns = zeros(size(sN));

for i = 1:length(solitonNumber)
    
    sNIndex = solitonNumber(i) - min(solitonNumber) + 1;
    sPIndex = 2*(solitonPosition(i) - min(solitonPosition)) + 1;
    numRuns(sPIndex, sNIndex) = numRuns(sPIndex, sNIndex) + 1;
    
end

figure
hold on
grid on
box on

set(gca, 'xlim', [ min(solitonNumber)-1 max(solitonNumber)+1 ])
set(gca, 'ylim', [ min(solitonPosition)-1 max(solitonPosition)+1 ])
set(gca, 'fontsize', 14)
xlabel('# of solitons')
ylabel('chain offset')
title(theTitle)

map = colormap(lines);

for j = 1:size(sN, 2)
    
    for i = 1:size(sP, 1)
        
        if numRuns(i, j) ~= 0
            
            mSize = 10*sqrt(numRuns(i,j)*100/runNumber);
            
            plot(sN(i,j), sP(i,j), 's', 'markeredgecolor', map(1, :), ...
                'markerfacecolor', map(1, :), ...
                'markersize', mSize);
            
            set(gca, 'units', 'points')
            pos = get(gca, 'outerposition');
            xLim = get(gca, 'xlim');
            set(gca, 'units', 'normalized')
            
            text(sN(i,j)+((mSize/2)+5)*(xLim(2) - xLim(1))/pos(3), sP(i,j), ...
                sprintf('%.0f%%', numRuns(i,j)*100/runNumber), 'fontsize', 14)
            
        end
        
    end
    
end

end
