function [ stretch, offset, KE, PE, power, springForceLeft, springForceRight, dampingForce, drivingForce, potentialForce ] = processChain(phi, rho, wavelengthFactor, alpha, delta, gamma, beta, epsilon)

[ N, numTimes ] = size(phi);

alpha = repmat(alpha, [ 1 numTimes ]);
stretch = (phi - circshift(phi, 1) - alpha);

theIndex = repmat(2*pi*wavelengthFactor*(0:(N-1))', [ 1 numTimes ]);
offset = (phi - theIndex);

delta = repmat(delta, [ 1 numTimes ]);
KE = sum(delta.*(rho.^2)/2);

gamma = repmat(gamma, [ 1 numTimes ]);
epsilon = repmat(epsilon, [ 1 numTimes ]);
springForceLeft = -gamma.*stretch;
springForceRight = circshift(-springForceLeft, [ -1 0 ]);
springForce = springForceLeft + springForceRight;
dampingForce = -beta*rho;
drivingForce = epsilon;
potentialForce = -sin(phi);

power = rho.*delta.*(springForce + dampingForce + drivingForce + potentialForce);

PE = sum(0.5 * (springForceLeft.*stretch + springForceRight.*circshift(stretch, [ -1 0 ])) + 1 - cos(phi));

end