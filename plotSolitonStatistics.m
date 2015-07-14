function plotSolitonStatistics(varargin)

[ pathFormats, pathValues, ~ ] = parseArguments(varargin{:});
[ unit ] = setPhysicalConstants(varargin{:});

load(FKDefaults, 'geometry')

readPathName = makePath(pathFormats, pathValues, []);

if ~exist(sprintf('%s/%sConstants.mat', readPathName, geometry), 'file')
    
    fprintf('No appropriate run at %s.\n', readPathName);
    return
    
end

load(sprintf('%s/%sConstants.mat', readPathName, geometry));

runNumber = 1;

while exist(sprintf('%s/%sDynamics-%d.mat', readPathName, geometry, runNumber), 'file')

    [ tau, phi, ~, ~, ~ ] = loadDynamics(readPathName, geometry, runNumber);
    
    [ ~, offset ] = findChainPosition(phi, wavelengthFactor, M, Lambda, alphaVector);

    [ solitonNumber(runNumber, :), solitonPosition(runNumber, :) ] = findSolitons(offset, wavelengthFactor); %#ok<AGROW>
        
    runNumber = runNumber + 1;
    
end

if unit.timeFactor{2} * tau(end) >= 1000
    
    unit.timeFactor{2} = unit.timeFactor{2}/1000;
    unit.timeName = ' ns';
    unit.timeLabel = '(ns)';
    
end

time = unit.timeFactor{unit.flag} * tau;

runNumber = runNumber - 1;

theTitle = makeTitle(unit, runNumber);

finalSN = solitonNumber(:, end);
finalSP = solitonPosition(:, end);

[ sN, sP ] = meshgrid(min(finalSN):max(finalSN), min(finalSP):0.5:max(finalSP));

numRuns = zeros(size(sN));
fractionRuns = zeros(size(sN));

for i = 1:length(finalSN)
    
    sNIndex = finalSN(i) - min(finalSN) + 1;
    sPIndex = 2*(finalSP(i) - min(finalSP)) + 1;
    numRuns(sPIndex, sNIndex) = numRuns(sPIndex, sNIndex) + 1;
    
end

figure
hold on
grid on
box on

set(gca, 'xlim', [ min(finalSN)-1 max(finalSN)+1 ])
set(gca, 'ylim', [ min(finalSP)-1 max(finalSP)+1 ])
set(gca, 'fontsize', 14)
xlabel('# of solitons')
ylabel('chain offset')
title(theTitle)

map = colormap(lines);

for j = 1:size(sN, 2)
    
    for i = 1:size(sP, 1)
        
        if numRuns(i, j) ~= 0
            
            fractionRuns(i,j) = numRuns(i,j)*100/runNumber;
            mSize = 10*sqrt(fractionRuns(i,j));
            
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

figure;
hold on
grid on
box on

set(gca, 'fontsize', 14)
xlabel(sprintf('Time %s', unit.timeLabel{unit.flag}))
ylabel('Probability')
title(theTitle)

[ sN, sP ] = meshgrid(min(min(solitonNumber)):max(max(solitonNumber)), ...
    min(min(solitonPosition)):0.5:max(max(solitonPosition)));

numTimes = size(phi, 2);
solitonStats = zeros([ size(sN) numTimes ]);

for j = 1:numTimes
    
    for i = 1:runNumber
        
        sNIndex = solitonNumber(i, j) - min(min(solitonNumber)) + 1;
        sPIndex = 2*(solitonPosition(i, j) - min(min(solitonPosition))) + 1;
        solitonStats(sPIndex, sNIndex, j) = solitonStats(sPIndex, sNIndex, j) + 1;
%         if solitonNumber(i, j) > 1
%             fprintf('Found 2 anti-kinks at p = 0 in run %d at time %d\n', i, tau(j))
%         end
        
    end
    
end

legendArray = {};
plural = { 's', '' };
solitonType = { 'kink', 'soliton', 'anti-kink' };

for j = 1:size(sN, 2)
    
    for i = 1:size(sP, 1)
        
        if sum(solitonStats(i, j, :)) ~= 0
            
            plot(time, squeeze(solitonStats(i, j, :)/runNumber), 'linewidth', 2);
            
            solitonIndex = (sN(i,j) > 0) - (sN(i,j) < 0) + 2;
            legendArray = [ legendArray, sprintf('%d %s%s, position %.1f', ...
                abs(sN(i, j)), solitonType{solitonIndex}, plural{(abs(sN(i,j)) == 1) + 1}, sP(i, j)) ]; %#ok<AGROW>
            
        end
            
    end
    
end

legend(legendArray, 'location', 'northeast')

pathFormats{2} = 'Pictures';
plotPathName = makePath(pathFormats, pathValues, []);
pngFileName = sprintf('%sSolitonStatistics', geometry);

setPrintSize(8, 6, true)
makePrint(plotPathName, pngFileName, 'png', true)

end
