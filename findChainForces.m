function [ springForceLeft, springForceRight, dampingForce, drivingForce, substrateForce ] = findChainForces(tau, phi, rho, alpha, gamma, beta)

[ ~, numTimes ] = size(phi);

alpha = repmat(alpha, [ 1 numTimes ]);
stretch = (phi - circshift(phi, 1) - alpha);

gamma = repmat(gamma, [ 1 numTimes ]);

springForceLeft = -gamma.*stretch;
springForceRight = circshift(-springForceLeft, [ -1 0 ]);
dampingForce = -beta*rho;
drivingForce = makeDrivingForce(tau);
substrateForce = makeSubstrateForce(phi);

end
