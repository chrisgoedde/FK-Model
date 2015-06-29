function [ KE, PE ] = findChainEnergy(phi, rho, alpha, delta, gamma)

[ ~, numTimes ] = size(phi);

alpha = repmat(alpha, [ 1 numTimes ]);
stretch = (phi - circshift(phi, 1) - alpha);

delta = repmat(delta, [ 1 numTimes ]);
KE = sum(delta.*(rho.^2)/2);

gamma = repmat(gamma, [ 1 numTimes ]);

springForceLeft = -gamma.*stretch;
springForceRight = circshift(-springForceLeft, [ -1 0 ]);

PE = sum(0.5 * (springForceLeft.*stretch + springForceRight.*circshift(stretch, [ -1 0 ])) + 1 - cos(phi));

end
