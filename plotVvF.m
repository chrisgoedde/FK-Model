function plotVvF(varargin)
    
    [ pathFormats, pathValues, ~ ] = parseArguments(varargin{:});
    [ unit ] = setPhysicalConstants(varargin{:});
    
    load(FKDefaults, 'geometry')
    
    [ TempValues, TempIndex ] = findValues('Theta =', pathFormats, pathValues);
    
    if isempty(TempValues)
        
        disp('No data files found!')
        return
        
    end
    
    for i = 1:length(TempValues)
        
        pathValues{TempIndex} = TempValues{i};
        
        [ ForceValues, ForceIndex ] = findValues('epsilon =', pathFormats, pathValues);
        % ForceValues = ForceValues(1:end-3);
        ForceValues = sort(cell2mat(ForceValues));
        ForceValues = ForceValues(2:end);
        disp(ForceValues)
        
        for j = 1:length(ForceValues)
            
            pathValues{ForceIndex} = ForceValues(j);
            readPathName = makePath(pathFormats, pathValues, []);
            
            if ~exist(sprintf('%s', readPathName), 'dir')
                
                fprintf('No appropriate folder at %s.\n', readPathName);
                
            end
            
            for r = 1:5
            
                [ ~, ~, rho ] = loadDynamics(readPathName, geometry, r);
                flowRate(r, i, j) = mean(mean(rho(:, 251:1001))); %#ok<AGROW>
                if flowRate(r, i, j) < 0
                    fprintf('flow rate is negative for run %d, with force %.3f pN and temperature %.0f\n', ...
                        r, ForceValues(j)*unit.forceFactor{2}, TempValues{i}*unit.tempFactor{2}), pause
                elseif 10*flowRate(r, i, j)*unit.velocityFactor{2} > 450
                    fprintf('flow rate is too large for run %d, with force %.3f pN and temperature %.0f\n', ...
                        r, ForceValues(j)*unit.forceFactor{2}, TempValues{i}*unit.tempFactor{2}), pause
                end
                
            end
            force(i, j) = ForceValues(j); %#ok<AGROW>
            
        end
        
    end
    fR = squeeze(mean(flowRate));
    
    lineType = { '-o', '-d', '-s', '-v' };
    
    figure
    for i = 1:length(TempValues)
        
        [ f, index ] = sort(force(i, :));
        
        flowRate = min(447, 10*fR(i, index)*unit.velocityFactor{2});
        loglog(f*unit.forceFactor{2}, flowRate, lineType{i})
        hold on
        
    end
    
    axis([ 1e-3 10 1 1000 ])
    % set(gca, 'fontsize', 14)
    xlabel('force (pN)')
    ylabel('flow rate (A/ns)')
    
    grid on, % grid minor
    grid minor
    grid minor
    set(gca, 'fontsize', 8)
    legend('T = 5 K', 'T = 20 K', 'T = 75 K', 'T = 300 K', 'location', 'southeast')
    setPrintSize(3.5, 2, true)
    makePrint('.', 'flowRate', 'pdf', 'true')
    
end