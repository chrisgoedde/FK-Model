function name = FKDefaults %#ok<*NASGU> 

[ ~, systemName ] = system('hostname');
systemName = strtok(systemName, '.');

name = sprintf('FKDefaults-%s.mat', systemName);

if ~exist(name, 'file')
    
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

    save(name, 'N0', 'theType', 'S', 'f0', 'bathTemp', 'tf', 'eta', ...
        'springFactor', 'spacingFactor', 'methodName', 'folderName', ...
        'geometry', 'nPush', 'fPush', 't0Push', 'tfPush', ...
        'nPull', 'fPull', 't0Pull', 'tfPull')

end

end
