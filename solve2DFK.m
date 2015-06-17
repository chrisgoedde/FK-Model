function [ t, phif, rhof, phiSum, rhoSum ] = solve2DFK(tf, nTime, nOut, phi0, rho0, delta, gamma, alpha, epsilon, beta, betaPrime, Omega, fluctuation, Gamma, method)

y0 = [ phi0; rho0; zeros(size(phi0)); fluctuation*randn(size(rho0)) ];
N = length(phi0);

t = linspace(0, tf, nTime+1);

nStep = nTime/nOut;

z0 = y0;
y = zeros(nOut+1, 4*N);
ySum = zeros(nOut+1, 4*N);
y(1, :) = y0;
ySum(1, :) = y0;

for i = 1:nOut;
    
    zSum = zeros(4*N, 1);
    
    for j = 1:nStep
        
        z0 = z0 + Omega*[ zeros(N,1) ; zeros(N,1) ; zeros(N,1) ; randn(N,1) ];
        
        timeIndex = (i-1)*nStep + j;
        [ ~, z ] = method(@FK2D, [ t(timeIndex) t(timeIndex+1) ], z0);
        z0 = z(end, :)';
        zSum = zSum + z0;
        
    end
    
    y(i+1, :) = z(end, :);
    ySum(i+1, :) = zSum/nStep;
    if mod((i+1), round(nOut/10)) == 0
        
        fprintf('%d%% completed.\n', round(i*100.0/nOut))
        
    end
    
end

t = t(1:nStep:nTime+1);

phif = y(:, 1:N)';
rhof = y(:, N+1:2*N)';

phiSum = ySum(:, 1:N)';
rhoSum = ySum(:, N+1:2*N)';

    function dy = FK2D(~, y0)
        
        phi = y0(1:N);
        rho = y0(N+1:2*N);
        X = y0(2*N+1:3*N);
        PX = y0(3*N+1:4*N);
        
        stretch = phi - circshift(phi, 1) - alpha;
        dPX = betaPrime*0.25*((1-sign(PX-circshift(PX, 1))).*abs(PX-circshift(PX, 1)) ...
            + (1-sign(PX-circshift(PX, -1))).*abs(PX-circshift(PX, -1)));
        
        dphi = rho.*delta;
        dX = PX.*delta;
        
        a = -gamma.*stretch;
        b = circshift(gamma, -1).*circshift(stretch, -1);
        c = epsilon - 0.5*sin(phi).*(1+cos(X));
        dPX = -beta*(PX+sign(PX).*dPX) - Gamma*X + 0.5*sin(X).*(1-cos(phi));
        
        drho = a + b + c;
        
        dy = [ dphi ; drho ; dX; dPX ];
        
    end

end
