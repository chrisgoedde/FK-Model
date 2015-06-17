function [ u, v ] = oldRingIC(N, S, type, f0, bathTemp, eta)
% ringIC(N0, S, type, eta)
% The input parameters are:
% N0: the number of carbon rings in the nanotube
% S: the excess or deficit of water molecules compared to N0
% type: the CNT type (n, n)

% Initial conditions and time step information

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

kB = 1.3806488e-23; % Boltzmann constant in J/K 

V0 = V0*6.948e-21; % convert V0 from kcal/mol to J

l = 0.2456e-9; % carbon ring length, in m
lambda = l/2; % substrate potential wavelength, in m

mWater = 2.992e-26; % mass of water molecule, in kg
m = mWater*ones(N, 1); % vector of molecule masses
mAvg = mean(m); % average mass

aWater = 0.28e-9; % equilibrium water spacing, in m
% a = aWater*ones(N, 1); % vector of water spacing, in m
% L = N0*l; % length of nanotube

g = m*(c/aWater)^2; % vector of spring constants

% t0 = (lambda/(2*pi))*sqrt(2*mAvg/V0); % time normalization
p0 = sqrt(mAvg*V0/2); % momentum normalization
g0 = 2*pi^2*V0/lambda^2; % spring normalization

% Nondimensional constants.

gamma = g/g0;

fMax = 3*(1e12*p0)*(eta/4)*sqrt(mean(gamma)-64/pi^2);
f0 = min(f0, fMax);

numKinks = 2*abs(S);
kinkSpacing = N/numKinks;

u = zeros(N, 1);
v = zeros(N, 1);

moleculeIndex = (0:N-1)';
kinkSpeed = 1/sqrt(1+(4*p0*eta/(pi*f0*1e-12)).^2);
width = 1/sqrt(1-kinkSpeed^2);
sigma = sign(S);

if fMax == f0

    fprintf('Using a force of %.3f pN to set width to %.3e.\n', fMax, width);
    
end

for k = 1:numKinks

    x = (moleculeIndex - (2*k-1)*kinkSpacing/2)/sqrt(mean(gamma));

    u = u + 4*atan(exp(-sigma*width*x));

    % We leave sigma out of the velocity ... don't quite understand this.
    v = v + 2*kinkSpeed*width./cosh(-sigma*width*x);
    
end

fprintf('Old kinkSpeed = %.2e, width = %.2e\n', kinkSpeed, width)

u = u - 2*pi*(S+abs(S));
v = v + sqrt(kB*bathTemp/mAvg)*randn(size(v))*mAvg/p0;

% figure
% plot(moleculeIndex, u, 'o')
% set(gca, 'fontsize', 18)
% xlabel('molecule index')
% ylabel('offset')
% title(sprintf('slope = %.2e, pi/(Delta x) = %.2e', 2*width, pi*sqrt(mean(gamma))))

% figure
% plot(moleculeIndex, v, 'o')

u = u + 4*pi*(0:(N-1))';

end
