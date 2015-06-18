function animateFK(movieFileName, varargin)

alpha = [];
gamma = [];
beta = [];

[ pathFormats, pathValues, runNumber ] = parseArguments(varargin{:});

load(FKDefaults, 'geometry')

readPathName = makePath(pathFormats, pathValues, []);

if ~exist(sprintf('%s/%sConstants.mat', readPathName, geometry), 'file')
    
    fprintf('No appropriate run at %s.\n', readPathName);
    return
    
end

load(sprintf('%s/%sConstants.mat', readPathName, geometry));

[ tau, phi, rho ] = loadDynamics(readPathName, geometry, runNumber);

[ stretch, offset, ~, ~, ~, ~, ~, ~, ~ ] = processChain(phi, rho, wavelengthFactor, alpha, delta, gamma, beta, epsilon);

theTitle = makeAnimationTitle(alpha, gamma, runNumber);

moleculeIndex = (1:N)';

fH = figure('KeyPressFcn', @startAnimation);

% p = plot(moleculeIndex, stretch(:, 1), 'o');
% p = plot(moleculeIndex, (offset(:, 1)-mean(offset(:, 1)))/(4*pi), 'o');
p = plot(moleculeIndex, offset(:, 1)/(2*pi*wavelengthFactor), 'o');
% p = plot(moleculeIndex, phi(:, 1)/(4*pi), 'o');

hold on
grid on
box on
set(gca, 'fontsize', 14)
xlabel('molecule number')
% ylabel('stretch (arb)')
% ylabel('soliton shape')
ylabel('(z_n - n\lambda)/\lambda')
% set(gca, 'ylim', [ min(stretch(:, 1))*1.25 max(stretch(:, 1))*0.8 ])
% if S ~= 0
%     set(gca, 'ylim', [ -0.5*abs(S) 0.5*abs(S) ])
% else
%     set(gca, 'ylim', [ -0.5 0.5 ])
% end

set(gca, 'xlim', [ 0 N ])
yMax = ceil(max(max(offset)/(2*pi*wavelengthFactor)));
yMin = floor(min(min(offset)/(2*pi*wavelengthFactor)));

set(gca, 'ylim', [ yMin yMax ])

yM = get(gca, 'ylim');
xM = get(gca, 'xlim');

yT = yM(1) + 0.9*(yM(2)-yM(1));
xT = xM(1) + 0.7*(xM(2)-xM(1));

handle = text(xT, yT, sprintf('time = %.1f ps', t0*tau(1)*1e12));
set(handle, 'fontsize', 14)

title(theTitle)

if isempty(movieFileName)
    
    startAnimation([], false)
    
else
    
    startAnimation([], true)
    
    frame = 1;

    gifFileName = sprintf('../Movies/%s.gif', movieFileName);
    addFrameToGIF(frame, fH, gifFileName)
    
    mp4FileName = sprintf('../Movies/%s.mp4', movieFileName);
    mp4Object = VideoWriter(mp4FileName, 'MPEG-4');
    open(mp4Object);
    writeVideo(mp4Object, getframe(fH));
    
end

for i = 2:size(stretch, 2)
    
    if ~ishandle(fH)
        
        break
        
    end
   
    set(p, 'ydata', offset(:, i)/(2*pi*wavelengthFactor));

    set(handle, 'string', sprintf('time = %.1f ps', t0*tau(i)*1e12))

    if ~isempty(movieFileName)
        
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

if ~isempty(movieFileName)
    
    close(mp4Object)
    
end

end
