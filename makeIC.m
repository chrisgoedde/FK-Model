function [ phi0, rho0 ] = makeIC(N, geometry, beta, Omega)
    
    load(FKDefaults, 'alpha', 'gamma', 'M', 'Lambda', 'epsilon')
    wavelengthFactor = round(alpha/(2*pi));

    if strcmp(geometry, 'chain')
        
        phi0 = alpha * (0:(N-1))';
        rho0 = zeros(N, 1);
        
    elseif strcmp(geometry(1), 's')
        
        stretch = str2double(geometry(2:end));
        if stretch ~= 0 || M == 0
            
            [ phi0, rho0 ] = solitonIC(N, 0, stretch, wavelengthFactor, epsilon, beta, gamma, 0);
            
        else
            
            phi0 = wavelengthFactor * substrateMinima(N, M, Lambda);
            rho0 = zeros(N, 1);
            
        end
        
    elseif strcmp(geometry(1), 'e')
        
        stretch = str2double(geometry(2:end));
        if stretch ~= 0 || M == 0
            
            [ phi0, rho0 ] = solitonIC(N, 0, stretch, wavelengthFactor, epsilon, beta, gamma, 0);
            
        else
            
            phi0 = wavelengthFactor * substrateMinima(N, M, Lambda);
            rho0 = zeros(N, 1);
            
        end
        
        fprintf('Equilibrating initial condition ...\n')
        
        [ ~, phi, rho, ~, ~ ] = solveFK(500, 500, 500, phi0, rho0, ...
            0.01, Omega, @ode45);
        
        phi0 = phi(:, end);
        rho0 = rho(:, end);
        
        fprintf('Completed initial condition.\n')
        
    else
        
        if S > 0
            
            [ phi0, rho0 ] = solitonIC(N, wavelengthFactor*S, 0, wavelengthFactor, epsilon, beta, gamma, 0);
            
        elseif S < 0
            
            [ phi0, rho0 ] = solitonIC(N, 0, -wavelengthFactor*S, wavelengthFactor, epsilon, beta, gamma, 0);
            
        else
            
            [ phi0, rho0 ] = solitonIC(N, 1, 1, wavelengthFactor, epsilon, beta, gamma, 0);
            
        end
        
    end
    
end
