function FKSolitonActivation(varargin)
    % FKSolitonActivation(...)
    % All the arguments are parsed in the function parseArguments
    % This fuction tries to calculate the activation energy of a soliton.
    
    tStart = tic;
    
    % Initialize the input parameters. This returns the formats and values
    % necessary to read/write the output files, and an integer run number
    % to distinguish different simulation runs. It writes all the other
    % parameters to the local FKDefaults file for use by this and other
    % functions. Since we're about to do a simulation, we force the 'Save
    % Type' to be 'Data'.
    %
    % We also always start with 'geometry' equal to 'e0', so that we start
    % with a relaxed, no-soliton state.
    
    [ ~, ~, ~ ] = parseArguments(varargin{:}, 'Save Type', 'Data', ...
        'Geometry', 'e0', 'Save Folder', 'Activation', 'Duration', 500, ...
        'Damping', 0.01);
    
    load(FKDefaults, 'N0', 'S', 'tauf', 'methodName', 'geometry')
    
    % set the step size for the thermal noise. This might be changed by
    % solveFK to ensure that the output is written at enough different
    % times during the simulation.
    
    dtau = 1; 
    
    % Calculate the initial condition.
    
    [ phi0, ~ ] = makeIC(N0 + S, geometry);
    
    phi(:, 1) = phi0;
    phiRight = phi0(end);
    
    numPoints = 20;
    
    for i = 1:numPoints
    
        % Now switch over to fixed boundary conditions, using the ends of the
        % relaxed chain as the fixed ends. Drop the last particle on each end.
        
        fE = [ phi0(1) phiRight + 2*pi*i/numPoints ];
        phi0 = phi0(2:end-1);
        rho0 = zeros(size(phi0));
        
        [ ~, ~, ~ ] = parseArguments('N0', N0-2, 'Geometry', 'fixed', 'Fixed Ends', fE);
        
        load(FKDefaults, 'N0', 'geometry')
        
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
            
            % solveFK takes the final time and time step (dimensionless), the
            % minimum number of output times, the initial position and velocity
            % of the molecules, the damping ([] means to read the damping from
            % the FKDefaults file), a flag to determine whether the driving
            % force is on or off, and the integration method. The last argument
            % is a flag that specifies whether progress should be written to
            % the command line.
            
            [ tau, phi0, ~ ] = solveFK(tauf, dtau, 100, phi0, rho0, [], true, method, true);
            
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
        
        % Return N0 to its initial value, and fill in the ends of phi and rho.
        
        [ pathFormats, pathValues, runNumber ] = parseArguments('N0', N0+2);
        load(FKDefaults, 'N0', 'geometry')
       
        phi0 = [ fE(1) ; phi0(:, end) ; fE(2) ];
        
        phi(:, i+1) = phi0;
    
    end
    
    rho = zeros(size(phi));
        
    writePathName = makePath(pathFormats, pathValues, []);
    
    saveDynamics(writePathName, geometry, runNumber, tau, phi, rho);
    
    % clear tau rho phi rho0 phi0 ans method varargin runNumber
    
    % save(sprintf('%s/%sConstants', writePathName, geometry))
    
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
