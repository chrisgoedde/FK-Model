function [ sFLeft, sFRight ] = makeSpringForce(phi)
    
    [ alphaVector, gammaVector, fixedE ] = initSprings(false);
    
    [ N, nT ] = size(phi);
    alphaVector = repmat(alphaVector, [ 1 nT ]);
    gammaVector = repmat(gammaVector, [ 1 nT ]);
    
    if isempty(fixedE)
        
        stretch = phi - circshift(phi, 1) - alphaVector;
        sFLeft = -gammaVector .* stretch;
        sFRight = circshift(gammaVector, -1) .* circshift(stretch, -1);
    
    else
        
        sFLeft = -gammaVector .* (phi - [ fixedE(1) * ones(1, nT) ; phi(1:N-1, :) ] - alphaVector);
        sFRight = gammaVector .* ([ phi(2:N, :) ; fixedE(2) * ones(1, nT) ] - phi - alphaVector);
        
    end
    
end
