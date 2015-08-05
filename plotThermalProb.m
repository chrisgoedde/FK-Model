function plotThermalProb(flagTotal, varargin)
    
    [ pathFormats, pathValues, rN ] = parseArguments(varargin{:}, ...
        'Temperature', 0, 'Duration', 0, 'Save Type', 'Data');
    
    load(FKDefaults, 'gamma', 'N0')
    
    if flagTotal
        
        normN = 1;
        
    else
        
        normN = N0;
        
    end
    
    [ values, index ] = findValues('spring =', pathFormats, pathValues);
    
    disp(length(values))
    
    count = 0;
    for i = 1:length(values)
        
        pathValues{index} = values{i};
        readPathName = makePath(pathFormats, pathValues, []);
        
        if ~exist(sprintf('%s', readPathName), 'dir')
            
            fprintf('No appropriate folder at %s.\n', readPathName);
            return
            
        end
        
        if values{i}(1) == gamma
            
            count = count + 1;
            
            a(count) = values{i}(2); %#ok<AGROW>
            eFlat(count) = 0; %#ok<AGROW>
            flagFlat(count) = 0; %#ok<AGROW>
            eKinks(1, count) = 0; %#ok<AGROW>
            flagKinks(1, count) = 0; %#ok<AGROW>
            eAntikinks(1, count) = 0; %#ok<AGROW>
            flagAntikinks(1, count) = 0; %#ok<AGROW>
            
            sVec = findGeometries('e', rN, readPathName);
            sVec = sort(sVec);
            
            parseArguments('Spacing', a(count));
            
            for n = 1:length(sVec)
                
                geometry = sprintf('e%d', sVec(n));
                
                [ ~, phi, rho ] = loadDynamics(readPathName, geometry, rN);
                
                [ ~, tempPE ] = findChainEnergy(phi, rho);
                
                if sVec(n) == 0
                    
                    eFlat(count) = tempPE/normN;
                    flagFlat(count) = 1;
                    
                elseif sVec(n) < 0
                    
                    eKinks(abs(sVec(n)), count) = tempPE/normN;
                    flagKinks(abs(sVec(n)), count) = 1;
                    
                else
                    
                    eAntikinks(sVec(n), count) = tempPE/normN;
                    flagAntikinks(sVec(n), count) = 1;
                    
                end
                
            end
            
        end
        
    end
    
    parseArguments(varargin{:});
    
    load(FKDefaults, 'Theta')
    
    % ZFlat = exp(-eFlat/Theta).*flagFlat;
    % ZKinks = sum(exp(-eKinks/Theta).*flagKinks);
    % ZAntikinks = sum(exp(-eAntikinks/Theta).*flagAntikinks);
    
    % Z = ZFlat + ZKinks + ZAntikinks;
    
    [ numKP, ~ ] = size(eKinks);
    [ numAKP, ~ ] = size(eAntikinks);
    
    % probFlat = exp(-eFlat/Theta).*flagFlat./Z;
    % probKinks = exp(-eKinks/Theta).*flagKinks./repmat(Z, [numKinks 1]);
    % probAntikinks = exp(-eAntikinks/Theta).*flagAntikinks./repmat(Z, [numAntikinks 1]);
    
    probKinks = zeros(numKP, count);
    probAntikinks = zeros(numAKP, count);
    
    eFT = repmat(eFlat, [ numKP 1 ]);
    fFT = repmat(flagFlat, [ numKP 1 ]);
    eFTA = repmat(eFlat, [ numAKP 1 ]);
    fFTA = repmat(flagFlat, [ numAKP 1 ]);
    
    probFlat = 1./(1 + sum(exp(-(eKinks-eFT)/Theta).*flagKinks.*fFT) ...
        + sum(exp(-(eAntikinks-eFTA)/Theta).*flagAntikinks.*fFTA));
    
    for i = 1:numKP
        
        eFT = repmat(eKinks(i,:), [ numKP 1 ]);
        eFTA = repmat(eKinks(i,:), [ numAKP 1 ]);
        fK = repmat(flagKinks(i,:), [ numKP 1 ]);
        fKA = repmat(flagKinks(i,:), [ numAKP 1 ]);
        probKinks(i,:) = 1./(exp(-(eFlat-eKinks(i,:))/Theta) ...
            + sum(exp(-(eKinks-eFT)/Theta).*flagKinks.*fK) ...
            + sum(exp(-(eAntikinks-eFTA)/Theta).*flagAntikinks.*fKA));
    
    end
    
    for i = 1:numAKP
        
        eFT = repmat(eAntikinks(i,:), [ numKP 1 ]);
        eFTA = repmat(eAntikinks(i,:), [ numAKP 1 ]);
        fK = repmat(flagAntikinks(i,:), [ numKP 1 ]);
        fKA = repmat(flagAntikinks(i,:), [ numAKP 1 ]);
        probAntikinks(i,:) = 1./(exp(-(eFlat-eAntikinks(i,:))/Theta) ...
            + sum(exp(-(eKinks-eFT)/Theta).*flagKinks.*fK) ...
            + sum(exp(-(eAntikinks-eFTA)/Theta).*flagAntikinks.*fKA));
    
    end
    
    % disp((probFlat.*flagFlat + sum(probKinks.*flagKinks) + sum(probAntikinks.*flagAntikinks))')
    
    probFlat(~flagFlat) = NaN;
    probKinks(~flagKinks) = NaN;
    probAntikinks(~flagAntikinks) = NaN;
    eFlat(~flagFlat) = NaN;
    eKinks(~flagKinks) = NaN;
    eAntikinks(~flagAntikinks) = NaN;
    
    probFig = figure;
    hold on, grid on, box on
    plot(a-1, probFlat, '-', 'linewidth', 2);
    
    energyFig = figure;
    hold on, grid on, box on
    plot(a-1, eFlat, '-', 'linewidth', 2);
    
    legendArray = cell(1, 1+numKP+numAKP);
    plural = { 's', '' };
    legendArray{1} = 'no solitons';
    for n = 1:numKP
        legendArray{1+n} = sprintf('%d kink%s', n, plural{(n==1) + 1});
    end
    for n = 1:numAKP
        legendArray{1+n+numKP} = sprintf('%d antikink%s', n, plural{(n==1) + 1});
    end
    
    for n = 1:numKP
        
        figure(probFig)
        plot(a-1, probKinks(n,:), '-.', 'linewidth', 2)
        figure(energyFig)
        plot(a-1, eKinks(n,:), '-.', 'linewidth', 2)
        
    end
    
    for n = 1:numAKP
        
        figure(probFig)
        plot(a-1, probAntikinks(n,:), '--', 'linewidth', 2)
        figure(energyFig)
        plot(a-1, eAntikinks(n,:), '--', 'linewidth', 2)
        
    end
    
    [ pathFormats, pathValues, ~ ] = parseArguments('Save Type', 'Pictures');
    tempPathName = makePath(pathFormats, pathValues, 'Theta =');
    muPathName = makePath(pathFormats, pathValues, 'mu =');

    figure(probFig)
    set(gca, 'fontsize', 12)
    set(gca, 'xlim', [ min(a-1) max(a-1) ]);
    set(gca, 'ylim', [ 0 1 ] );
    set(gca, 'xtick', min(a-1) : 0.02 : max(a-1))
    xlabel(['a/\lambda ' char(8722) ' 1'])
    ylabel('Thermal probability')
    first = sprintf('Free-end chain, N0 = %d, %s = %.1f, %s = %.2f', ...
        N0, '\gamma', gamma, '\Theta', Theta);
    if flagTotal
        title({ first; 'Using total energy to calculate probabilities' })
    else
        title({ first; 'Using average energy to calculate probabilities' })
    end
    legend(legendArray, 'location', 'eastoutside')
    setPrintSize(8, 6, true)
    if flagTotal
        makePrint(tempPathName, sprintf('prob-total-%.1f', gamma), 'png', true)
    else
        makePrint(tempPathName, sprintf('prob-avg-%.1f', gamma), 'png', true)
    end
    
    figure(energyFig)
    set(gca, 'fontsize', 12)
    set(gca, 'xlim', [ min(a-1) max(a-1) ]);
    set(gca, 'xtick', min(a-1) : 0.02 : max(a-1))
    xlabel(['a/\lambda ' char(8722) ' 1'])
    if flagTotal
        ylabel('Total energy')
    else
        ylabel('Average energy')
    end
    title(sprintf('Free-end chain, N0 = %d, %s = %.1f', ...
        N0, '\gamma', gamma))
    legend(legendArray, 'location', 'eastoutside')
    setPrintSize(8, 6, true)
    if flagTotal
        makePrint(muPathName, sprintf('energy-total-%.1f', gamma), 'png', true)
    else
        makePrint(muPathName, sprintf('energy-avg-%.1f', gamma), 'png', true)
    end
    
    % PK1 = exp(-eKinks(1,:)/Theta)./exp(eFlat/Theta);
    % PAK1 = exp(-eAntikinks(1,:)/Theta)./exp(eFlat/Theta);
    PK1 = exp(-(eKinks(1,:)-eFlat)/Theta);
    PAK1 = exp(-(eAntikinks(1,:)-eFlat)/Theta);
    % disp(PK1)
    % disp(PAK1)

    figure
    hold on, grid on, box on
    plot(a-1, PK1, 'linewidth', 2)
    plot(a-1, PAK1, 'linewidth', 2)
    set(gca, 'fontsize', 12)
    set(gca, 'xlim', [ min(a-1) max(a-1) ]);
    set(gca, 'xtick', min(a-1) : 0.02 : max(a-1))
    xlabel(['a/\lambda ' char(8722) ' 1'])
    ylabel('P_{1 soliton}/P_{flat}')
    set(gca, 'ylim', [ 0 1 ])
    first = sprintf('Free-end chain, N0 = %d, %s = %.1f, %s = %.2f', ...
        N0, '\gamma', gamma, '\Theta', Theta);
    if flagTotal
        title({ first; 'Using total energy to calculate probabilities' })
    else
        title({ first; 'Using average energy to calculate probabilities' })
    end
    legend('kink', 'antikink', 'location', 'eastoutside')
    setPrintSize(8, 6, true)
    if flagTotal
        makePrint(tempPathName, sprintf('pratio-total-%.1f', gamma), 'png', true)
    else
        makePrint(tempPathName, sprintf('pratio-avg-%.1f', gamma), 'png', true)
    end

end