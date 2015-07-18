function FKModel(varargin)
    % FKModel(...)
    % All the arguments are parsed in the function parseArguments
    
    tStart = tic;
    
    % geometry = [];
    
    % Initialize the input parameters.
    
    [ pathFormats, pathValues, runNumber ] = parseArguments(varargin{:});
    
    load(FKDefaults, 'N0', 'S', 'Theta', 'tauf', 'beta', 'methodName', 'geometry')
    
    % Time step information
    
    N = N0+S;
    dtau = 0.1; % Step size for the thermal noise
    nTime = round(tauf/dtau);
    
    if nTime < 1000
        
        nTime = 1000;
        dtau = tauf/nTime;
        nOut = nTime;
        
    else
        
        nOut = trimOutput(nTime);
        
    end
    
    Omega = sqrt(4*beta*Theta*dtau);
    
    % Calculate the initial condition
    
    [ phi0, rho0 ] = makeIC(N, geometry, beta, Omega);
    
    % Annoyingly, while the initial conditions must be column vectors, ode45
    % makes the output variables row vectors (with time being the column
    % vector), so we'll transpose the output for consistency. As a result, the
    % molecule's index is the first element of phi, rho, stretch, and energy,
    % while the time index is the second element.
    
    if ~strcmp(methodName, '2D')
        
        if strcmp(methodName, 'ode23s')
            
            method = @ode23s;
            
        elseif strcmp(methodName, 'ode45')
            
            method = @ode45;
            
        elseif strcmp(methodName, 'myode')
            
            method = @myode;
            
        else
            
            fprintf('%s is not a valid method name\n', methodName);
            return
            
        end
        
        [ tau, phi, rho, phiAvg, rhoAvg ] = solveFK(tauf, nTime, nOut, phi0, ...
            rho0, beta, Omega, method);
        
    else
        
        disp('2D model not currently implemented')
        return
        
        %     Gamma = 1;
        %
        %     [ tau, phi, rho, phiAvg, rhoAvg ] = solve2DFK(tauf, nTime, nOut, phi0, ...
        %         rho0, delta, gamma, alpha, epsilon, epsilonPush, tau0Push, taufPush, ...
        %         epsilonPull, tau0Pull, taufPull, beta, etaPrime, Omega, ...
        %         sqrt(mAvg*kB*bathTemp)/p0, Gamma, @ode45);
        
    end
    
    writePathName = makePath(pathFormats, pathValues, []);
    
    saveDynamics(writePathName, geometry, runNumber, tau, phi, rho, phiAvg, rhoAvg);
    
    clear tau rho phi rhoAvg phiAvg rho0 phi0 ans method varargin runNumber
    
    save(sprintf('%s/%sConstants', writePathName, geometry))
    
    elapsed = toc(tStart)/60;
    
    if elapsed > 3
        fprintf('Elapsed time using %s: %d minutes.\n', methodName, round(elapsed))
    elseif elapsed > 1
        fprintf('Elapsed time using %s: %.1f minutes.\n', methodName, round(elapsed, 1))
    else
        fprintf('Elapsed time using %s: %d seconds.\n', methodName, round(elapsed*60))
    end
    
    % beep
    
end
