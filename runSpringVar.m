function runSpringVar(tempVec, springVec, spacingVec, varargin)

% save 'lastRunRing.mat' N0 SVec type forceVec tempVec varargin

for l = 1:length(springVec)
    
    fprintf('Starting springFactor = %.2e.\n', springVec(l));
        
    for i = 1:length(spacingVec)
        
        fprintf('Starting spacingFactor = %.2e.\n', spacingVec(i));
        
        for j = 1:length(tempVec)
            
            fprintf('Starting temperature = %.3f K.\n', tempVec(j));
            fprintf('Date: %s.\n', datestr(now));
            
            FKModel('S', 0, 'Forcing', 0, ...
                'Temperature', tempVec(j), 'Spring', springVec(l), ...
                'Spacing', spacingVec(i), ... 
                varargin{:});
            
        end
        
    end
    
end

beep

end
