function plotForce(partNum, varargin)

[ pathFormats, pathValues, runNumber ] = parseArguments(varargin{:});

load(FKDefaults, 'geometry')

readPathName = makePath(pathFormats, pathValues, []);

alpha = [];
gamma = [];
beta = [];

fontSize = 14;

if ~exist(sprintf('%s/%sConstants.mat', readPathName, geometry), 'file')
    
    fprintf('No appropriate run at %s.\n', readPathName);
    return
    
end

load(sprintf('%s/%sConstants.mat', readPathName, geometry));

[ tau, phi, rho, ~, ~ ] = loadDynamics(readPathName, geometry, runNumber);
% rhoAvg = rhoAvg';

initDrivingForce(epsilon, epsilonPush, tau0Push, taufPush, ...
        epsilonPull, tau0Pull, taufPull, phiTug, taufTug, gammaTug, startTug);
initSubstrateForce(M, Lambda, Psi);
[ springForceLeft, springForceRight, dampingForce, drivingForce, substrateForce ] = findChainForces(tau, phi, rho, alphaVector, gammaVector, beta);

theTitle = makeTitle(runNumber);

figure;

% totalForce = springForceLeft(partNum, :) + springForceRight(partNum, :);
%     + potentialForce(partNum, :) ...
%     + drivingForce(partNum, :) + dampingForce(partNum, :);

plot(tau, springForceLeft(partNum, :), 'linewidth', 2), grid on, box on, hold on
plot(tau, springForceRight(partNum, :), 'linewidth', 2), grid on, box on, hold on
plot(tau, substrateForce(partNum, :), 'linewidth', 2)
plot(tau, drivingForce(partNum, :), 'linewidth', 2)
plot(tau, dampingForce(partNum, :), 'linewidth', 2)
% plot(time, totalForce, 'linewidth', 2)

set(gca, 'fontsize', fontSize)
xlabel('Dimensionless time')
ylabel(sprintf('Dimensionless force on molecule %d', partNum))

% legend('Left Spring', 'Right Spring', 'Substrate', 'External', 'Damping', 'Total', 'location', 'best')
legend('Left Spring', 'Right Spring', 'Substrate', 'External', 'Damping', 'location', 'best')

title(theTitle)

end
