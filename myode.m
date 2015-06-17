function [ tf, yf ] = myode(df, t0, y0, ~)

dt0 = 0.01;

tf = zeros(length(t0), 1);
yf = zeros(length(t0), length(y0));

tf(1) = t0(1);
yf(1, :) = y0';

for n = 2:length(t0)
    
    nSteps = ceil((t0(n)-t0(n-1))/dt0);
    
    dt = (t0(n)-t0(n-1))/nSteps;
    
    for m = 1:nSteps
        
        [ ~, y0 ] = rk4step(df, t0(n-1) + (m-1)*dt, y0, dt);
        
    end
    
    tf(n) = t0(n);
    yf(n, :) = y0';
    
end

    function [ t, y ] = rk4step(df, t0, y0, dt)
        
        k1 = dt * df(t0, y0);
        k2 = dt * df(t0 + dt/2, y0 + k1/2);
        k3 = dt * df(t0 + dt/2, y0 + k2/2);
        k4 = dt * df(t0 + dt, y0 + k3);
        
        y = y0 + (k1 + 2*k2 + 2*k3 + k4)/6;
        t = t0 + dt;
        
    end

end

