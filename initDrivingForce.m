function [ epsilonOut, epsilonPushOut, tau0PushOut, taufPushOut, epsilonPullOut, tau0PullOut, taufPullOut ] = initDrivingForce(varargin)

persistent epsilon epsilonPush tau0Push taufPush epsilonPull tau0Pull taufPull

if ~isempty(varargin)
    
    epsilon = varargin{1};
    epsilonPush = varargin{2};
    tau0Push = varargin{3};
    taufPush = varargin{4};
    epsilonPull = varargin{5};
    tau0Pull = varargin{6};
    taufPull = varargin{7};
    
end

epsilonOut = epsilon;
epsilonPushOut = epsilonPush;
tau0PushOut = tau0Push;
taufPushOut = taufPush;
epsilonPullOut = epsilonPull;
tau0PullOut = tau0Pull;
taufPullOut = taufPull;

end
