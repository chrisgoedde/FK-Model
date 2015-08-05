function animateFK(saveMovie, varargin)
    
    [ pathFormats, pathValues, runNumber ] = parseArguments(varargin{:}, 'Save Type', 'Data');
    [ unit ] = setPhysicalConstants(varargin{:});
    
    load(FKDefaults, 'geometry', 'alpha', 'wF', 'N0', 'S')

    readPathName = makePath(pathFormats, pathValues, []);
    
    if ~exist(sprintf('%s', readPathName), 'dir')
        
        fprintf('No appropriate folder at %s.\n', readPathName);
        return
        
    end
        
    [ tau, phi, ~ ] = loadDynamics(readPathName, geometry, runNumber);
    
    [ stretch, offset ] = findChainPosition(phi, wF);
    
    theTitle = makeTitle(unit, runNumber);
    
    moleculeIndex = (1:N0+S)';
    
    fH = figure('KeyPressFcn', @startAnimation);
    
    % p = plot(moleculeIndex, stretch(:, 1), 'o');
    % p = plot(moleculeIndex, (offset(:, 1)-mean(offset(:, 1)))/(4*pi), 'o');
    p = plot(moleculeIndex, offset(:, 1)/(2*pi*wF), 'o');
    % p = plot(moleculeIndex, phi(:, 1)/(4*pi), 'o');
    
    hold on
    grid on
    box on
    set(gca, 'fontsize', 14)
    xlabel('molecule number')
    ylabel('(z_n - n\lambda)/\lambda')
    
    pos = get(gca, 'Position');
    pos(4) = 0.70;
    set(gca, 'Position', pos)
    
    set(gca, 'xlim', [ 0 N0+S ])
    
    yMax = ceil(max(max(offset)/(2*pi*wF)));
    yMin = floor(min(min(offset)/(2*pi*wF)));
    set(gca, 'ylim', [ yMin yMax ])
    
    yM = get(gca, 'ylim');
    xM = get(gca, 'xlim');
    
    yT = yM(1) + 0.9*(yM(2)-yM(1));
    xT = xM(1) + 0.7*(xM(2)-xM(1));
    
    handle = text(xT, yT, sprintf('%s = %.1f%s', ...
        unit.timeSymbol{unit.flag}, unit.timeFactor{unit.flag}*tau(1), ...
        unit.timeName{unit.flag}));
    set(handle, 'fontsize', 14)
    
    title(theTitle)
    
    if saveMovie
        
        startAnimation([], true)
        
        frame = 1;
        
        pathFormats{2} = 'Movies';
        moviePathName = makePath(pathFormats, pathValues, []);
        
        if ~exist(moviePathName, 'dir')
            
            mkdir(moviePathName);
            
        end
        
        gifFileName = sprintf('%s/%s-%d.gif', moviePathName, geometry, runNumber);
        addFrameToGIF(frame, fH, gifFileName)
        
        mp4FileName = sprintf('%s/%s.mp4',moviePathName, geometry);
        mp4Object = VideoWriter(mp4FileName, 'MPEG-4');
        open(mp4Object);
        writeVideo(mp4Object, getframe(fH));
        
    else
        
        startAnimation([], false)
        
    end
    
    for i = 2:size(stretch, 2)
        
        if ~ishandle(fH)
            
            break
            
        end
        
        set(p, 'ydata', offset(:, i)/(2*pi*wF));
        
        set(handle, 'string', sprintf('%s = %.1f%s', ...
            unit.timeSymbol{unit.flag}, unit.timeFactor{unit.flag}*tau(i), ...
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
