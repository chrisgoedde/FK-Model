function theTitle = makeTitle(alpha, beta, gamma, epsilon0Pull, epsilon0Push, runNumber)

geometry = [];

load(FKDefaults, 'N0', 'bathTemp', 'S', 'geometry', ...
    'nPull', 'fPull', 't0Pull', 'tfPull', 'nPush', 'fPush', 't0Push', 'tfPush')

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

titleLine  = [ titleLine [ 'T = ' num2str(bathTemp, '%.0f') ' K, \beta = ' ...
    num2str(beta, ' %.2e')  ', a/\lambda = ' num2str(alpha(end)/(2*pi), '%.3f') ...
    ', \gamma = ' num2str(gamma(end), '%.2f') ] ];

if nPull == 1
    
    titleLine = [ titleLine [ 'Pulled 1 molecule with f = ' num2str(fPull, '%d') ...
        ' pN (\epsilon = ' num2str(epsilon0Pull, '%.2f') ...
        sprintf(') over [%.1f, %.1f] ps', t0Pull*1000, tfPull*1000) ] ];

elseif nPull > 1
    
    titleLine = [ titleLine [ sprintf('Pulled %d molecules with f = ', nPull) ...
        num2str(fPull, '%d') ' pN (\epsilon = ' num2str(epsilon0Pull, '%.2f') ...
        sprintf(') over [%.1f, %.1f] ps', t0Pull*1000, tfPull*1000) ] ];
    
end

if nPush == 1
    
    titleLine = [ titleLine [ 'Pushed 1 molecule with f = ' num2str(fPush, '%d') ...
        ' pN (\epsilon = ' num2str(epsilon0Push, '%.2f') ...
        sprintf(') over [%.1f, %.1f] ps', t0Push*1000, tfPush*1000) ] ];
    
elseif nPush > 1
    
    titleLine = [ titleLine [ sprintf('Pushed %d molecules with f = ', nPush) ...
        num2str(fPush, '%d') ' pN (\epsilon = ' num2str(epsilon0Push, '%.2f') ...
        sprintf(') over [%.1f, %.1f] ps', t0Push*1000, tfPush*1000) ] ];
    
end

theTitle = titleLine{1};

for i = 2:length(titleLine)
    
    theTitle = [ theTitle sprintf('\n') titleLine{i} ]; %#ok<AGROW>
    
end

end
