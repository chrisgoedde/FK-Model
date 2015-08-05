function makeEquilibria(aRange, varargin)
    % FKModel(...)
    % First parameter specifies a range of a/lambda
    % All the other arguments are parsed in the function parseArguments
    
    tStart = tic;
    
    for a = aRange
        
        % Initialize the input parameters. This returns the formats and values
        % necessary to read/write the output files, and an integer run number
        % to distinguish different simulation runs. It writes all the other
        % parameters to the local FKDefaults file for use by this and other
        % functions. Since we're about to do a simulatin, we force the 'Save
        % Type' to be 'Data'.
        
        [ pathFormats, pathValues, runNumber ] = parseArguments(varargin{:}, ...
            'Save Type', 'Data', 'Spacing', a, 'Temperature', 0, 'Duration', 0);
        
        load(FKDefaults, 'N0', 'wF')
        
        S = round(N0*a-N0);
        
        while true
            
            fprintf('Looking for equilibrium with %d soliton(s).\n', S);
            geometry = sprintf('e%d', S);
            
            [ phi, rho ] = makeIC(N0, geometry);
            
            [ ~, offset] = findChainPosition(phi, wF);
            [ numS, ~ ] = findSolitons(offset, wF);
            
            fprintf('Found equilibrium with %d soliton(s) for spacing = %.3f\n', numS, a);

            if numS ~= S
                
                break;
                
            end
            
            tau = zeros(size(phi));
            
            writePathName = makePath(pathFormats, pathValues, []);
            
            saveDynamics(writePathName, geometry, runNumber, tau, phi, rho);
            
            S = S + 1;
            
        end
        
        S = round(N0*a-N0)-1;
        
        while true
            
            fprintf('Looking for equilibrium with %d soliton(s).\n', S);
            
            geometry = sprintf('e%d', S);
            
            [ phi, rho ] = makeIC(N0, geometry);
            
            [ ~, offset] = findChainPosition(phi, wF);
            [ numS, ~ ] = findSolitons(offset, wF);
            
            fprintf('Found equilibrium with %d soliton(s) for spacing = %.3f\n', numS, a);

            if numS ~= S
                
                break;
                
            end
            
            tau = zeros(size(phi));
            
            writePathName = makePath(pathFormats, pathValues, []);
            
            saveDynamics(writePathName, geometry, runNumber, tau, phi, rho);
            
            S = S - 1;
            
        end
        
    end
    
    elapsed = toc(tStart)/60;
    
    if elapsed > 3
        fprintf('Elapsed time: %d minutes.\n', round(elapsed))
    elseif elapsed > 1
        fprintf('Elapsed time: %.1f minutes.\n', round(elapsed, 1))
    else
        fprintf('Elapsed time: %d seconds.\n', round(elapsed*60))
    end
    
end
