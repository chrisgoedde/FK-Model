function [ pathFormats, pathValues, runNumber ] = parseArguments(varargin)
% [ f0, bathTemp, tf, eta, runNumber, methodName, folderName, pathName ] = parseArguments(varargin)
% Parse the variable argument list for FKModel.m and other functions.
% Any arguments not specified are given the default values below.
% Arguments should have the form: 'Constant', value.
% Values are written out to file FKDefaults-hostname.mat
% Possible arguments and variables are
% 'N0' -> sets N0, the number of carbon rings
% 'S' -> sets S, where N = N0 + S is the number of water molecules
% 'Type' -> sets type, the type of nanotube
% 'Forcing' -> sets f0
% 'Temperature' -> sets bathTemp
% 'Duration' -> sets tf
% 'Damping' -> sets eta
% 'Spring' -> sets springFactor
% 'Spacing' -> sets spacingFactor
% 'Integration Method' -> sets methodName
% 'Save Folder' -> sets folderName
% 'Run' -> sets runNumber
% 'Geometry' -> set geometry to 'ring' or 'chain'
% 'Push' -> set nPush
% 'Push Force' -> set fPush
% 'Push Start' -> set t0Push
% 'Push End' -> set tfPush
% 'Pull' -> set nPull
% 'Pull Force' -> set fPull
% 'Pull Start' -> set t0Pull
% 'Pull End' -> set tfPull
% '2D Spring' -> set transverse spring constant for 2D FK model

runNumber = 1; % default run number for reading in data
Gamma = 1; % default 2D quadratic spring constant

load(FKDefaults)

fprintf('Parsing %d arguments.\n', length(varargin)/2)

for i = 1:length(varargin)/2
    
    theString = varargin{2*i-1};
    theValue = varargin{2*i};
    
    switch theString
        
        case 'N0'
            
            N0 = theValue;
            
        case 'Type'
            
            theType = theValue;
            
        case 'S'
            
            S = theValue;
            
        case 'Temperature'
            
            bathTemp = theValue;
            
        case 'Forcing'
            
            f0 = theValue;
            
        case 'Damping'
            
            eta = theValue;

        case 'Spring'
            
            springFactor = theValue;
            
        case 'Spacing'
            
            spacingFactor = theValue;

        case 'Duration'
            
            tf = theValue;
            
        case 'Integration Method'
            
            methodName = theValue;
            
        case 'Save Folder'
            
            folderName = theValue;
            
        case 'Run'
            
            runNumber = theValue;
            fprintf('Setting runNumber to %d\n', runNumber);
            
        case 'Geometry'
            
            geometry = theValue;
            
        case '2D Spring'
            
            Gamma = theValue;
            
        case 'Push'
            
            nPush = theValue;
            
        case 'Push Force'
            
            fPush = theValue;
            
        case 'Push Start'
            
            t0Push = theValue/1000;
            
        case 'Push End'
            
            tfPush = theValue/1000;
            
        case 'Pull'
            
            nPull = theValue;
            
        case 'Pull Force'
            
            fPull = theValue;
            
        case 'Pull Start'
            
            t0Pull = theValue/1000;
            
        case 'Pull End'
            
            tfPull = theValue/1000;
            
        otherwise
            
            fprintf('No valid parameter ''%s''.\n', theString);
            
    end
    
end

if ~strcmp(geometry, 'ring')
    
    S = 0;
    
end

if nPush == 0
    
    fPush = 0;
    t0Push = 0;
    tfPush = 0;
    
end

if nPull == 0
    
    fPull = 0;
    t0Pull = 0;
    tfPull = 0;
    
end

% Save the last set of values to the default file.

save(FKDefaults, 'N0', 'S', 'theType', 'f0', 'bathTemp', 'tf', ...
    'eta', 'springFactor', 'spacingFactor', ...
    'methodName', 'geometry', 'folderName', ...
    'nPush', 'fPush', 't0Push', 'tfPush', ...
    'nPull', 'fPull', 't0Pull', 'tfPull');

% Make a cell array for the path for reading/writing the data.

if nPush + nPull == 0
    
    pathFormats = { '%s', 'type = %d', 'N0 = %d', 'eta = %.2e Hz', ...
        'T = %d K', 'S = %d', 'f = %.2e pN', 'spring = %.2e', 'spacing = %.2e', ...
        'tf = %.2e ns', 'method = %s' };
    
    pathValues = { folderName, theType, N0, eta, bathTemp, S, f0, springFactor, ...
        spacingFactor, tf, methodName };
    
else
   
    pathFormats = { '%s', 'type = %d', 'N0 = %d', 'eta = %.2e Hz', ...
        'T = %d K', 'S = %d', 'push = (%d, %.2e pN, %.3f ns, %.3f ns)', ...
        'pull = (%d, %.2e pN, %.3f ns, %.3f ns)', 'spring = %.2e', 'spacing = %.2e', ...
        'tf = %.2e ns', 'method = %s' };
    
    pathValues = { folderName, theType, N0, eta, bathTemp, S, ...
        [ nPush, fPush, t0Push, tfPush ], [ nPull, fPull, t0Pull, tfPull ], springFactor, ...
        spacingFactor, tf, methodName };

end

if strcmp(methodName, '2D')
    
    pathFormats = [ pathFormats, 'Gamma = %.2d' ];
    pathValues = [ pathValues, Gamma ];
    
end

showFKDefaults
disp([ 'Run Number = ' num2str(runNumber, '%d') ])

end