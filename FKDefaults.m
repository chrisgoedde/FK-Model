function name = FKDefaults

[ ~, systemName ] = system('hostname');
systemName = strtok(systemName, '.');

name = sprintf('FKDefaults-%s.mat', systemName);

end