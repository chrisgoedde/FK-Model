function externalForce = makeDrivingForce(tau, phi)

[ eV, eVPush, tau0Push, taufPush, eVPull, tau0Pull, taufPull, ...
    phiTug, taufTug, gammaTug, startTug ] = initDrivingForce();

numTimes = length(tau);
N = length(eV);

eV = repmat(eV, [ 1 numTimes ]);

eVTug = zeros(N, numTimes);

endPoint = [ startTug + phiTug*tau/taufTug; startTug + phiTug*ones(size(tau)) ];
endPoint = min(endPoint);

eVTug(N, :) = -gammaTug * (phi(N, :)-endPoint);

% if taufTug ~= 0
%     disp(gammaTug), disp(startTug), disp(phiTug), disp(phi(N)), disp(endPoint)
%     disp(eVTug(N,:)), pause
% end
    
tauMatrix = repmat(tau, [ N 1 ]);

eVPush = repmat(eVPush, [ 1 numTimes ]);
eVPush = eVPush .* (tauMatrix >= tau0Push) .* (tauMatrix <= taufPush);
eVPull = repmat(eVPull, [ 1 numTimes ]);
eVPull = eVPull .* (tauMatrix >= tau0Pull) .* (tauMatrix <= taufPull);

externalForce = eV + eVPush + eVPull + eVTug;

end
