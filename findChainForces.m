function [ springForceLeft, springForceRight, dampingForce, drivingForce, substrateForce ] = findChainForces(tau, phi, rho)
    
    initSprings(true);
    initSubstrate(true);
    initDriving(true);
    
    load(FKDefaults, 'beta')
        
    [ springForceLeft, springForceRight ] = makeSpringForce(phi);
    dampingForce = -beta*rho;
    drivingForce = makeDrivingForce(tau, phi, true);
    substrateForce = makeSubstrateForce(phi);
    
end
