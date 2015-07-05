function FKModel(varargin)
% FKModel(...)
% All the arguments are parsed in the function parseArguments

tStart = tic;

geometry = [];
  
% Initialize the input parameters.

[ pathFormats, pathValues, runNumber ] = parseArguments(varargin{:});

load(FKDefaults)

if t0Pull > tfPull
    
    disp('Pull end time must be later than pull start time.')
    return
    
end

if t0Push > tfPush
    
    disp('Push end time must be later than push start time.')
    return
    
end

% etaPrime was the nonlinear damping parameter which is no longer used.
etaPrime = 0;

% Time step information

N = N0+S;
dt = 1e-4; % Step size for the thermal noise, in ns.
nTime = round(tf/dt);

if nTime < 1000
    
    nTime = 1000;
    dt = tf/nTime;
    nOut = nTime;
    
else

    nOut = trimOutput(nTime);

end

dt = dt*1e-9; % Convert step size to ns.

% Initialize the physical constants

if theType == 4 || theType == 5 || theType == 6
    
    [ V0, c, l, lambda, mWater, aWater, kB ] = setPhysicalConstants(theType);
    
else
    
    disp('Nanotube type must be 4, 5, or 6.')
    return

end

m = mWater*ones(N, 1); % vector of molecule masses
mAvg = mean(m); % average mass

a = aWater*ones(N, 1); % vector of water spacing, in m

L = N0*l; % length of nanotube

% Create the vector of spring constants ... if the geometry is a chain
% rather than a ring, make the first spring constant zero ... this is the
% spring constant that lies to the left of the first mass, connecting it to
% the last mass in the ring geometry.

if strcmp(geometry, 'chain') || strcmp(geometry(1), 's') || strcmp(geometry(1), 'e') 

    g = mAvg*(c/aWater)^2*[ 0 ; ones(N-1, 1) ];

else
    
    g = mAvg*(c/aWater)^2*ones(N, 1);
    
end

t0 = (lambda/(2*pi))*sqrt(2*mAvg/V0); % time normalization
p0 = sqrt(mAvg*V0/2); % momentum normalization
g0 = 2*pi^2*V0/lambda^2; % spring normalization

noise = sqrt(2*eta*mAvg*kB*bathTemp/dt); % the noise coefficient

% Nondimensional constants.

tauf = (tf*1e-9)/t0;
dtau = dt/t0;

mu = m/mAvg;
delta = 1./mu;
gamma = springFactor*g/g0;

alpha = (2*pi/lambda)*a;
alpha(1) = alpha(1) - (2*pi*L/lambda);
alpha = spacingFactor*alpha;

epsilon0 = t0*(f0*1e-12)/p0;
epsilon = epsilon0*ones(N, 1);

epsilon0Push = t0*(fPush*1e-12)/p0;
epsilonPush = epsilon0Push*[ ones(nPush, 1); zeros(N-nPush, 1) ];
epsilon0Pull = t0*(fPull*1e-12)/p0;
epsilonPull = epsilon0Pull*[ zeros(N-nPull, 1) ; ones(nPull, 1) ];

tau0Push = (t0Push*1e-9)/t0;
taufPush = (tfPush*1e-9)/t0;
tau0Pull = (t0Pull*1e-9)/t0;
taufPull = (tfPull*1e-9)/t0;

phiTug = Lambda*2*pi*dTug;
taufTug = (tfTug*1e-9)/t0;
gammaTug = strengthTug * springFactor*g(end)/g0;
chainEnd = channelMinima(N, M, Lambda);
startTug = chainEnd(end); % + 2*pi*Lambda;

beta = t0*eta;
Omega = t0*dtau*noise/p0;

% Calculate the initial condition

if strcmp(geometry, 'ring')
    
    wavelengthFactor = 2;
    
else
    
    wavelengthFactor = 1;
    
end

if strcmp(geometry, 'chain')
    
    phi0 = spacingFactor * (2*pi/lambda) * a .* (0:(N-1))';
    rho0 = zeros(N, 1);
    
elseif strcmp(geometry(1), 's')
    
    stretch = str2double(geometry(2:end));
    if stretch ~= 0 || M == 0
        
        [ phi0, rho0 ] = solitonIC(N, 0, stretch, wavelengthFactor, epsilon0, beta, gamma, 0);
        
    else
        
        phi0 = wavelengthFactor * channelMinima(N, M, Lambda);
        rho0 = zeros(N, 1);
        
    end

elseif strcmp(geometry(1), 'e')
    
    stretch = str2double(geometry(2:end)); 
    if stretch ~= 0 || M == 0
        
        [ phi0, rho0 ] = solitonIC(N, 0, stretch, wavelengthFactor, epsilon0, beta, gamma, 0);
        
    else
        
        phi0 = wavelengthFactor * channelMinima(N, M, Lambda);
        rho0 = zeros(N, 1);
        
    end
    
    fprintf('Equilibrating initial condition ...\n')
    
    initDrivingForce(0*epsilon, 0*epsilonPush, tau0Push, taufPush, ...
        0*epsilonPull, tau0Pull, taufPull, 0, taufTug, gammaTug, startTug);
    initSubstrateForce(M, Lambda, Psi);
    
    [ ~, phi, rho, ~, ~ ] = solveFK((0.05*1e-9)/t0, round(0.05/1e-4), ...
        trimOutput(round(0.05/1e-4)), phi0, ...
        rho0, delta, gamma, alpha, t0*3e11, etaPrime, Omega, @ode45);
    
    phi0 = phi(:, end);
    rho0 = rho(:, end);

    fprintf('Completed initial condition.\n')
    
else
    
    if S > 0
        
        [ phi0, rho0 ] = solitonIC(N, 2*S, 0, wavelengthFactor, epsilon0, beta, gamma, 0);
        
    elseif S < 0
        
        [ phi0, rho0 ] = solitonIC(N, 0, -2*S, wavelengthFactor, epsilon0, beta, gamma, 0);
        
    else
        
        [ phi0, rho0 ] = solitonIC(N, 1, 1, wavelengthFactor, epsilon0, beta, gamma, 0);
        
    end
    
end

% Annoyingly, while the initial conditions must be column vectors, ode45
% makes the output variables row vectors (with time being the column
% vector), so we'll transpose the output for consistency. As a result, the
% molecule's index is the first element of phi, rho, stretch, and energy,
% while the time index is the second element.

if ~strcmp(methodName, '2D')
    
    if strcmp(methodName, 'ode23s')
        
        method = @ode23s;
        
    elseif strcmp(methodName, 'ode45')
        
        method = @ode45;
        
    elseif strcmp(methodName, 'myode')
        
        method = @myode;
        
    else
        
        fprintf('%s is not a valid method name\n', methodName);
        return
        
    end
    
    initDrivingForce(epsilon, epsilonPush, tau0Push, taufPush, ...
        epsilonPull, tau0Pull, taufPull, phiTug, taufTug, gammaTug, startTug);
    initSubstrateForce(M, Lambda, Psi);
    
    [ tau, phi, rho, phiAvg, rhoAvg ] = solveFK(tauf, nTime, nOut, phi0, ...
        rho0, delta, gamma, alpha, beta, etaPrime, Omega, method);
    
else
    
    Gamma = 1;
    
    [ tau, phi, rho, phiAvg, rhoAvg ] = solve2DFK(tauf, nTime, nOut, phi0, ...
        rho0, delta, gamma, alpha, epsilon, epsilonPush, tau0Push, taufPush, ...
        epsilonPull, tau0Pull, taufPull, beta, etaPrime, Omega, ...
        sqrt(mAvg*kB*bathTemp)/p0, Gamma, @ode45);
    
end

writePathName = makePath(pathFormats, pathValues, []);

saveDynamics(writePathName, geometry, runNumber, tau, phi, rho, phiAvg, rhoAvg);

clear tau rho phi rhoAvg phiAvg rho0 phi0 ans method varargin runNumber

save(sprintf('%s/%sConstants', writePathName, geometry))

elapsed = toc(tStart)/60;

if elapsed > 3
    fprintf('Elapsed time using %s: %d minutes.\n', methodName, round(elapsed))
elseif elapsed > 1
    fprintf('Elapsed time using %s: %.1f minutes.\n', methodName, round(elapsed, 1))
else
    fprintf('Elapsed time using %s: %d seconds.\n', methodName, round(elapsed*60))
end

% beep

end
