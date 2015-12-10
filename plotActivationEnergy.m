function plotActivationEnergy(varargin)
    
    [ pathFormats, pathValues, runNumber ] = parseArguments(varargin{:}, 'Save Type', 'Data');
    [ unit ] = setPhysicalConstants(varargin{:});
    
    load(FKDefaults, 'geometry', 'gamma', 'alpha', 'wF', 'N0')
    
    [ SpringValues, SpringIndex ] = findValues('spring =', pathFormats, pathValues);
    
    if isempty(SpringValues)
        
        disp('No data files found!')
        return
        
    end
    
    figure
    hold on
	grid on
    box on
    set(gca, 'fontsize', 12)
    xlabel('(L-L_0)/\lambda')
    ylabel(sprintf('Energy per monomer %s', unit.energyLabel{unit.flag}))
    legendArray = {};
    set(gca, 'ylim', [ 0 1 ])

    numPlots = 0;
        
    for i = 1:length(SpringValues)
        
        if SpringValues{i}(1) == gamma % && SpringValues{i}(2) == round(alpha/(2*pi), 3)
            
            pathValues{SpringIndex} = SpringValues{i};
            readPathName = makePath(pathFormats, pathValues, []);
            
            if ~exist(sprintf('%s', readPathName), 'dir')
                
                fprintf('No appropriate folder at %s.\n', readPathName);
                                
            end
            
            [ ~, phi, rho ] = loadDynamics(readPathName, geometry, runNumber);
            
            parseArguments('Spacing', SpringValues{i}(2), 'Spring', SpringValues{i}(1));
            [ ~, PE ] = findChainEnergy(phi, rho);
            [ ~, offset ] = findChainPosition(phi, wF);
            
            numSolitons = round((offset(end, 1) - offset(1, 1))/(2*pi));
            
            if numSolitons == 0
                
                numPlots = numPlots + 1;

                EF = unit.energyFactor{unit.flag};
            
                L = (phi(end, :) - phi(1, :))/(2*pi);
            
                plot(L-L(1), EF * PE/N0, '-')
                
                legendArray{numPlots} = [ 'a/\lambda = ' num2str(SpringValues{i}(2), '%.2f') ]; %#ok<AGROW>
                
            end

        end
        
    end
    
    legend(legendArray, 'location', 'eastoutside')
        
    index = unit.flag;
    title(sprintf('N = %d, %s = %.1f%s', ...
        N0, unit.springSymbol{index}, gamma*unit.springFactor{index}, ...
        unit.springName{index}))
    
    fileName = strjoin(strsplit(sprintf('Activation Energy (%s = %.1f%s)', ...
        unit.springSymbol{index}, gamma*unit.springFactor{index}, ...
        unit.springName{index}), '\\'), '');
        
    setPrintSize(8, 4, true)
    makePrint('../Activation/Pictures', fileName, 'pdf', true)
        
end
