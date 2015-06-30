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
        epsilonPull, tau0Pull, taufPull);
initSubstrateForce(M, Lambda, Psi);
[ springForceLeft, springForceRight, dampingForce, drivingForce, substrateForce ] = findChainForces(tau, phi, rho, alpha, gamma, beta);

theTitle = makeTitle(alpha, beta, gamma, kB*bathTemp/V0, epsilon0Pull, epsilon0Push, runNumber);

figure;

% totalForce = springForceLeft(partNum, :) + springForceRight(partNum, :);
%     + potentialForce(partNum, :) ...
%     + drivingForce(partNum, :) + dampingForce(partNum, :);

time = t0*tau*1e9;
if max(time) <= 0.01
    
    time = time*1e3;
    timeUnit = 'ps';
    
else
    
    timeUnit = 'ns';
    
end

plot(time, springForceLeft(partNum, :), 'linewidth', 2), grid on, box on, hold on
plot(time, springForceRight(partNum, :), 'linewidth', 2), grid on, box on, hold on
plot(time, substrateForce(partNum, :), 'linewidth', 2)
plot(time, drivingForce(partNum, :), 'linewidth', 2)
plot(time, dampingForce(partNum, :), 'linewidth', 2)
% plot(time, totalForce, 'linewidth', 2)

set(gca, 'fontsize', fontSize)
xlabel(sprintf('time (%s)', timeUnit))
ylabel(sprintf('Dimensionless force on molecule %d', partNum))

% legend('Left Spring', 'Right Spring', 'Substrate', 'External', 'Damping', 'Total', 'location', 'best')
legend('Left Spring', 'Right Spring', 'Substrate', 'External', 'Damping', 'location', 'best')

title(theTitle)

end
