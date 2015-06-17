function setConstants(N0, type, f0, bathTemp, eta) %#ok<INUSL>

% Physical constants

switch type
    
    case 4
        
        V0 = 3.5e-1; % substrate potential for (4,4) nanotube, in kcal/mol
        c = 11.1e3; % speed of sound in (4,4) nanotube, in m/s
        
    case 5
        
        V0 = 1.6e-2; % substrate potential for (5,5) nanotube, in kcal/mol
        c = 7.4e3;% speed of sound in (5,5) nanotube, in m/s
        
    case 6
        
        V0 = 2.1e-3; % substrate potential for (6,6) nanotube, in kcal/mol
        c = 4.4e3;% speed of sound in (6,6) nanotube, in m/s
        
    otherwise
    
        disp('type must be 4, 5, or 6.')
        return
        
end

V0 = V0*6.948e-21; % convert V0 from kcal/mol to J

l = 0.2456e-9; % carbon ring length, in m
lambda = l/2; % substrate potential wavelength, in m

mWater = 2.992e-26; % mass of water molecule, in kg
m = mWater; % vector of molecule masses
mAvg = mean(m); % average mass

aWater = 0.28e-9; % equilibrium water spacing, in m
a = aWater; % vector of water spacing, in m
% eta = 3e12; % damping, in inverse seconds
kB = 1.3806488e-23; % Boltzmann constant in J/K 
L = N0*l; % length of nanotube

g = m*(c/aWater)^2; % vector of spring constants

t0 = (lambda/(2*pi))*sqrt(2*mAvg/V0); % time normalization
p0 = sqrt(mAvg*V0/2); % momentum normalization
g0 = 2*pi^2*V0/lambda^2; % spring normalization

% Nondimensional constants.

mu = m/mAvg;
delta = 1./mu;
gamma = g/g0;

alpha = (2*pi/lambda)*a;

epsilon0 = t0*(f0*1e-12)/p0;
epsilon = epsilon0; %#ok<*NASGU>

beta = t0*eta;

d = sqrt(gamma);

fprintf('t0 = %.3e ps.\n', t0*1e12)
fprintf('p0/m = %.3e m/s.\n', p0/mAvg)
fprintf('g0 = %.3e N/m.\n', g0)
fprintf('gamma = %.3e.\n', gamma)
fprintf('d = %.3e.\n', d)

f = logspace(-5, 1, 41);

colors = lines;
dampingFactor = [ 1 2 4 8 10 100 ];
legendArray = cell(1, length(dampingFactor));

for j = 1:length(dampingFactor)

    v = a*sqrt(g/m)./sqrt(1+(4*p0*(eta*dampingFactor(j))./(pi*f*1e-12)).^2);
    loglog(f, v, 'linewidth', 2, 'color', colors(j,:)), hold on
    xlabel('force (pN)')
    ylabel('solition velocity (m/s)')
    
    legendArray{j} = sprintf('eta = %.2e', eta*dampingFactor(j));

end

grid on, grid minor

legend(legendArray, 'location', 'best')

end
