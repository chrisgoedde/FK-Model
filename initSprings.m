function [ aVOut, gVOut ] = initSprings(initFlag)
    
    persistent alphaVector gammaVector
    
    if initFlag
        
        load(FKDefaults, 'N0', 'S', 'geometry', 'alpha', 'gamma')
        
        N = N0 + S;
        
        alphaVector = alpha * ones(N, 1); % vector of dimensionless water spacing
        
        % Create the vector of spring constants ... if the geometry is a chain
        % rather than a ring, make the first spring constant zero ... this is the
        % spring constant that lies to the left of the first mass, connecting it to
        % the last mass in the ring geometry.
        
        if ~strcmp(geometry, 'ring')
            
            gammaVector = gamma * [ 0 ; ones(N-1, 1) ];
            alphaVector(1) = 0;
            
        else
            
            gammaVector = gamma * ones(N, 1);
            alphaVector(1) = alphaVector(1) - 2*pi * N0;
            
        end
        
    end
    
    aVOut = alphaVector;
    gVOut = gammaVector;
    
end
