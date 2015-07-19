function [ u, v ] = solitonIC(N, numKinks, numAntikinks, wF, epsilon0, beta, gamma, fluctuation)
    % ringIC(N0, S, type, eta)
    % The input parameters are:
    % N0: the number of carbon rings in the nanotube
    % S: the excess or deficit of water molecules compared to N0
    % type: the CNT type (n, n)
    
    epsilonMax = 3*(beta/4)*sqrt(mean(gamma)-64/pi^2);
    epsilon0 = min(epsilon0, epsilonMax);
    
    kinkSpacing = N/(numKinks+numAntikinks);
    kinkType = [ ones(1, numKinks) -ones(1, numAntikinks) ];
    
    u = zeros(N, 1);
    v = zeros(N, 1);
    
    moleculeIndex = (0:N-1)';
    
    if epsilon0 ~= 0
        kinkSpeed = 1/sqrt(1+(4*beta/(pi*epsilon0)).^2);
    else
        kinkSpeed = 0;
    end
    
    width = 1/sqrt(1-kinkSpeed^2);
    
    for k = 1:(numKinks+numAntikinks)
        
        x = (moleculeIndex - (2*k-1)*kinkSpacing/2)/sqrt(mean(gamma));
        
        u = u + 4*atan(exp(-kinkType(k)*width*x));
        v = v + 2*kinkSpeed*width./cosh(-kinkType(k)*width*x);
        
    end
    
    % u = u - 2*pi*(S+abs(S));
    v = v + fluctuation*randn(size(v));
    
    % v = v + sqrt(kB*bathTemp/mAvg)*randn(size(v))*mAvg/p0;
    
    % figure
    % plot(moleculeIndex, u, 'o')
    % set(gca, 'fontsize', 18)
    % xlabel('molecule index')
    % ylabel('offset')
    % title(sprintf('slope = %.2e, pi/(Delta x) = %.2e', 2*width, pi*sqrt(mean(gamma))))
    
    % figure
    % plot(moleculeIndex, v, 'o')
    
    u = u + 2*pi*wF * (0:(N-1))';
    u = u - 2*pi * numKinks;
    
end
