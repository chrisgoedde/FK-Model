function plotShift(varargin)

[ pathFormats, pathValues, runNumber ] = parseArguments(varargin{:});
[ unit ] = setPhysicalConstants(varargin{:});

load(FKDefaults, 'geometry')

readPathName = makePath(pathFormats, pathValues, []);

fontSize = 14;

if ~exist(sprintf('%s/%sConstants.mat', readPathName, geometry), 'file')
    
    fprintf('No appropriate run at %s.\n', readPathName);
    return
    
end

load(sprintf('%s/%sConstants.mat', readPathName, geometry));

[ tau, phi, ~, ~, ~ ] = loadDynamics(readPathName, geometry, runNumber);

[ ~, offset ] = findChainPosition(phi, wavelengthFactor, M, Lambda, alphaVector);

shift = floor((offset/pi+1)/2);

s0 = sum(shift == zeros(size(shift)))/N;
s1 = sum(shift == ones(size(shift)))/N;

% if unit.timeFactor{2} * tau(end) >= 1000
%     
%     unit.timeFactor{2} = unit.timeFactor{2}/1000;
%     unit.timeName{2} = ' ns';
%     unit.timeLabel{2} = '(ns)';
%     
% end

theTitle = makeTitle(unit, runNumber);

figure;

% totalForce = springForceLeft(partNum, :) + springForceRight(partNum, :);
%     + potentialForce(partNum, :) ...
%     + drivingForce(partNum, :) + dampingForce(partNum, :);

tF = unit.timeFactor{unit.flag};

plot(tF * tau, s0, tF * tau, s1, 'linewidth', 2), box on, grid on

set(gca, 'fontsize', fontSize)

xlabel(sprintf('Time %s', unit.timeLabel{unit.flag}))
ylabel('Fraction of monomers')

% legend('Left Spring', 'Right Spring', 'Substrate', 'External', 'Damping', 'Total', 'location', 'best')
legend('shift = 0', 'shift = 1\lambda', 'location', 'best')

title(theTitle)

end
