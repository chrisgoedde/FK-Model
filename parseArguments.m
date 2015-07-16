function [ pathFormats, pathValues, runNumber ] = parseArguments(varargin)
% [ pathFormats, pathValues, runNumber ] = parseArguments(varargin)
% Parse the variable argument list for FKModel.m and other functions.
% Any arguments not specified are given the default values read in from
% the local FKDefaults file.
% Arguments should have the form: 'Constant', value.
% Values are written out to file FKDefaults-hostname.mat
% Possible arguments and variables are
% 'N0' -> sets N0, the number of carbon rings
% 'S' -> sets S, where N = N0 + S is the number of water molecules
% 'Mass' -> sets dimensionless mass, mu
% 'Forcing' -> sets dimensionless forcing, epsilon
% 'Temperature' -> sets dimensionless temperature, Theta
% 'Duration' -> sets dimensionless duration, tauf
% 'Damping' -> sets dimensonless damping, beta
% 'Spring' -> sets dimensionless spring constant, gamma
% 'Spacing' -> sets dimensionless spring length, alpha
% 'Integration Method' -> sets methodName
% 'Save Folder' -> sets folderName
% 'Save Type' -> sets folderType
% 'Run' -> sets runNumber
% 'Geometry' -> set geometry to 'ring' or 'chain'
% 'Push' -> set nPush
% 'Push Force' -> set epsilonPush
% 'Push Start' -> set tau0Push
% 'Push End' -> set taufPush
% 'Pull' -> set nPull
% 'Pull Force' -> set epsilonPull
% 'Pull Start' -> set tau0Pull
% 'Pull End' -> set taufPull
% 'Substrate Divide' -> set M
% 'Substrate Wavelength' -> set Lambda
% 'Substrate Potential' -> set Psi
% 'Tug Distance' -> sets dTug to pulling distance, in substrate wavelengths
% 'Tug End' -> set taufTug to pulling duration
% 'Tug Spring' -> set strength of tugging spring, gammaTug
% '2D Spring' -> set transverse spring constant for 2D FK model

runNumber = 1; % default run number for reading in data

load(FKDefaults)

plural = { 's', '' };
fprintf('Parsing %d argument%s.\n', length(varargin)/2, plural{(length(varargin)/2 == 1) + 1})

for i = 1:length(varargin)/2
    
    theString = varargin{2*i-1};
    theValue = varargin{2*i};
    
    switch theString
        
        case 'N0'
            
            N0 = theValue;
            
        case 'S'
            
            S = theValue;
            
        case 'Mass'
            
            mu = theValue;
            
        case 'Temperature'
            
            Theta = theValue;
            
        case 'Forcing'
            
            epsilon = theValue;
            
        case 'Damping'
            
            beta = theValue;
            
        case 'Spring'
            
            gamma = theValue;
            
        case 'Spacing'
            
            alpha = 2*pi * theValue;
            
        case 'Duration'
            
            tauf = theValue;
            
        case 'Integration Method'
            
            methodName = theValue;
            
        case 'Save Folder'
            
            folderName = theValue;
            
        case 'Save Type'
            
            folderType = theValue;
            
        case 'Run'
            
            runNumber = theValue;
            
        case 'Geometry'
            
            geometry = theValue;
            
%         case '2D Spring'
%             
%             gamma2D = theValue;
            
        case 'Push'
            
            nPush = theValue;
            
        case 'Push Force'
            
            epsionPush = theValue;
            
        case 'Push Start'
            
            tau0Push = theValue;
            
        case 'Push End'
            
            taufPush = theValue;
            
        case 'Pull'
            
            nPull = theValue;
            
        case 'Pull Force'
            
            epsilonPull = theValue;
            
        case 'Pull Start'
            
            tau0Pull = theValue;
            
        case 'Pull End'
            
            taufPull = theValue;
            
        case 'Substrate Divide'
            
            M = theValue;
            
        case 'Substrate Wavelength'
            
            Lambda = theValue;
            
        case 'Substrate Potential'
            
            Psi = theValue;
            
        case 'Tug Distance'
            
            dTug = theValue;
            
        case 'Tug End'
            
            taufTug = theValue;
            
%         case 'Tug Spring'
%             
%             gammaTug = theValue;
            
        otherwise
            
            fprintf('No valid parameter ''%s''.\n', theString);
            
    end
    
end

% If we are not using a periodic tube, we set S to zero, so that N = N0.
% If we are using a periodic tube, we must have a uniform substrate, and we
% don't push or pull the (nonexistent) ends of the chain.

if ~strcmp(geometry, 'ring')
    
    S = 0;
    
else
    
    M = 0;
    Lambda = 1;
    Psi = 1;
    dTug = 0;
    nPull = 0;
    nPush = 0;
    
end

% If we're not tugging on the end of the chain, set the duration and spring
% force for the tug equal to zero. If we are tugging on the chain, set the
% external push/pull to zero, and set the tugging spring constant to equal
% the chain spring constant.

if dTug == 0
    
    taufTug = 0;
    gammaTug = 0;
    
else
    
    nPull = 0;
    nPush = 0;
    gammaTug = gamma;
    
end

% If we're not pushing on the left end of the chain, make sure the other
% pushing parameters are zero. Likewise, if the pushing force is zero, make
% sure the other pushing parameters are zero.

if nPush == 0
    
    epsionPush = 0;
    tau0Push = 0;
    taufPush = 0;
    
elseif epsionPush == 0
    
    nPush = 0;
    tau0Push = 0;
    taufPush = 0;
    
end

% If we're not pulling on the right end of the chain, make sure the other
% pulling parameters are zero. Likewise, if the pulling force is zero, make
% sure the other pulling parameters are zero.

if nPull == 0
    
    epsilonPull = 0;
    tau0Pull = 0;
    taufPull = 0;
    
elseif epsilonPull == 0
    
    nPull = 0;
    tau0Pull = 0;
    taufPull = 0;
    
end

% If the chain is uniform, make sure all the parameters are consistent.

if M == 0
    
    Lambda = 1;
    Psi = 1;
    
elseif Lambda == 1 && Psi == 1
    
    M = 0;
    
end

% Save the last set of values to a hostname-specific default file.

save(FKDefaults, 'N0', 'S', 'epsilon', 'mu', 'Theta', 'tauf', ...
    'beta', 'gamma', 'alpha', ...
    'methodName', 'geometry', 'folderName', 'folderType', ...
    'nPush', 'epsilonPush', 'tau0Push', 'taufPush', ...
    'nPull', 'epsilonPull', 'tau0Pull', 'taufPull', 'M', 'Lambda', 'Psi', ...
    'dTug', 'taufTug', 'gammaTug');

% Make a cell array for the path for reading/writing the data.

if strcmp(geometry, 'ring')
    
    BC = 'ring';
    
else
    
    BC = 'finite';
    
end

pathFormats = { '%s', '%s', '%s', 'N0 = %d', 'S = %d', 'mu = %.1f', 'Theta = %.2f', ...
    'beta = %.2e', 'substrate = (%d, %.2f, %.2f)', 'spring = (%.1f, %.3f)', ...
    'epsilon = %.2e' 'push = (%d, %.1f, %.1f, %.1f)', ...
    'pull = (%d, %.1f, %.1f, %.1f)', 'tug = (%.2f, %.1f, %.1f)', ...
    'tauf = %.1f', 'method = %s' };
pathValues = { folderName, folderType, BC, N0, S, mu, Theta, beta, [ M, Lambda, Psi ], ...
    [ gamma, alpha/(2*pi) ], epsilon, [ nPush, epsionPush, tau0Push, taufPush ], ...
    [ nPull, epsilonPull, tau0Pull, taufPull ] [ dTug, taufTug, gammaTug ], ...
    tauf, methodName };

% if strcmp(methodName, '2D')
%     
%     pathFormats = [ pathFormats, 'gamma2D = %.2f' ];
%     pathValues = [ pathValues, gamma2D ];
%     
% end

showFKDefaults
disp([ 'Run Number = ' num2str(runNumber, '%d') ])

end