function [ stretch, offset ] = findChainPosition(phi, wavelengthFactor, alpha)

[ N, numTimes ] = size(phi);

alpha = repmat(alpha, [ 1 numTimes ]);
stretch = (phi - circshift(phi, 1) - alpha);

theIndex = repmat(2*pi*wavelengthFactor*(0:(N-1))', [ 1 numTimes ]);
offset = (phi - theIndex);

end
