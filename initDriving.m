function [ eVOut, ePushVOut, tau0PushOut, taufPushOut, ePullVOut, ...
        tau0PullOut, taufPullOut, phiTugOut, tfTugOut, gammaTugOut, startTugOut ] = initDriving(initFlag)
    
    persistent eV ePushV t0Push tfPush ePullV t0Pull tfPull ...
        phiTug tfTug gTug startTug
    
    if initFlag
        
        load(FKDefaults, 'epsilon', 'nPush', 'epsilonPush', 'tau0Push', 'taufPush', ...
            'nPull', 'epsilonPull', 'tau0Pull', 'taufPull', ...
            'dTug', 'taufTug', 'gammaTug', ...
            'geometry', 'N0', 'S', 'M', 'Lambda')
        
        N = N0 + S;
        
        if ~strcmp(geometry, 'ring')
            
            sMin = substrateMinima(N, M, Lambda);
            startTug = sMin(end);
            
        else
            
            startTug = 0;
            
        end
        
        eV = epsilon*ones(N, 1);
        ePushV = epsilonPush*[ ones(nPush, 1); zeros(N-nPush, 1) ];
        ePullV = epsilonPull*[ zeros(N-nPull, 1) ; ones(nPull, 1) ];
        
        t0Push = tau0Push;
        tfPush = taufPush;
        t0Pull = tau0Pull;
        tfPull = taufPull;
        phiTug = Lambda*2*pi*dTug;
        tfTug = taufTug;
        gTug = gammaTug;
        
    end
    
    eVOut = eV;
    ePushVOut = ePushV;
    tau0PushOut = t0Push;
    taufPushOut = tfPush;
    ePullVOut = ePullV;
    tau0PullOut = t0Pull;
    taufPullOut = tfPull;
    phiTugOut = phiTug;
    tfTugOut = tfTug;
    gammaTugOut = gTug;
    startTugOut = startTug;
    
end
