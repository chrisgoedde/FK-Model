function plotVvS(varargin)

[ ~, ~, eta, ~, ~, f0, ~, ~, ~, ~, geometry, ~, ...
    pathFormats, pathValues ] = parseArguments(varargin{:});

topPathName = makePath(pathFormats, pathValues, 'type =');

fileList = dir(topPathName);

[ N0Vec, ~ ] = getFoldersAndValues(fileList, 'N0 =');

styleArray = { '*', 'o', 's', 'd', '+', 'v' };
cM = colormap(lines);
numLegends = 1;
figure

if isempty(N0Vec)
    
    disp('No data files found!')
    return
    
end

disp(N0Vec)

for n = 1:length(N0Vec)
    
    N0 = N0Vec(n);
    pathValues{3} = N0;
    needTheoryLegend = true;
    
    topPathName = makePath(pathFormats, pathValues, 'eta = ');
    
    fileList = dir(topPathName);
    
    [ bathTempList, bathTempFolder ] = getFoldersAndValues(fileList, 'T =');
    
    if isempty(bathTempList)
        
        disp('No data files found!')
        return
        
    end
    
    disp(bathTempList)
    
    for j = 1:length(bathTempList)
        
        pathValues{5} = bathTempList(j);
        
        midPathName = makePath(pathFormats, pathValues, 'T =');
        fileList = dir(midPathName);
        
        [ sList, sFolder ] = getFoldersAndValues(fileList, 'S =');
        
        disp(sList)
        
        velocity = zeros(1, length(sList));
        velDev = zeros(1, length(sList));
        
        sCount = 1;
        while sCount <= length(sList)
            
            pathValues{6} = sList(sCount);
            newPathName = makePath(pathFormats, pathValues, []);
            
            fprintf('Looking for path %s\n', newPathName)
            
            if exist(newPathName, 'file')
                
                fprintf('Loading file %s/ringConstants.mat\n', newPathName)
                load(sprintf('%s/ringConstants.mat', newPathName), 'p0', 'mAvg', 'a', 'g')
                
                [ flowRate, numSets ] = getFlowRates(newPathName, geometry);
                
                velocity(sCount) = p0*mean(flowRate)/mAvg;
                velDev(sCount) = p0*std(flowRate)/mAvg;
                sCount = sCount+1;
                
            else
                
                for k = sCount+1:length(sList)
                    
                    sList(k-1) = sList(k);
                    sFolder{k-1} = sFolder{k};
                    velocity(k-1) = velocity(k);
                    
                end
                
                sList = sList(1:end-1);
                sFolder = sFolder(1:end-1);
                velocity = velocity(1:end-1);
                
            end
            
            
        end
        
        if ~isempty(sList)
            
            if needTheoryLegend
                
                soliton = (2*abs(sList)/(2*N0))*mean(a)*sqrt(mean(g)/mAvg)./sqrt(1+(4*p0*eta./(pi*f0*1e-12)).^2);
                plot(sList*200/N0, soliton, styleArray{mod(numLegends-1,length(styleArray))+1}, ...
                    'linewidth', 2, 'color', cM(mod(numLegends-1, 7)+1,:)), hold on
                
                set(gca, 'fontsize', 14)
                xlabel('S (scaled to N0 = 200)')
                ylabel('flow rate (m/s)')
                
                theTitle = makePlotTitle(alpha, gamma, varargin{:});
                title(theTitle)
                
                legendArray{numLegends} = sprintf('N0 = %d, Theory', N0); %#ok<AGROW>
                numLegends = numLegends + 1;
                
                needTheoryLegend = false;
                
            end
            
            whos
            disp(numLegends)
            
            errorbar(sList*200/N0, velocity, velDev, styleArray{mod(numLegends-1,length(styleArray))+1}, ...
                'linewidth', 2, 'color', cM(mod(numLegends-1, 7)+1,:))
            if numSets > 2
                legendArray{numLegends} = sprintf('N0 = %d, %s (%d runs)', N0, bathTempFolder{j}, numSets-1); %#ok<AGROW>
            else
                legendArray{numLegends} = sprintf('N0 = %d, %s (%d run)', N0, bathTempFolder{j}, numSets-1); %#ok<AGROW>
            end
            numLegends = numLegends + 1;
            
        end
        
    end
    
end

set(gca, 'ylim', [ 0 100 ]);
grid on, box on

legend(legendArray, 'location', 'best')

end