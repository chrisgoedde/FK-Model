function plotTimeSeries(varargin)

[ pathFormats, pathValues, runNumber ] = parseArguments(varargin{:});

load(FKDefaults, 'N0', 'eta', 'S', 'f0', 'geometry')

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

[ tau, phi, rho, ~, rhoAvg ] = loadDynamics(readPathName, geometry, runNumber);
% rhoAvg = rhoAvg';

[ KE, PE ] = findChainEnergy(phi, rho, alpha, delta, gamma);
initForce(epsilon, epsilonPush, tau0Push, taufPush, ...
        epsilonPull, tau0Pull, taufPull);
[ springForceLeft, springForceRight, dampingForce, drivingForce, potentialForce ] = findChainForces(tau, phi, rho, alpha, gamma, beta);

% pAvg = p0*mean(rho);
% vAvg = pAvg/mAvg;
c = mean(a) * sqrt(mean(g)/mAvg);
vSol = c./sqrt(1+(4*p0*eta/(pi*f0*1e-12)).^2);
% deltaT = (N0*lambda)/vSol;
% nPer = tf*1e-9/deltaT;
% periods = linspace(0, tf, nPer);

theTitle = makeTitle(alpha, beta, gamma, kB*bathTemp/V0, epsilon0Pull, epsilon0Push, runNumber);

time = t0*tau*1e9;
if max(time) <= 0.01
    
    time = time*1e3;
    timeUnit = 'ps';
    
else
    
    timeUnit = 'ns';
    
end

f = figure;

pos = get(f, 'position');
pos(3) = pos(3)*2;
pos(4) = pos(4)*2;
set(f, 'position', pos);

subplot(2, 2, 1)

plot(time, p0*sum(potentialForce)*1e12/t0, 'g', 'linewidth', 2)
grid on, box on, hold on
plot(time, p0*sum(springForceLeft + springForceRight)*1e12/t0, 'b', 'linewidth', 2) 
plot(time, p0*sum(dampingForce)*1e12/t0, 'r', 'linewidth', 2)
plot(time, p0*sum(drivingForce)*1e12/t0, 'k', 'linewidth', 2)

set(gca, 'fontsize', fontSize)
xlabel(sprintf('time (%s)', timeUnit))
ylabel('force (pN)')
% set(gca, 'ylim', [ 0 4 ])
legend('potential', 'spring', 'damping', 'driving', 'location', 'best')

title(theTitle)

% subplot(2, 2, 2)

subplot(2, 2, 3)

% whos

% plot(time, vAvg, 'b', 'linewidth', 2), grid on, box on, hold on
plot(time, p0*mean(rhoAvg)/mAvg, 'k', 'linewidth', 2), grid on, box on, hold on
plot(time, vSol*abs(S)*ones(size(tau))/N0, 'r', 'linewidth', 2)
% plot(time, c*abs(S)*ones(size(tau))/N0, 'g', 'linewidth', 2)

% yb = get(gca, 'ylim');
% set(gca, 'ylim', [ 0 yb(2) ])
legend('actual', 'Theory', 'location', 'best')

set(gca, 'fontsize', fontSize)
xlabel(sprintf('time (%s)', timeUnit))
ylabel('flow rate (m/s)')

title(theTitle)

subplot(2, 2, 4)

PE0 = 0;

% plot(time, (V0/2)*(PE-PE0)/(N*kB), 'r', 'linewidth', 2), grid on, box on, hold on
% plot(time, (V0/2)*KE/(N*kB), 'g', 'linewidth', 2)

plot(time, (PE-PE0)/N, 'r', 'linewidth', 2), grid on, box on, hold on
plot(time, KE/N, 'g', 'linewidth', 2)

set(gca, 'fontsize', fontSize)
xlabel(sprintf('time (%s)', timeUnit))
ylabel('Dimensionless energy per molecule')

% legend('KE per molecule', 'Barrier height', 'location', 'best')

% legend('Observed', 'Predicted', 'location', 'best')

legend('Potential', 'Kinetic', 'location', 'best')

title(theTitle)

end
