function findRuns(num, location, varargin)

[ pathFormats, pathValues, ~ ] = parseArguments(varargin{:});

numIndex = (num == 1) + 1;
plural = { 's', '' };

load(FKDefaults, 'geometry')

readPathName = makePath(pathFormats, pathValues, []);

if ~exist(sprintf('%s/%sConstants.mat', readPathName, geometry), 'file')
    
    fprintf('No appropriate run at %s.\n', readPathName);
    return
    
end

load(sprintf('%s/%sConstants.mat', readPathName, geometry));

runNumber = 1;

while exist(sprintf('%s/%sDynamics-%d.mat', readPathName, geometry, runNumber), 'file')
    
    [ ~, phi, ~, ~, ~ ] = loadDynamics(readPathName, geometry, runNumber);
    
    [ ~, offset ] = findChainPosition(phi, wavelengthFactor, M, Lambda, alphaVector);
    
    [ solitonNumber(runNumber, :), solitonPosition(runNumber, :) ] = findSolitons(offset, wavelengthFactor); %#ok<AGROW>
    
    runNumber = runNumber + 1;
    
end

runNumber = runNumber - 1;

for i = 1:runNumber
    
    if ~isempty(num)
        
        foundNum = sum(solitonNumber(i, :) == num);
        
    else
        
        foundNum = 1;
        
    end
    
    if ~isempty(location)
        
        foundLocation = sum(solitonPosition(i, :) == location);
        
    else
        
        foundLocation = 1;
        
    end
    if foundNum && foundLocation
        
        fprintf('Run %d', i)
        if ~isempty(num)
            fprintf(' has %d soliton%s', num, plural{numIndex});
            if isempty(location)
                fprintf('.\n')
            else
                fprintf(' at position %.1f.\n', location)
            end
        else
            fprintf(' is at position %.1f.\n', location)
        end
        
    end
    
end

end
