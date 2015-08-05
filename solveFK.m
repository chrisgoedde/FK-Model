function [ t, phif, rhof ] = solveFK(tauf, dtau, minOut, phi0, rho0, beta, drivingFlag, method, dispFlag)
    
    load(FKDefaults, 'Theta');
    
    if isempty(beta)
        
        load(FKDefaults, 'beta');
        
    end
    
    y0 = [ phi0; rho0 ];
    N = length(phi0);
    
    nTime = round(tauf/dtau);
    
    if nTime < minOut
        
        nTime = minOut;
        dtau = tauf/nTime;
        nOut = nTime;
        
    else
        
        nOut = trimOutput(nTime);
        
    end
    
    muVector = ones(N, 1);
    deltaVector = 1./muVector;

    Omega = sqrt(2*beta*muVector*Theta*dtau);
    
    initSprings(true);
    initSubstrate(true);
    initDriving(true);
    
    UL = zeros(N);
    UR = diag(ones(1,N));
    LL = diag(ones(1,N)) + diag(ones(1,N-1), 1) + diag(ones(1,N-1), -1);
    LL(1, end) = 1;
    LL(end, 1) = 1;
    LR = diag(ones(1,N));
    pattern = [ [ UL, UR ] ; [ LL, LR ] ];
    
    options = odeset('JPattern', pattern);
    
    t = linspace(0, tauf, nTime+1);
    
    nStep = nTime/nOut;
    
    z0 = y0;
    y = zeros(nOut+1, 2*N);
    y(1, :) = y0;
    
    tic
    
    for i = 1:nOut;
        
        for j = 1:nStep
            
            z0 = z0 + [ Omega ; Omega ] .* [ zeros(N,1) ; randn(N,1) ];
            
            timeIndex = (i-1)*nStep + j;
            [ ~, z ] = method(@FK, [ t(timeIndex) t(timeIndex+1) ], z0, options);
            z0 = z(end, :)';
            
        end
        
        y(i+1, :) = z(end, :);
        if mod((i+1), round(nOut/10)) == 0 && dispFlag
            
            elapsed = toc/60;
            percent = round(i*100.0/nOut);
            remaining = elapsed*(100-percent)/percent;
            if percent < 100
                
                if remaining > 3
                    fprintf('%d%% completed. Estimate completion in %d minutes.\n', percent, round(remaining))
                elseif remaining > 1
                    fprintf('%d%% completed. Estimate completion in %.1f minutes.\n', percent, round(remaining, 1))
                else
                    fprintf('%d%% completed. Estimate completion in %d seconds.\n', percent, round(remaining*60))
                end
                
            end
            
        end
        
    end
    
    t = t(1:nStep:nTime+1);
    
    phif = y(:, 1:N)';
    rhof = y(:, N+1:2*N)';
    
    function dy = FK(tau, y0)
        
        phi = y0(1:N);
        rho = y0(N+1:2*N);
        
        dphi = rho.*deltaVector;
        
        [ a, b ] = makeSpringForce(phi);
        
        c = -beta*rho;
        
        d = makeDrivingForce(tau, phi, drivingFlag);
        
        e = makeSubstrateForce(phi);
        
        drho = a + b + c + d + e;
        
        dy = [ dphi ; drho ];
        
    end
    
    function nOut = trimOutput(nTime)
        
        nOut = nTime;
        
        while nOut > 1000
            
            factor = nTime/1000;
            
            if round(factor) == factor
                
                nOut = nTime/factor;
                
            else
                
                if nOut < 2000
                    
                    nOut = nOut/2;
                    
                elseif nOut < 5000
                    
                    nOut = nOut/5;
                    
                else
                    
                    nOut = nOut/10;
                    
                end
                
            end
            
        end
        
    end
    
end
