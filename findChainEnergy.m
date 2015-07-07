function [ KE, PE ] = findChainEnergy(phi, rho, alphaVector, deltaVector, gammaVector)

[ ~, numTimes ] = size(phi);

alphaVector = repmat(alphaVector, [ 1 numTimes ]);
stretch = (phi - circshift(phi, 1) - alphaVector);

deltaVector = repmat(deltaVector, [ 1 numTimes ]);
KE = sum(deltaVector.*(rho.^2)/2);

gammaVector = repmat(gammaVector, [ 1 numTimes ]);

springForceLeft = -gammaVector.*stretch;
springForceRight = circshift(-springForceLeft, [ -1 0 ]);

[ M, Lambda, Psi ] = initSubstrateForce;
substratePotential = (1-cos(phi)) .* (phi <= 2*pi*M) ...
    + Psi*(1-cos((phi-2*pi*M)/Lambda)) .* (phi > 2*pi*M);

PE = sum(0.5 * (springForceLeft.*stretch + springForceRight.*circshift(stretch, [ -1 0 ])) + substratePotential);

end
