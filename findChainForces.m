function [ springForceLeft, springForceRight, dampingForce, drivingForce, substrateForce ] = findChainForces(tau, phi, rho, alphaVector, gammaVector, beta)

[ ~, numTimes ] = size(phi);

alphaVector = repmat(alphaVector, [ 1 numTimes ]);
stretch = (phi - circshift(phi, 1) - alphaVector);

gammaVector = repmat(gammaVector, [ 1 numTimes ]);

springForceLeft = -gammaVector.*stretch;
springForceRight = circshift(-springForceLeft, [ -1 0 ]);
dampingForce = -beta*rho;
drivingForce = makeDrivingForce(tau, phi);
substrateForce = makeSubstrateForce(phi);

end
