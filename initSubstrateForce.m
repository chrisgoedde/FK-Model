function [ MOut, LambdaOut, PsiOut ] = initSubstrateForce(varargin)

persistent M Lambda Psi

if ~isempty(varargin)
    
    M = varargin{1};
    Lambda = varargin{2};
    Psi = varargin{3};
    
end

MOut = M;
LambdaOut = Lambda;
PsiOut = Psi;

end
