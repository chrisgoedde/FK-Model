function [ epsilonOut, epsilonPushOut, tau0PushOut, taufPushOut, epsilonPullOut, ...
    tau0PullOut, taufPullOut, dTugOut, tfTugOut, strengthTugOut, startTugOut ] = initDrivingForce(varargin)

persistent epsilon epsilonPush tau0Push taufPush epsilonPull tau0Pull taufPull ...
    dTug tfTug strengthTug startTug

if ~isempty(varargin)
    
    epsilon = varargin{1};
    epsilonPush = varargin{2};
    tau0Push = varargin{3};
    taufPush = varargin{4};
    epsilonPull = varargin{5};
    tau0Pull = varargin{6};
    taufPull = varargin{7};
    dTug = varargin{8};
    tfTug = varargin{9};
    strengthTug = varargin{10};
    startTug = varargin{11};
    
end

epsilonOut = epsilon;
epsilonPushOut = epsilonPush;
tau0PushOut = tau0Push;
taufPushOut = taufPush;
epsilonPullOut = epsilonPull;
tau0PullOut = tau0Pull;
taufPullOut = taufPull;
dTugOut = dTug;
tfTugOut = tfTug;
strengthTugOut = strengthTug;
startTugOut = startTug;

end
