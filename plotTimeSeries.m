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

[ ~, ~, KE, PE, power, springForceLeft, springForceRight, dampingForce, drivingForce, potentialForce ] = processChain(tau, phi, rho, wavelengthFactor, alpha, delta, gamma, beta);

% pAvg = p0*mean(rho);
% vAvg = pAvg/mAvg;
c = mean(a) * sqrt(mean(g)/mAvg);
vSol = c./sqrt(1+(4*p0*eta/(pi*f0*1e-12)).^2);
% deltaT = (N0*lambda)/vSol;
% nPer = tf*1e-9/deltaT;
% periods = linspace(0, tf, nPer);

theTitle = makeTitle(alpha, beta, gamma, epsilon0Pull, epsilon0Push, runNumber);

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

subplot(2, 2, 2)

% plot(time, sum(rho)*beta, 'b'), grid on, box on, hold on
% plot(time, sum(abs(rho))*beta, 'r'), grid on, box on, hold on
% plot(time, sum(epsilon)*ones(size(tau)), 'g')
% % plot(time, pi*V0*sum(sin(phi))/lambda, 'k')
% xlabel(sprintf('time (%s)', timeUnit))
% ylabel('force (arb)')
% legend('translational damping', 'total damping', 'driving', 'location', 'best')
% set(gca, 'ylim', [ 0 0.2 ])

% plot(time, sum(power)*(V0/(2*t0))*1e-9/(N*kB), 'b', 'linewidth', 2), box on, grid on, hold on

plot(time, sum(power)/N, 'b', 'linewidth', 2), box on, grid on, hold on

% plot(time, 1e9*lambda*phi(1,:)/(2*pi), 'b', 'linewidth', 2), grid on, box on, hold on
% plot(time, 1e9*lambda*phi(2,:)/(2*pi), 'g', 'linewidth', 2)
% plot(time, 1e9*lambda*phi(3,:)/(2*pi), 'r', 'linewidth', 2)
% plot([ 0 t0*tau(end)*1e9 ], [ 0 t0*tau(end)*1e9*vSol*abs(S)/N0 ], 'k', 'linewidth', 2)

set(gca, 'fontsize', fontSize)
xlabel(sprintf('time (%s)', timeUnit))
ylabel('Dimensionless power per molecule')
% legend('molecule 1', 'molecule 2', 'molecule 3', 'Theory', 'location', 'best')

title(theTitle)

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

% [ phiTemp, rhoTemp ] = ringIC(N, S, epsilon0, beta, gamma, 0);
% [ ~, ~, ~, ~, PE0, ~, ~, ~, ~, ~, ~ ] = processChain(tau, phiTemp, rhoTemp, wavelengthFactor, alpha, delta, gamma, beta);
PE0 = 0;

% plot(time, (V0/2)*(PE-PE0)/(N*kB), 'r', 'linewidth', 2), grid on, box on, hold on
% plot(time, (V0/2)*KE/(N*kB), 'g', 'linewidth', 2)

plot(time, (PE-PE0)/N, 'r', 'linewidth', 2), grid on, box on, hold on
plot(time, KE/N, 'g', 'linewidth', 2)

% coeff = polyfit(time, 2*(V0/2)*KE/(N*kB), 1);
% power = mean(sum(power))*(V0/(2*t0))*1e-9*(2/(N*kB));
% fprintf('Power input per molecule (predicted, actual) = (%.2f %.2f)  K/%s.\n', power, coeff(1), timeUnit);

% plot([ 0 time(end) ], [ coeff(2) coeff(2) + t0*tau(end)*1e9*power ], 'k', 'linewidth', 2)
% yb = get(gca, 'ylim');
% set(gca, 'ylim', [ 0 yb(2) ])

set(gca, 'fontsize', fontSize)
xlabel(sprintf('time (%s)', timeUnit))
ylabel('Dimensionless energy per molecule')

% legend('KE per molecule', 'Barrier height', 'location', 'best')

% legend('Observed', 'Predicted', 'location', 'best')

legend('Potential', 'Kinetic', 'location', 'best')

title(theTitle)

end
