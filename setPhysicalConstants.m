function [ V0, c, l, lambda, mWater, aWater, kB ] = setPhysicalConstants(type)
% [ V0, c, l, lambda, mWater, aWater, kB ] = setPhysicalConstants(type)
% Set the physical constants for the nanotube, based on type.
% type = 4, 5, or 6 for (4, 4), (5, 5), or (6, 6) nanotube.

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

aWater = 0.28e-9; % equilibrium water spacing, in m
kB = 1.3806488e-23; % Boltzmann constant in J/K

end
