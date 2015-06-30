function substrateForce = makeSubstrateForce(phi)

[ M, Lambda, Psi ] = initSubstrateForce();

substrateForce = -sin(phi) .* (phi <= 2*pi*M) ...
    - Psi*(sin((phi-2*pi*M)/Lambda)/Lambda) .* (phi > 2*pi*M);

end
