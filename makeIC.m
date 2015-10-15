function [ phi0, rho0 ] = makeIC(N, geometry)
    
    load(FKDefaults, 'alpha', 'gamma', 'M', 'Lambda', 'epsilon', 'beta', 'wF', 'S')

    if strcmp(geometry, 'chain')
        
        phi0 = alpha * (0:(N-1))';
        rho0 = zeros(N, 1);
        
    elseif strcmp(geometry(1), 's')
        
        stretch = str2double(geometry(2:end));
        if stretch ~= 0 || M == 0
            
            if stretch < 0
            
                [ phi0, rho0 ] = solitonIC(N, abs(stretch), 0, wF, epsilon, beta, gamma, 0);
                
            else
                
                [ phi0, rho0 ] = solitonIC(N, 0, stretch, wF, epsilon, beta, gamma, 0);
                
            end
     
        else
            
            phi0 = wF * substrateMinima(N, M, Lambda);
            rho0 = zeros(N, 1);
            
        end
        
    elseif strcmp(geometry(1), 'e')
        
        stretch = str2double(geometry(2:end));
        if stretch ~= 0 || M == 0
            
            if stretch < 0
            
                [ phi0, rho0 ] = solitonIC(N, abs(stretch), 0, wF, epsilon, beta, gamma, 0);
                
            else
                
                [ phi0, rho0 ] = solitonIC(N, 0, stretch, wF, epsilon, beta, gamma, 0);
                
            end
            
        else
            
            phi0 = wF * substrateMinima(N, M, Lambda);
            rho0 = zeros(N, 1);
            
        end
        
        fprintf('Equilibrating initial condition ...\n')
        
        [ ~, phi, rho ] = solveFK(500, 1, 100, phi0, rho0, 0.01, false, @ode45, false);
        
        phi0 = phi(:, end);
        rho0 = rho(:, end);
        
        fprintf('Completed initial condition.\n')
        
    else
        
        if S > 0
            
            [ phi0, rho0 ] = solitonIC(N, wF*S, 0, wF, epsilon, beta, gamma, 0);
            
        elseif S < 0
            
            [ phi0, rho0 ] = solitonIC(N, 0, -wF*S, wF, epsilon, beta, gamma, 0);
            
        else
            
            [ phi0, rho0 ] = solitonIC(N, 1, 1, wF, epsilon, beta, gamma, 0);
            
        end
        
    end
    
end
