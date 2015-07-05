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
        theType = 4; % default to (4, 4) nanotube
        S = -1; % default to one fewer water molecule
        f0 = 1e-2; % default external forcing, in pN
        bathTemp = 20; % default temperature, in K
        tf = 10; % default integration time, in ns
        eta = 3e9; % default damping, in Hz
        springFactor = 1; % modification of water spring constant
        spacingFactor = 1; % modificaiton of water spacing constant
        methodName = 'ode45'; % default method of integration
        folderName = 'Results'; % default save folder for data
        geometry = 'ring'; % default geometry (alternate: 'chain')
        nPush = 0; % default number of molecules on left to be pushed
        fPush = 0; % default pushing force, in pN
        t0Push = 0; % default start time for pushing, in ps
        tfPush = 0; % default end time for pushing, in ps
        
        nPull = 0; % default number of molecules on right to be pulled
        fPull = 0; % default pulling force, in pN
        t0Pull = 0; % default start time for pulling, in ps
        tfPull = 0; % default end time for pulling, in ps
        
        M = 0; % default divide in substrate
        Lambda = 1; % default wavelength ratio in substrate
        Psi = 1; % default potential height ratio in substrate
        
        dTug = 0; % default distance to pull right end (in substrate wavelengths)
        tfTug = 0; % default duration of tugging
        strengthTug = 1; % default strength of tugging, relative to springs
        
        save(name, 'N0', 'theType', 'S', 'f0', 'bathTemp', 'tf', 'eta', ...
            'springFactor', 'spacingFactor', 'methodName', 'folderName', ...
            'geometry', 'nPush', 'fPush', 't0Push', 'tfPush', ...
            'nPull', 'fPull', 't0Pull', 'tfPull', 'M', 'Lambda', 'Psi', ...
            'dTug', 'tfTug', 'strengthTug')
        
    end
    
end

end
