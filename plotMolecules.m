function plotMolecules(varargin)

[ ~, ~, ~, ~, ~, f0, ~, ~, ~, ~, geometry, runNumber, ...
    pathFormats, pathValues ] = parseArguments(varargin{:});

readPathName = makePath(pathFormats, pathValues, []);

alpha = [];
gamma = [];
beta = [];

if ~PathExists(readPathName)
    
    fprintf('Path %s does not exist.\n', readPathName);
    return
    
end

load(sprintf('%s/%sConstants.mat', readPathName, geometry));

[ ~, phi, rho ] = loadDynamics(readPathName, geometry, runNumber);

theTitle = makePlotTitle(alpha, gamma, varargin{:});

[ ~, offset, ~, ~, ~, ~, ~, ~, ~ ] = processChain(phi, rho, wavelengthFactor, alpha, delta, gamma, beta, epsilon);

moleculeIndex = (1:N)';

f = figure;

pos = get(f, 'position');
pos(3) = pos(3)*2;
pos(4) = pos(4)*2;
set(f, 'position', pos);

% subplot(2, 2, 1);
% 
% plot(phi0/(4*pi), phi(:, end)/(4*pi), 'o'), grid on, box on
% 
% grid on
% box on
% set(gca, 'fontsize', 14)
% xlabel('initial position (arb)')
% ylabel('final position (arb)')
% 
% title(theTitle)

subplot(2, 2, 1)

plot(moleculeIndex, p0*rho(:,end)/mAvg, 's', moleculeIndex, p0*rho(:,1)/mAvg, '-o'), grid on, box on

grid on
box on
set(gca, 'fontsize', 14)
xlabel('molecule number')
ylabel('velocity (m/s)');
legend(sprintf('t = %.1f ns', tf), 't = 0.0 ns', 'location', 'best')

title(theTitle)

subplot(2, 2, 2)

if f0 ~= 0
    plot(moleculeIndex, offset(:, end)/(2*pi*wavelengthFactor)-mean(offset(:,end)/(2*pi*wavelengthFactor))+0.5, '-s', moleculeIndex, offset(:, 1)/(2*pi*wavelengthFactor), '-o'), grid on, box on
else
    plot(moleculeIndex, offset(:, end)/(2*pi*wavelengthFactor), '-s', moleculeIndex, offset(:, 1)/(2*pi*wavelengthFactor), '-o'), grid on, box on
end
grid on
box on
set(gca, 'fontsize', 14)
xlabel('molecule number')
% ylabel('soliton shape')
ylabel('(z_n - n\lambda)/\lambda')
legend(sprintf('t = %.1f ns', tf), 't = 0.0 ns', 'location', 'best')

title(theTitle)

% phi0Tilde = fft(phi(:, 1))/sqrt(N);
% rho0Tilde = fft(rho(:, 1))/sqrt(N);
% phifTilde = fft(phi(:, end))/sqrt(N);
% rhofTilde = fft(rho(:, end))/sqrt(N);

% if rem(N-1, 2) == 0
%     
%     num = (N-1)/2;
% 
%     phi0PS = [ abs(phi0Tilde(1)).^2; abs(phi0Tilde(2:num+1)).^2 + flipud(abs(phi0Tilde(num+2:end)).^2) ];
%     rho0PS = [ abs(rho0Tilde(1)).^2; abs(rho0Tilde(2:num+1)).^2 + flipud(abs(rho0Tilde(num+2:end)).^2) ];
%     phifPS = [ abs(phi0Tilde(1)).^2; abs(phifTilde(2:num+1)).^2 + flipud(abs(phifTilde(num+2:end)).^2) ];
%     rhofPS = [ abs(rhofTilde(1)).^2; abs(rhofTilde(2:num+1)).^2 + flipud(abs(rhofTilde(num+2:end)).^2) ];
%     
%     k = (0:num)' * (2*pi/(L*1e9));
%     
% else
%     
%     
% end

% Plot the power spectrum of the velocity and position. Not very useful.

% subplot(2, 2, 3)
% 
% semilogy(k, rho0PS, 'og', k, rhofPS, 'sb')
% grid on
% box on
% set(gca, 'fontsize', 14)
% xlabel('wave number (1/nm)')
% ylabel('velocity power spectrum (arb)')
% legend('initial', 'final')
% 
% title(theTitle)

% subplot(2, 2, 4)
% 
% semilogy(k, phi0PS, 'og', k, phifPS, 'sb')
% grid on
% box on
% set(gca, 'fontsize', 14)
% xlabel('wave number (1/nm)')
% ylabel('shape power spectrum (arb)')
% legend('initial', 'final')
% 
% title(theTitle)

subplot(2, 2, 3)

hist(p0*rho(:,end)/mAvg, 20)
% [ v, f ] = kde(p0*rho(:,end)/mAvg);
% plot(v, f, 'linewidth', 2)
grid on
box on
set(gca, 'fontsize', 14)
xlabel('velocity (m/s)');
% ylabel('probability density ((m/s)^{-1})')
ylabel('Number of molecules')
title(theTitle)
% disp(mean(p0*rho(:,end)/mAvg))

subplot(2, 2, 4)

hist((2/kB)*(p0*rho(:,end)).^2/(2*mAvg), 20)
% hist(sqrt(kB*bathTemp/mAvg)*randn(size(rho(:,end))), 20)
% [ T, f ] = kde((2/kB)*(p0*rho(:,end)).^2/(2*mAvg));
% plot(T, f, 'linewidth', 2)
grid on
box on
set(gca, 'fontsize', 14)
% xL = get(gca, 'xlim');
% set(gca, 'xlim', [ 0 xL(2) ])
xlabel('Energy (K)');
% ylabel('probability density (K^{-1})')
ylabel('Number of molecules')
title(theTitle)
% disp(mean(p0*randn(size(rho(:,end)))/mAvg))
end
