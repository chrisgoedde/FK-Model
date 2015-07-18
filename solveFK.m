function [ t, phif, rhof, phiSum, rhoSum ] ...
        = solveFK(tf, nTime, nOut, phi0, rho0, beta, Omega, method)
    
    y0 = [ phi0; rho0 ];
    N = length(phi0);
    
    muVector = ones(N, 1);
    deltaVector = 1./muVector;
    
    initSpringForce(true);
    initSubstrateForce(true);
    initDrivingForce(true);
    
    UL = zeros(N);
    UR = diag(ones(1,N));
    LL = diag(ones(1,N)) + diag(ones(1,N-1), 1) + diag(ones(1,N-1), -1);
    LL(1, end) = 1;
    LL(end, 1) = 1;
    LR = diag(ones(1,N));
    pattern = [ [ UL, UR ] ; [ LL, LR ] ];
    
    options = odeset('JPattern', pattern);
    
    t = linspace(0, tf, nTime+1);
    
    nStep = nTime/nOut;
    
    z0 = y0;
    y = zeros(nOut+1, 2*N);
    ySum = zeros(nOut+1, 2*N);
    y(1, :) = y0;
    ySum(1, :) = y0;
    
    tic
    
    for i = 1:nOut;
        
        zSum = zeros(2*N, 1);
        
        for j = 1:nStep
            
            z0 = z0 + Omega*[ zeros(N,1) ; randn(N,1) ];
            
            timeIndex = (i-1)*nStep + j;
            [ ~, z ] = method(@FK, [ t(timeIndex) t(timeIndex+1) ], z0, options);
            z0 = z(end, :)';
            zSum = zSum + z0;
            
        end
        
        y(i+1, :) = z(end, :);
        ySum(i+1, :) = zSum/nStep;
        if mod((i+1), round(nOut/10)) == 0
            
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
    
    phiSum = ySum(:, 1:N)';
    rhoSum = ySum(:, N+1:2*N)';
    
    function dy = FK(tau, y0)
        
        phi = y0(1:N);
        rho = y0(N+1:2*N);
        
        dphi = rho.*deltaVector;
        
        [ a, b ] = makeSpringForce(phi);
        
        c = -beta*rho;
        
        d = makeDrivingForce(tau, phi);
        
        e = makeSubstrateForce(phi);
        
        drho = a + b + c + d + e;
        
        dy = [ dphi ; drho ];
        
    end
    
end
