function plotEnergy(varargin)

[ pathFormats, pathValues, runNumber ] = parseArguments(varargin{:});
[ unit ] = setPhysicalConstants(varargin{:});

load(FKDefaults, 'geometry')

readPathName = makePath(pathFormats, pathValues, []);

fontSize = 14;

if ~exist(sprintf('%s/%sConstants.mat', readPathName, geometry), 'file')
    
    fprintf('No appropriate run at %s.\n', readPathName);
    return
    
end

load(sprintf('%s/%sConstants.mat', readPathName, geometry));

[ tau, phi, rho, ~, ~ ] = loadDynamics(readPathName, geometry, runNumber);

% if unit.timeFactor{2} * tau(end) >= 1000
%     
%     unit.timeFactor{2} = unit.timeFactor{2}/1000;
%     unit.timeName{2} = ' ns';
%     unit.timeLabel{2} = '(ns)';
%     
% end

[ KE, PE ] = findChainEnergy(phi, rho, alphaVector, deltaVector, gammaVector);

theTitle = makeTitle(unit, runNumber);

figure;

tF = unit.timeFactor{unit.flag};
EF = unit.energyFactor{unit.flag};

plot(tF * tau, EF * PE/N, 'r', 'linewidth', 2), grid on, box on, hold on
plot(tF * tau, EF * KE/N, 'g', 'linewidth', 2)

set(gca, 'fontsize', fontSize)
xlabel(sprintf('time %s', unit.timeLabel{unit.flag}))
ylabel(sprintf('Energy per monomer %s', unit.energyLabel{unit.flag}))

legend('Potential', 'Kinetic', 'location', 'best')

title(theTitle)

end
