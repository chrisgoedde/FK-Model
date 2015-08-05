function [ KE, PE ] = findChainEnergy(phi, rho)
    
    [ N, numTimes ] = size(phi);
    
    [ alphaVector, gammaVector ] = initSprings(true);
    
    muVector = ones(N, 1);
    deltaVector = 1./muVector;
    
    alphaVector = repmat(alphaVector, [ 1 numTimes ]);
    stretch = (phi - circshift(phi, 1) - alphaVector);
    
    deltaVector = repmat(deltaVector, [ 1 numTimes ]);
    KE = sum(deltaVector.*(rho.^2)/2);
    
    gammaVector = repmat(gammaVector, [ 1 numTimes ]);
    
    springForceLeft = -gammaVector.*stretch;
    springPotential = sum(0.5 * (-springForceLeft.*stretch));
        
    [ M, Lambda, Psi ] = initSubstrate(true);
    substratePotential = sum((1-cos(phi)) .* (phi <= 2*pi*M) ...
        + Psi*(1-cos((phi-2*pi*M)/Lambda)) .* (phi > 2*pi*M));
    
    PE = springPotential + substratePotential;
    
end
