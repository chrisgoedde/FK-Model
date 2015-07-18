function [ sFLeft, sFRight ] = makeSpringForce(phi)

[ alphaVector, gammaVector ] = initSpringForce();

stretch = phi - circshift(phi, 1) - alphaVector;
sFLeft = -gammaVector.*stretch;
sFRight = circshift(gammaVector, -1).*circshift(stretch, -1);

end
