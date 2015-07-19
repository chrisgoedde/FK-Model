function [ stretch, offset ] = findChainPosition(phi, wF)
    
    [ alphaVector, ~ ] = initSprings(true);
    [ M, Lambda, ~ ] = initSubstrate(true);
    
    [ N, numTimes ] = size(phi);
    
    alphaVector = repmat(alphaVector, [ 1 numTimes ]);
    stretch = (phi - circshift(phi, 1) - alphaVector);
    
    theIndex = repmat(wF * substrateMinima(N, M, Lambda), [ 1 numTimes ]);
    offset = (phi - theIndex);
    
end
