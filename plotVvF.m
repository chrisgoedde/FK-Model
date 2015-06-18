function plotVvF(varargin)

[ pathFormats, pathValues, ~ ] = parseArguments(varargin{:});

load(FKDefaults, 'N0', 'eta', 'S', 'geometry')

topPathName = makePath(pathFormats, pathValues, 4);

fileList = dir(topPathName);

[ bathTempList, bathTempFolder ] = getFoldersAndValues(fileList, 'T =');

figHandle = [];
styleArray = { '*', 'o', 's', 'd', '+', 'v' };
cM = colormap(lines);
numLegends = 1;

if isempty(bathTempList)
    
    disp('No data files found!')
    return
    
end

for j = 1:length(bathTempList)
    
    pathValues{5} = bathTempList(j);
    
    midPathName = makePath(pathFormats, pathValues, 6);
    fileList = dir(midPathName);
    
    [ forceList, ~ ] = getFoldersAndValues(fileList, 'f =');
    
    velocity = zeros(1, length(forceList));
    velDev = zeros(1, length(forceList));
    
    fCount = 1;
    while fCount <= length(forceList)
        
        pathValues{7} = forceList(fCount);
        newPathName = makePath(pathFormats, pathValues, []);
        
        fprintf('Looking for path %s\n', newPathName)
        if exist(newPathName, 'file')
            
            fprintf('Loading file %s/ringConstants.mat\n', newPathName)
            load(sprintf('%s/ringConstants.mat', newPathName), 'p0', 'mAvg', 'a', 'g')
            
            [ flowRate, numSets ] = getFlowRates(newPathName, geometry);
            
            velocity(fCount) = p0*mean(flowRate)/mAvg;
            velDev(fCount) = p0*std(flowRate)/mAvg;
            fCount = fCount+1;
            
        else
            
            for k = fCount+1:length(forceList)
                
                forceList(k-1) = forceList(k);
                velocity(k-1) = velocity(k);
                velDev(k-1) = velDev(k);
                
            end
            
            forceList = forceList(1:end-1);
            velocity = velocity(1:end-1);
            velDev = velDev(1:end-1);
            
        end
        
        
    end
    
    if ~isempty(forceList)
        
        if isempty(figHandle)
            
            figHandle = figure;
            
            soliton = (2*abs(S)/(2*N0))*mean(a)*sqrt(mean(g)/mAvg)./sqrt(1+(4*p0*eta./(pi*forceList*1e-12)).^2);
            loglog(forceList, soliton, '*m', 'linewidth', 2), hold on
            
            set(gca, 'fontsize', 14)
            xlabel('force (pN)')
            ylabel('flow rate (m/s)')
            
            theTitle = makePlotTitle(alpha, gamma, varargin{:});
            title(theTitle)
            
            legendArray{1} = 'Theory';
            
        end
        
        numLegends = numLegends + 1;

%         loglog(forceList, velocity, styleArray{j}, 'linewidth', 2)
        
        errorbar(forceList, velocity, velDev, styleArray{mod(numLegends-1,length(styleArray))+1}, ...
            'linewidth', 2, 'color', cM(mod(numLegends-1, 7)+1,:))
        if numSets > 2
            legendArray{numLegends} = sprintf('%s (%d runs)', bathTempFolder{j}, numSets-1); %#ok<AGROW>
        else
            legendArray{numLegends} = sprintf('%s (%d run)', bathTempFolder{j}, numSets-1); %#ok<AGROW>
        end
        
    end
    
end

set(gca, 'ylim', [ 0.1 1000 ]);
grid on, box on, grid minor

legend(legendArray, 'location', 'best')

end