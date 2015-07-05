function externalForce = makeDrivingForce(tau, phi)

[ epsilon, epsilonPush, tau0Push, taufPush, epsilonPull, tau0Pull, taufPull, ...
    phiTug, taufTug, gammaTug, startTug ] = initDrivingForce();

numTimes = length(tau);
N = length(epsilon);

epsilon = repmat(epsilon, [ 1 numTimes ]);

epsilonTug = zeros(N, numTimes);

endPoint = [ startTug + phiTug*tau/taufTug; startTug + phiTug*ones(size(tau)) ];
endPoint = min(endPoint);

epsilonTug(N, :) = -gammaTug * (phi(N, :)-endPoint);

% if taufTug ~= 0
%     disp(gammaTug), disp(startTug), disp(phiTug), disp(phi(N)), disp(endPoint)
%     disp(epsilonTug(N,:)), pause
% end
    
tauMatrix = repmat(tau, [ N 1 ]);

epsilonPush = repmat(epsilonPush, [ 1 numTimes ]);
epsilonPush = epsilonPush .* (tauMatrix >= tau0Push) .* (tauMatrix <= taufPush);
epsilonPull = repmat(epsilonPull, [ 1 numTimes ]);
epsilonPull = epsilonPull .* (tauMatrix >= tau0Pull) .* (tauMatrix <= taufPull);

externalForce = epsilon + epsilonPush + epsilonPull + epsilonTug;

end
