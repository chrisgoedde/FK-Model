function externalForce = makeDrivingForce(tau)

[ epsilon, epsilonPush, tau0Push, taufPush, epsilonPull, tau0Pull, taufPull ] = initDrivingForce();

numTimes = length(tau);
N = length(epsilon);

epsilon = repmat(epsilon, [ 1 numTimes ]);

tauMatrix = repmat(tau, [ N 1 ]);

epsilonPush = repmat(epsilonPush, [ 1 numTimes ]);
epsilonPush = epsilonPush .* (tauMatrix >= tau0Push) .* (tauMatrix <= taufPush);
epsilonPull = repmat(epsilonPull, [ 1 numTimes ]);
epsilonPull = epsilonPull .* (tauMatrix >= tau0Pull) .* (tauMatrix <= taufPull);

externalForce = epsilon + epsilonPush + epsilonPull;

% externalForce = epsilon;
% 
% if tau >= tau0Push && tau <= taufPush
%     
%     externalForce = externalForce + epsilonPush;
%     
% end
% 
% if tau >= tau0Pull && tau <= taufPull
%     
%     externalForce = externalForce + epsilonPull;
%     
% end

end
