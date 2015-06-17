function plotEnergy(varargin)

[ pathFormats, pathValues, runNumber ] = parseArguments(varargin{:});

load(FKDefault, 'geometry')

readPathName = makePath(pathFormats, pathValues, []);

alpha = [];
gamma = [];
beta = [];

fontSize = 14;

if ~PathExists(sprintf('%s/%sConstants.mat', readPathName, geometry))
    
    fprintf('No appropriate run at %s.\n', readPathName);
    return
    
end

load(sprintf('%s/%sConstants.mat', readPathName, geometry));

[ tau, phi, rho, ~, ~ ] = loadDynamics(readPathName, geometry, runNumber);
% rhoAvg = rhoAvg';

[ ~, ~, ~, KE, PE, power, ~, ~, ~, ~ ] = processChain(phi, rho, alpha, delta, gamma, beta, epsilon);

theTitle = makePlotTitle(alpha, gamma, varargin{:});

figure;

plot(t0*tau*1e9, (V0/2)*PE/(N*kB), 'r', 'linewidth', 2), grid on, box on, hold on
plot(t0*tau*1e9, (V0/2)*KE/(N*kB), 'g', 'linewidth', 2)

coeff = polyfit(t0*tau*1e9, 2*(V0/2)*KE/(N*kB), 1);
power = mean(sum(power))*(V0/(2*t0))*1e-9*(2/(N*kB));
fprintf('Power input per molecule (predicted, actual) = (%.2f %.2f)  K/ns.\n', power, coeff(1));

set(gca, 'fontsize', fontSize)
xlabel('time (ns)')
ylabel('Energy per molecule (Kelvin)')

legend('Potential', 'Kinetic', 'location', 'best')

title(theTitle)

end
