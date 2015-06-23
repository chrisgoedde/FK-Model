function plotEnergy(varargin)

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

[ ~, ~, KE, PE, power, ~, ~, ~, ~, ~ ] = processChain(tau, phi, rho, wavelengthFactor, alpha, delta, gamma, beta, epsilon,  epsilonPush, tau0Push, taufPush, epsilonPull, tau0Pull, taufPull);

theTitle = makePlotTitle(alpha, gamma, runNumber);

time = t0*tau*1e9;
if max(time) <= 0.01
    
    time = time*1e3;
    timeUnit = 'ps';
    
else
    
    timeUnit = 'ns';
    
end

figure;

plot(time, (V0/2)*PE/(N*kB), 'r', 'linewidth', 2), grid on, box on, hold on
plot(time, (V0/2)*KE/(N*kB), 'g', 'linewidth', 2)

coeff = polyfit(time, 2*(V0/2)*KE/(N*kB), 1);
power = mean(sum(power))*(V0/(2*t0))*1e-9*(2/(N*kB));
fprintf('Power input per molecule (predicted, actual) = (%.2f %.2f)  K/%s.\n', power, coeff(1), timeUnit);

set(gca, 'fontsize', fontSize)
xlabel(sprintf('time (%s)', timeUnit))
ylabel('Energy per molecule (Kelvin)')

legend('Potential', 'Kinetic', 'location', 'best')

title(theTitle)

end
