function [ stretch, offset ] = findChainPosition(phi, wavelengthFactor, M, Lambda, alphaVector)

[ N, numTimes ] = size(phi);

alphaVector = repmat(alphaVector, [ 1 numTimes ]);
stretch = (phi - circshift(phi, 1) - alphaVector);

theIndex = repmat(wavelengthFactor * substrateMinima(N, M, Lambda), [ 1 numTimes ]);
offset = (phi - theIndex);

end
