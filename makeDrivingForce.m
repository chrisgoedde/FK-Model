function externalForce = makeDrivingForce(tau, phi)
    
    [ eV, ePushV, tau0Push, taufPush, ePullV, tau0Pull, taufPull, ...
        phiTug, taufTug, gammaTug, startTug ] = initDrivingForce();
    
    numTimes = length(tau);
    N = length(eV);
    
    eV = repmat(eV, [ 1 numTimes ]);
    
    eVTug = zeros(N, numTimes);
    
    if taufTug ~= 0
        
        endPoint = [ startTug + phiTug*tau/taufTug; startTug + phiTug*ones(size(tau)) ];
        endPoint = min(endPoint);
        
    else
        
        endPoint = startTug + phiTug*ones(size(tau));
        
    end
    
    eVTug(N, :) = -gammaTug * (phi(N, :) - endPoint);
    
    tauMatrix = repmat(tau, [ N 1 ]);
    
    ePushV = repmat(ePushV, [ 1 numTimes ]);
    ePushV = ePushV .* (tauMatrix >= tau0Push) .* (tauMatrix <= taufPush);
    ePullV = repmat(ePullV, [ 1 numTimes ]);
    ePullV = ePullV .* (tauMatrix >= tau0Pull) .* (tauMatrix <= taufPull);
    
    externalForce = eV + ePushV + ePullV + eVTug;
    
end
