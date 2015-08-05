function [ unit ] = setPhysicalConstants(varargin)
    % [ unit ] = setPhysicalConstants(varargin)
    % Set the physical constants for the nanotube, based on type.
    % Type = 4, 5, or 6 for (4, 4), (5, 5), or (6, 6) nanotube.
    % Monomer = 'water'
    
    unit.V0 = 3.5e-1; % default substrate potential [ (4, 4) nanotube ]
    unit.mass = 2.992e-26; % default monomer mass [ water ]
    unit.flag = 1;
    unit.monomer = 'water';
    unit.type = '(4, 4)';
    
    for i = 1:length(varargin)/2
        
        theString = varargin{2*i-1};
        theValue = varargin{2*i};
        
        switch theString
            
            case 'Type'
                
                switch theValue
                    
                    case 4
                        
                        unit.V0 = 3.5e-1; % substrate potential for (4,4) nanotube, in kcal/mol
                        unit.flag = 2;
                        unit.type = '(4, 4)';
                        
                    case 5
                        
                        unit.V0 = 1.6e-2; % substrate potential for (5,5) nanotube, in kcal/mol
                        unit.flag = 2;
                        unit.type = '(5, 5)';
                        
                    case 6
                        
                        unit.V0 = 2.1e-3; % substrate potential for (6,6) nanotube, in kcal/mol
                        unit.flag = 2;
                        unit.type = '(6, 6)';
                        
                end
                
            case 'Monomer'
                
                switch theValue
                    
                    case 'water'
                        
                        unit.mass = 2.992e-26; % mass of water molecule, in kg
                        unit.flag = 2;
                        unit.monomer = 'water';
                        
                end
                
        end
        
    end
    
    unit.V0 = unit.V0*6.948e-21; % convert V0 from kcal/mol to J
    l = 0.2456e-9; % carbon ring length, in m
    unit.lambda = l/2; % substrate potential wavelength, in m
    unit.kB = 1.3806488e-23; % Boltzmann constant in J/K
    
    unit.t0 = (unit.lambda/(2*pi)) * sqrt(2*unit.mass/unit.V0); % time normalization in s
    unit.p0 = sqrt(unit.mass*unit.V0/2); % momentum normalization in kg m/s
    unit.g0 = 2*pi^2*unit.V0/unit.lambda^2; % spring constant normalization in N/m
    
    unit.forceFactor = { 1, unit.p0/unit.t0 * 1e12 };
    unit.forceName = { '', ' pN' };
    unit.forceLabel = { '(dimensionless)', '(pN)' };
    unit.forceSymbol = { '\epsilon', 'f' };
    
    unit.energyFactor = { 1, unit.V0/(2*unit.kB) };
    unit.energyName = { '', ' K' };
    unit.energyLabel = { '(dimensionless)', '(K)' };
    unit.energySymbol = { 'E', 'E' };
    
    unit.timeFactor = { 1, unit.t0 * 1e12 };
    unit.timeName = { '', ' ps' };
    unit.timeLabel = { '(dimensionless)', '(ps)' };
    unit.timeSymbol = { '\tau', 't' };
    
    unit.tempFactor = { 1, unit.V0/(2*unit.kB) };
    unit.tempName = { '', ' K' };
    unit.tempLabel = { '(dimensionless)', '(K)' };
    unit.tempSymbol = { '\Theta', 'T' };
    
    unit.dampingFactor = { 1, 1/unit.t0 };
    unit.dampingName = { '', ' Hz' };
    unit.dampingLabel = { '(dimensionless)', '(Hz)' };
    unit.dampingSymbol = { '\beta', '\eta' };
    
    unit.springFactor = { 1, unit.g0 };
    unit.springName = { '', ' N/m' };
    unit.springLabel = { '(dimensionless)', '(N/m)' };
    unit.springSymbol = { '\gamma', 'g' };
    
    unit.velocityFactor = { 1, unit.p0/unit.mass };
    unit.velocityName = { '', ' m/s' };
    unit.velocityLabel = { '(dimensionless)', '(m/s)' };
    unit.velocitySymbol = { '\nu', 'v' };
    
end
