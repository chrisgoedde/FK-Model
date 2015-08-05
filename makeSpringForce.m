function [ sFLeft, sFRight ] = makeSpringForce(phi)
    
    [ alphaVector, gammaVector ] = initSprings(false);
    
    [ ~, nT ] = size(phi);
    alphaVector = repmat(alphaVector, [ 1 nT ]);
    gammaVector = repmat(gammaVector, [ 1 nT ]);
    
    stretch = phi - circshift(phi, 1) - alphaVector;
    sFLeft = -gammaVector.*stretch;
    sFRight = circshift(gammaVector, -1).*circshift(stretch, -1);
    
end
