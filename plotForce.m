function plotForce(partNum, varargin)

[ pathFormats, pathValues, runNumber ] = parseArguments(varargin{:});
[ unit ] = setPhysicalConstants(varargin{:});

load(FKDefaults, 'geometry')

readPathName = makePath(pathFormats, pathValues, []);

beta = [];

fontSize = 14;

if ~exist(sprintf('%s/%sConstants.mat', readPathName, geometry), 'file')
    
    fprintf('No appropriate run at %s.\n', readPathName);
    return
    
end

load(sprintf('%s/%sConstants.mat', readPathName, geometry));

[ tau, phi, rho, ~, ~ ] = loadDynamics(readPathName, geometry, runNumber);

if unit.timeFactor{2} * tau(end) >= 1000
    
    unit.timeFactor{2} = unit.timeFactor{2}/1000;
    unit.timeName = ' ns';
    unit.timeLabel = '(ns)';
    
end

initDrivingForce(epsilonVector, epsilonPushVector, tau0Push, taufPush, ...
        epsilonPullVector, tau0Pull, taufPull, phiTug, taufTug, gammaTug, startTug);
initSubstrateForce(M, Lambda, Psi);
[ springForceLeft, springForceRight, dampingForce, drivingForce, substrateForce ] = findChainForces(tau, phi, rho, alphaVector, gammaVector, beta);

theTitle = makeTitle(unit, runNumber);

figure;

% totalForce = springForceLeft(partNum, :) + springForceRight(partNum, :);
%     + potentialForce(partNum, :) ...
%     + drivingForce(partNum, :) + dampingForce(partNum, :);

tF = unit.timeFactor{unit.flag};
fF = unit.forceFactor{unit.flag};

plot(tF * tau, fF * springForceLeft(partNum, :), 'linewidth', 2), grid on, box on, hold on
plot(tF * tau, fF * springForceRight(partNum, :), 'linewidth', 2), grid on, box on, hold on
plot(tF * tau, fF * substrateForce(partNum, :), 'linewidth', 2)
plot(tF * tau, fF * drivingForce(partNum, :), 'linewidth', 2)
plot(tF * tau, fF * dampingForce(partNum, :), 'linewidth', 2)
% plot(tF * tau, fF * totalForce, 'linewidth', 2)

set(gca, 'fontsize', fontSize)

xlabel(sprintf('Time %s', unit.timeLabel{unit.flag}))
ylabel(sprintf('Force on molecule %d %s', partNum, unit.forceLabel{unit.flag}))

% legend('Left Spring', 'Right Spring', 'Substrate', 'External', 'Damping', 'Total', 'location', 'best')
legend('Left Spring', 'Right Spring', 'Substrate', 'External', 'Damping', 'location', 'best')

title(theTitle)

end
