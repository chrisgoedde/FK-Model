function name = FKDefaults %#ok<*NASGU>

% Create the name for the hostname-specific defaults file. This name will
% be returned by the function.

[ ~, systemName ] = system('hostname');
systemName = strtok(systemName, '.');

name = sprintf('FKDefaults-%s.mat', systemName);

% Check to see if hostname-specific defaults file exists. If it doesn't,
% we'll have to create it.

if ~exist(name, 'file')
    
    % If the hostname-specific defaults file doesn't exist, create it,
    % either from a generic defaults file or by using the hardcoded values
    % below.
    
    if exist('FKDefaults.mat', 'file')
        
        copyfile('FKDefaults.mat', name)
        
    else
        
        N0 = 100; % default number of carbon rings
        S = 0; % default to molecule/ring mismatch
        mu = 1; % default dimensionless mass of particles
        epsilon = 0; % default dimensionless external forcing
        Theta = 0; % default dimensionless temperature
        tauf = 1000; % default integration time, in ns
        beta = 3e-3; % default dimensionless damping
        gamma = 15; % default dimensionless spring constant
        alpha = 2*pi; % default dimensionless spring rest length
        methodName = 'ode45'; % default method of integration
        folderName = 'Results'; % default save folder for data
        geometry = 'ring'; % default geometry (alternate: 'chain')
        nPush = 0; % default number of molecules on left to be pushed
        epsilonPush = 0; % default dimensionless pushing force
        tau0Push = 0; % default dimensionless start time for pushing
        taufPush = 0; % default dimensionless end time for pushing
        
        nPull = 0; % default number of molecules on right to be pulled
        epsilonPull = 0; % default dimensionless pulling force
        tau0Pull = 0; % default dimensionless start time for pulling
        taufPull = 0; % default dimensionless end time for pulling
        
        M = 0; % default divide in substrate
        Lambda = 1; % default wavelength ratio in substrate
        Psi = 1; % default potential height ratio in substrate
        
        dTug = 0; % default distance to pull right end (in substrate wavelengths)
        taufTug = 0; % default duration of tugging
        gammaTug = 15; % default strength of tugging, relative to springs
        
        save(name, 'N0', 'S', 'epsilon', 'mu', 'Theta', 'tauf', ...
            'beta', 'gamma', 'alpha', ...
            'methodName', 'geometry', 'folderName', ...
            'nPush', 'epsilonPush', 'tau0Push', 'taufPush', ...
            'nPull', 'epsilonPull', 'tau0Pull', 'taufPull', 'M', 'Lambda', 'Psi', ...
            'dTug', 'taufTug', 'gammaTug');

    end
    
end

end
