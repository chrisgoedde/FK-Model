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

[ ~, ~, ~, ~, ~, springForceLeft, springForceRight, dampingForce, drivingForce, potentialForce ] = processChain(tau, phi, rho, wavelengthFactor, alpha, delta, gamma, beta, epsilon,  epsilonPush, tau0Push, taufPush, epsilonPull, tau0Pull, taufPull);

theTitle = makePlotTitle(alpha, gamma, runNumber);

figure;

% totalForce = springForceLeft(partNum, :) + springForceRight(partNum, :);
%     + potentialForce(partNum, :) ...
%     + drivingForce(partNum, :) + dampingForce(partNum, :);

plot(t0*tau*1e9, springForceLeft(partNum, :), 'linewidth', 2), grid on, box on, hold on
plot(t0*tau*1e9, springForceRight(partNum, :), 'linewidth', 2), grid on, box on, hold on
plot(t0*tau*1e9, potentialForce(partNum, :), 'linewidth', 2)
plot(t0*tau*1e9, drivingForce(partNum, :), 'linewidth', 2)
plot(t0*tau*1e9, dampingForce(partNum, :), 'linewidth', 2)
% plot(t0*tau*1e9, totalForce, 'linewidth', 2)

set(gca, 'fontsize', fontSize)
xlabel('time (ns)')
ylabel(sprintf('Dimensionless force on molecule %d', partNum))

% legend('Left Spring', 'Right Spring', 'Substrate', 'External', 'Damping', 'Total', 'location', 'best')
legend('Left Spring', 'Right Spring', 'Substrate', 'External', 'Damping', 'location', 'best')

title(theTitle)

end
