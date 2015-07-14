function animateSolitonStatistics(saveMovie, varargin)

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
    
    [ solitonNumber(runNumber,:), solitonPosition(runNumber,:) ] = findSolitons(offset, wavelengthFactor); %#ok<AGROW>
    
    runNumber = runNumber + 1;
    
end

numTimes = size(phi, 2);
numRuns = runNumber - 1;

theTitle = makeTitle(unit, runNumber);

[ sN, sP ] = meshgrid(min(min(solitonNumber)):max(max(solitonNumber)), ...
    min(min(solitonPosition)):0.5:max(max(solitonPosition)));

solitonStats = zeros([ size(sN) numTimes ]);

for j = 1:numTimes
    
    for i = 1:numRuns
        
        sNIndex = solitonNumber(i, j) - min(min(solitonNumber)) + 1;
        sPIndex = 2*(solitonPosition(i, j) - min(min(solitonPosition))) + 1;
        solitonStats(sPIndex, sNIndex, j) = solitonStats(sPIndex, sNIndex, j) + 1;
        
    end
    
end

fH = figure('KeyPressFcn', @startAnimation);
hold on
grid on
box on

set(gca, 'xlim', [ min(min(solitonNumber))-1 max(max(solitonNumber))+1 ])
set(gca, 'ylim', [ min(min(solitonPosition))-1 max(max(solitonPosition))+1 ])

% set(gca, 'xlim', [ -1 7 ])
% set(gca, 'ylim', [ -10 10 ])

set(gca, 'fontsize', 14)
xlabel('# of solitons')
ylabel('chain offset')
title(theTitle)

yM = get(gca, 'ylim');
xM = get(gca, 'xlim');

yT = yM(1) + 0.9*(yM(2)-yM(1));
xT = xM(1) + 0.7*(xM(2)-xM(1));

handle = text(xT, yT, sprintf('%s = %.1f%s', ...
    unit.timeSymbol{unit.flag}, unit.timeFactor{unit.flag}*tau(1), ...
    unit.timeName{unit.flag}));
set(handle, 'fontsize', 14)

map = colormap(lines);
pH = zeros(size(sN));
baseSize = 3;

for j = 1:size(sN, 2)
    
    for i = 1:size(sP, 1)
        
        if solitonStats(i, j, 1) ~= 0
            
            mSize = baseSize*sqrt(solitonStats(i, j, 1)*100/numRuns);
            
        else
            
            mSize = 0.001;
            
        end
            
        pH(i, j) = plot(sN(i,j), sP(i,j), 's', 'markeredgecolor', map(1, :), ...
            'markerfacecolor', map(1, :), ...
            'markersize', mSize);
            
    end
    
end

if saveMovie
    
    startAnimation([], true)
    
    frame = 1;
    
    pathFormats{2} = 'Movies';
    moviePathName = makePath(pathFormats, pathValues, []);

    if ~exist(moviePathName, 'dir')
    
        mkdir(moviePathName);
    
    end

    gifFileName = sprintf('%s/%sSolitonStatistics.gif', moviePathName, geometry);
    addFrameToGIF(frame, fH, gifFileName)
    
    mp4FileName = sprintf('%s/%sSolitonStatistics.mp4',moviePathName, geometry);
    mp4Object = VideoWriter(mp4FileName, 'MPEG-4');
    open(mp4Object);
    writeVideo(mp4Object, getframe(fH));
    
else
    
    startAnimation([], false)
    
end

for n = 2:numTimes
    
    if ~ishandle(fH)
        
        break
        
    end
   
    for j = 1:size(sN, 2)
        
        for i = 1:size(sP, 1)
            
            if solitonStats(i, j, n) ~= 0
                
                mSize = baseSize*sqrt(solitonStats(i, j, n)*100/numRuns);
                
                set(pH(i, j), 'markersize', mSize);
                
            else
                
                set(pH(i, j), 'markersize', 0.001);
                
            end
            
        end
        
    end

    set(handle, 'string', sprintf('%s = %.1f%s', ...
        unit.timeSymbol{unit.flag}, unit.timeFactor{unit.flag}*tau(n), ...
        unit.timeName{unit.flag}))
    
    if saveMovie
        
        drawnow;
        if ishandle(fH)
            
            frame = frame + 1;
            addFrameToGIF(frame, fH, gifFileName)
            writeVideo(mp4Object, getframe(fH));

        end
        
    else
        
        pause(0.05);
        
    end
    
end

if saveMovie
    
    close(mp4Object)
    close(fH)
    
end

end
