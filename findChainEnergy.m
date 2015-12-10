function [ KE, PE ] = findChainEnergy(phi, rho)
    
    [ N, numTimes ] = size(phi);
    
    [ alphaVector, gammaVector, fixedE ] = initSprings(true);
    
    muVector = ones(N, 1);
    deltaVector = 1./muVector;
    
    alphaVector = repmat(alphaVector, [ 1 numTimes ]);
    
    deltaVector = repmat(deltaVector, [ 1 numTimes ]);
    KE = sum(deltaVector.*(rho.^2)/2);
    
    gammaVector = repmat(gammaVector, [ 1 numTimes ]);
    
    if isempty(fixedE)
        
        stretch = (phi - circshift(phi, 1) - alphaVector);
        springForceLeft = -gammaVector.*stretch;
        springPotential = sum(0.5 * (-springForceLeft.*stretch));
        
    else
        
        stretch = phi(2:end, :) - phi(1:end-1, :) - alphaVector(1:end-1, :);
        springPotential = sum(0.5 * gammaVector(1:end-1, :).*stretch.^2);
        
    end
        
    [ M, Lambda, Psi ] = initSubstrate(true);
    substratePotential = sum((1-cos(phi)) .* (phi <= 2*pi*M) ...
        + Psi*(1-cos((phi-2*pi*M)/Lambda)) .* (phi > 2*pi*M));
    
    PE = springPotential + substratePotential;
    
end
