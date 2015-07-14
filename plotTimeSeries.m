function plotTimeSeries(varargin)

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

[ tau, phi, rho, ~, rhoAvg ] = loadDynamics(readPathName, geometry, runNumber);

if unit.timeFactor{2} * tau(end) >= 1000
    
    unit.timeFactor{2} = unit.timeFactor{2}/1000;
    unit.timeName = ' ns';
    unit.timeLabel = '(ns)';
    
end

time = unit.timeFactor{unit.flag} * tau;
fF = unit.forceFactor{unit.flag};
vF = unit.velocityFactor{unit.flag};
EF = unit.energyFactor{unit.flag};

[ KE, PE ] = findChainEnergy(phi, rho, alphaVector, deltaVector, gammaVector);
initDrivingForce(epsilonVector, epsilonPushVector, tau0Push, taufPush, ...
        epsilonPullVector, tau0Pull, taufPull, phiTug, taufTug, gammaTug, startTug);
initSubstrateForce(M, Lambda, Psi);
[ springForceLeft, springForceRight, dampingForce, drivingForce, substrateForce ] = findChainForces(tau, phi, rho, alphaVector, gammaVector, beta);

theTitle = makeTitle(unit, runNumber);

f = figure;

pos = get(f, 'position');
pos(3) = pos(3)*2;
pos(4) = pos(4)*2;
set(f, 'position', pos);

subplot(2, 2, 1)

plot(time, fF * sum(substrateForce), 'g', 'linewidth', 2)
grid on, box on, hold on
plot(time, fF * sum(springForceLeft + springForceRight), 'b', 'linewidth', 2) 
plot(time, fF * sum(dampingForce), 'r', 'linewidth', 2)
plot(time, fF * sum(drivingForce), 'k', 'linewidth', 2)

set(gca, 'fontsize', fontSize)
xlabel(sprintf('Time %s', unit.timeLabel{unit.flag}))
ylabel(sprintf('Force %s', unit.forceLabel{unit.flag}))
legend('Substrate', 'Spring', 'Damping', 'Driving', 'location', 'best')

title(theTitle)

% subplot(2, 2, 2)

subplot(2, 2, 3)

plot(time, vF * mean(rhoAvg), 'k', 'linewidth', 2), grid on, box on, hold on

set(gca, 'fontsize', fontSize)
xlabel(sprintf('time %s', unit.timeLabel{unit.flag}))
ylabel(sprintf('flow rate %s', unit.velocityLabel{unit.flag}))

title(theTitle)

subplot(2, 2, 4)

plot(time, EF * PE/N, 'r', 'linewidth', 2), grid on, box on, hold on
plot(time, EF * KE/N, 'g', 'linewidth', 2)

set(gca, 'fontsize', fontSize)
xlabel(sprintf('time %s', unit.timeLabel{unit.flag}))
ylabel(sprintf('Energy per monomer %s', unit.energyLabel{unit.flag}))

legend('Potential', 'Kinetic', 'location', 'best')

title(theTitle)

end
