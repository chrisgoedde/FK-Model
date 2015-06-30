function [ stretch, offset ] = findChainPosition(phi, wavelengthFactor, M, Lambda, alpha)

[ N, numTimes ] = size(phi);

alpha = repmat(alpha, [ 1 numTimes ]);
stretch = (phi - circshift(phi, 1) - alpha);

theIndex = repmat(wavelengthFactor * channelMinima(N, M, Lambda), [ 1 numTimes ]);
offset = (phi - theIndex);

end
