function [ aVOut, gVOut, fEOut ] = initSprings(initFlag)
    
    persistent alphaVector gammaVector fE
    
    if initFlag
        
        load(FKDefaults, 'N0', 'S', 'geometry', 'alpha', 'gamma', 'wF', 'fixedEnds')
        
        N = N0 + S;
        
        alphaVector = alpha * ones(N, 1); % vector of dimensionless water spacing
        
        % Create the vector of spring constants ... if the geometry is a
        % chain with free ends rather than a ring or a chain with fixed
        % ends, make the first spring constant zero ... this is the spring
        % constant that lies to the left of the first mass, connecting it
        % to the last mass in the ring geometry.
        
        if strcmp(geometry, 'ring')
            
            gammaVector = gamma * ones(N, 1);
            alphaVector(1) = alphaVector(1) - 2*pi * wF * N0;
            fE = [ [] [] ];
            
        elseif strcmp(geometry, 'fixed')
            
            gammaVector = gamma * ones(N, 1);
            fE = fixedEnds;
            
        else
            
            gammaVector = gamma * [ 0 ; ones(N-1, 1) ];
            alphaVector(1) = 0;
            fE = [ [] [] ];
            
        end
        
    end
    
    aVOut = alphaVector;
    gVOut = gammaVector;
    fEOut = fE;
    
end
