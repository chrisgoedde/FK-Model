function setPhysicalDefaults(type, g, f, tf, eta, T)
    
    if type == 4
        
        V0 = 2.432e-21;
        lambda = 0.1228e-9;
        m = 2.992e-26;
        a = 0.28e-9;
        kB = 1.38e-23;
        
        t0 = lambda*sqrt(2*m/V0)/(2*pi);
        p0 = sqrt(m*V0/2);
        g0 = 2*pi^2*V0/lambda^2;
        
        tauf = round(tf/t0, -3);
        gamma = g/g0;
        alpha = a/lambda;
        beta = t0*eta;
        epsilon = t0*f/p0;
        Theta = kB*T/(V0/2);
        
        setFKDefaults('Duration', tauf, 'Spring', gamma, 'Spacing', alpha, ...
            'Damping', beta, 'Forcing', epsilon, 'Temperature', Theta);
                
    end