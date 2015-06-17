function theTitle = makePlotTitle(alpha, gamma, runNumber)

geometry = [];

load(FKDefaults, 'N0', 'eta', 'bathTemp', 'S', 'geometry')

if strcmp(geometry, 'chain')
    
    titleLine = { sprintf('Free-end chain, N0 = %d, spacing = a, Run %d', ...
        N0, runNumber) };
    
elseif strcmp(geometry, 'flat')
    
    titleLine = { sprintf('Free-end chain, N0 = %d, spacing = lambda, Run %d', ...
        N0, runNumber) };
    
elseif strcmp(geometry(1), 's')
    
    titleLine = { sprintf('Free-end chain, N0 = %d, solitions = %d, Run %d', ...
        N0, str2double(geometry(2:end)), runNumber) };
    
else
    
    titleLine = { sprintf('Periodic chain, N0 = %d, S = %d, Run %d', ...
        N0, S, runNumber) };
    
end

titleLine  = [ titleLine sprintf('T = %.0f K, damping = %.0e', ...
    bathTemp, eta) ];

titleLine = [ titleLine sprintf('a/lambda = %.2f, gamma = %.2f', ...
    alpha(end)/(2*pi), gamma(end)) ];

% titleLine = [ titleLine [ 'a/\lambda = ' num2str(alpha(end)/(2*pi), '%.2f') ...
%     ', \gamma = ' num2str(gamma(end), '%.2f') ] ];

theTitle = titleLine{1};

for i = 2:length(titleLine)
    
    % theTitle = sprintf('%s\n%s', theTitle, titleLine{i});
    
    theTitle = [ theTitle sprintf('\n') titleLine{i} ]; %#ok<AGROW>
    
end

end
