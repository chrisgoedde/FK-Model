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

    [ tau, phi, rho ] = loadDynamics(readPathName, geometry, runNumber);
    
    initForce(epsilon, epsilonPush, tau0Push, taufPush, ...
        epsilonPull, tau0Pull, taufPull);
    [ ~, offset, ~, ~, ~, ~, ~, ~, ~, ~ ] = processChain(tau, phi, rho, wavelengthFactor, alpha, delta, gamma, beta);

    offset = offset(:, end);
    offsetDiff = (offset(end) - offset(1))/(2*pi*wavelengthFactor);
    solitonNumber(runNumber) = floor(abs(offsetDiff))*sign(offsetDiff); %#ok<AGROW>
    
    if solitonNumber(runNumber) == 0
        
        solitonPosition(runNumber) = round(mean(offset)/(2*pi*wavelengthFactor)); %#ok<AGROW>
        
    else
        
        solitonPosition(runNumber) = 0.5*(ceil(mean(offset)/(2*pi*wavelengthFactor)) ...
            + floor(mean(offset)/(2*pi*wavelengthFactor))); %#ok<AGROW>
        
    end
    runNumber = runNumber + 1;
    
end

runNumber = runNumber - 1;

theTitle = makeTitle(alpha, beta, gamma, epsilon0Pull, epsilon0Push, runNumber);

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
numPoints = 0;

for j = 1:size(sN, 2)
    
    for i = 1:size(sP, 1)
        
        if numRuns(i, j) ~= 0
            
            numPoints = numPoints + 1;
            mSize = 10*sqrt(numRuns(i,j)*100/runNumber);
            
            plot(sN(i,j), sP(i,j), 's', 'markeredgecolor', map(numPoints, :), ...
                'markerfacecolor', map(numPoints, :), ...
                'markersize', mSize);
            
            set(gca, 'units', 'points')
            pos = get(gca, 'position');
            xLim = get(gca, 'xlim');
            set(gca, 'units', 'normalized')
            
            text(sN(i,j)+(mSize/2)*(xLim(2) - xLim(1))/pos(3), sP(i,j), ...
                sprintf('%.0f%%', numRuns(i,j)*100/runNumber), 'fontsize', 14)
            
        end
        
    end
    
end

end
