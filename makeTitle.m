function theTitle = makeTitle(runNumber)

geometry = [];
alpha = [];
beta = [];
gamma = [];

load(FKDefaults, 'N0', 'S', 'alpha', 'beta', 'gamma', 'Theta', 'geometry', ...
    'nPull', 'epsilonPull', 'tau0Pull', 'taufPull', ...
    'nPush', 'epsilonPush', 'tau0Push', 'taufPush', 'M', 'Lambda', 'Psi')

if strcmp(geometry, 'chain')
    
    titleLine = { sprintf('Free-end chain, N0 = %d, spacing = a, Run %d', ...
        N0, runNumber) };
    
elseif strcmp(geometry(1), 's')
    
    titleLine = { sprintf('Free-end chain, N0 = %d, %d soliton IC (unequilibrated), Run %d', ...
        N0, str2double(geometry(2:end)), runNumber) };
    
elseif strcmp(geometry(1), 'e')
    
    titleLine = { sprintf('Free-end chain, N0 = %d, %d soliton IC (equilibrated), Run %d', ...
        N0, str2double(geometry(2:end)), runNumber) };
    
else
    
    titleLine = { sprintf('Periodic chain, N0 = %d, S = %d, Run %d', ...
        N0, S, runNumber) };
    
end

titleLine  = [ titleLine [ ' \Theta = ' num2str(Theta, '%.2f') ', \beta = ' ...
    num2str(beta, ' %.2e')  ', a/\lambda = ' num2str(alpha/(2*pi), '%.2f') ...
    ', \gamma = ' num2str(gamma, '%.2f') ] ];

if nPull == 1
    
    titleLine = [ titleLine [ 'Pulled 1 molecule with f = ' num2str(epsilonPull, '%.3f') ...
        sprintf(') over [%.1f, %.1f]', tau0Pull, taufPull) ] ];

elseif nPull > 1
    
    titleLine = [ titleLine [ sprintf('Pulled %d molecules with f = ', nPull) ...
        num2str(epsilonPull, '%.3f') ...
        sprintf(') over [%.1f, %.1f]', tau0Pull, taufPull) ] ];
    
end

if nPush == 1
    
    titleLine = [ titleLine [ 'Pushed 1 molecule with f = ' num2str(epsilonPush, '%.3f') ...
        sprintf(') over [%.1f, %.1f]', tau0Push, taufPush) ] ];

elseif nPush > 1
    
    titleLine = [ titleLine [ sprintf('Pushed %d molecules with f = ', nPush) ...
        num2str(epsilonPush, '%.3f') ...
        sprintf(') over [%.1f, %.1f]', tau0Push, taufPush) ] ];
    
end


if M ~= 0
    
    titleLine = [ titleLine [ 'Substrate break after ' num2str(M, '%d') ' wavelengths, ' ...
        '\lambda_R/\lambda_L = ' num2str(Lambda, '%.2f') ...
        ', V_R/V_L = ' num2str(Psi, '%.2f') ] ];

end

theTitle = titleLine{1};

for i = 2:length(titleLine)
    
    theTitle = [ theTitle sprintf('\n') titleLine{i} ]; %#ok<AGROW>
    
end

end
