function FKModel(varargin)
% FKModel(...)
% All the arguments are parsed in the function parseArguments

tStart = tic;

geometry = [];
  
% Initialize the input parameters.

[ pathFormats, pathValues, runNumber ] = parseArguments(varargin{:});

load(FKDefaults, 'N0', 'S', 'epsilon', 'Theta', 'tauf', ...
    'beta', 'gamma', 'alpha', ...
    'methodName', 'geometry', 'folderName', ...
    'nPush', 'epsilonPush', 'tau0Push', 'taufPush', ...
    'nPull', 'epsilonPull', 'tau0Pull', 'taufPull', 'M', 'Lambda', 'Psi', ...
    'dTug', 'taufTug', 'gammaTug')

if tau0Pull > taufPull
    
    disp('Pull end time must be later than pull start time.')
    return
    
end

if tau0Push > taufPush
    
    disp('Push end time must be later than push start time.')
    return
    
end

% Time step information

N = N0+S;
dtau = 0.1; % Step size for the thermal noise
nTime = round(tauf/dtau);

if nTime < 1000
    
    nTime = 1000;
    dtau = tf/nTime;
    nOut = nTime;
    
else

    nOut = trimOutput(nTime);

end

muVector = ones(N, 1); % vector of dimensionless molecule masses

alphaVector = alpha * ones(N, 1); % vector of dimensionless water spacing
wavelengthFactor = round(alpha/(2*pi));
sMin = substrateMinima(N, M, Lambda);

% Create the vector of spring constants ... if the geometry is a chain
% rather than a ring, make the first spring constant zero ... this is the
% spring constant that lies to the left of the first mass, connecting it to
% the last mass in the ring geometry.

if strcmp(geometry, 'chain') || strcmp(geometry(1), 's') || strcmp(geometry(1), 'e') 

    gammaVector = gamma * [ 0 ; ones(N-1, 1) ];

else
    
    gammaVector = gamma * ones(N, 1);
    
end

alphaVector(1) = alphaVector(1) - (sMin(end) + 2*pi * Lambda);

deltaVector = 1./muVector;

epsilonVector = epsilon*ones(N, 1);

epsilonPushVector = epsilonPush*[ ones(nPush, 1); zeros(N-nPush, 1) ];
epsilonPullVector = epsilonPull*[ zeros(N-nPull, 1) ; ones(nPull, 1) ];

phiTug = Lambda*2*pi*dTug;
startTug = sMin(end); % + 2*pi*Lambda;

Omega = sqrt(4*beta*Theta*dtau);

% Calculate the initial condition

if strcmp(geometry, 'chain')
    
    phi0 = alpha * (0:(N-1))';
    rho0 = zeros(N, 1);
    
elseif strcmp(geometry(1), 's')
    
    stretch = str2double(geometry(2:end));
    if stretch ~= 0 || M == 0
        
        [ phi0, rho0 ] = solitonIC(N, 0, stretch, wavelengthFactor, epsilon, beta, gamma, 0);
        
    else
        
        phi0 = wavelengthFactor * substrateMinima(N, M, Lambda);
        rho0 = zeros(N, 1);
        
    end

elseif strcmp(geometry(1), 'e')
    
    stretch = str2double(geometry(2:end)); 
    if stretch ~= 0 || M == 0
        
        [ phi0, rho0 ] = solitonIC(N, 0, stretch, wavelengthFactor, epsilon, beta, gamma, 0);
        
    else
        
        phi0 = wavelengthFactor * substrateMinima(N, M, Lambda);
        rho0 = zeros(N, 1);
        
    end
    
    fprintf('Equilibrating initial condition ...\n')
    
    initDrivingForce(0*epsilonVector, 0*epsilonPushVector, tau0Push, taufPush, ...
        0*epsilonPullVector, tau0Pull, taufPull, 0, taufTug, gammaTug, startTug);
    initSubstrateForce(M, Lambda, Psi);
    
    [ ~, phi, rho, ~, ~ ] = solveFK(500, 500, 500, phi0, rho0, ...
        deltaVector, gammaVector, alphaVector, 0.01, Omega, @ode45);
    
    phi0 = phi(:, end);
    rho0 = rho(:, end);

    fprintf('Completed initial condition.\n')
    
else
    
    if S > 0
        
        [ phi0, rho0 ] = solitonIC(N, 2*S, 0, wavelengthFactor, epsilon, beta, gamma, 0);
        
    elseif S < 0
        
        [ phi0, rho0 ] = solitonIC(N, 0, -2*S, wavelengthFactor, epsilon, beta, gamma, 0);
        
    else
        
        [ phi0, rho0 ] = solitonIC(N, 1, 1, wavelengthFactor, epsilon, beta, gamma, 0);
        
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
    
    initDrivingForce(epsilonVector, epsilonPushVector, tau0Push, taufPush, ...
        epsilonPullVector, tau0Pull, taufPull, phiTug, taufTug, gammaTug, startTug);
    initSubstrateForce(M, Lambda, Psi);
    
    [ tau, phi, rho, phiAvg, rhoAvg ] = solveFK(tauf, nTime, nOut, phi0, ...
        rho0, deltaVector, gammaVector, alphaVector, beta, Omega, method);
    
else
    
    disp('2D model not currently implemented')
    return
    
%     Gamma = 1;
%     
%     [ tau, phi, rho, phiAvg, rhoAvg ] = solve2DFK(tauf, nTime, nOut, phi0, ...
%         rho0, delta, gamma, alpha, epsilon, epsilonPush, tau0Push, taufPush, ...
%         epsilonPull, tau0Pull, taufPull, beta, etaPrime, Omega, ...
%         sqrt(mAvg*kB*bathTemp)/p0, Gamma, @ode45);
    
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
