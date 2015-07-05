function [ eVOut, ePushVOut, tau0PushOut, taufPushOut, ePullVOut, ...
    tau0PullOut, taufPullOut, dTugOut, tfTugOut, gammaTugOut, startTugOut ] = initDrivingForce(varargin)

persistent eV ePushV tau0Push taufPush ePullV tau0Pull taufPull ...
    dTug tfTug gammaTug startTug

if ~isempty(varargin)
    
    eV = varargin{1};
    ePushV = varargin{2};
    tau0Push = varargin{3};
    taufPush = varargin{4};
    ePullV = varargin{5};
    tau0Pull = varargin{6};
    taufPull = varargin{7};
    dTug = varargin{8};
    tfTug = varargin{9};
    gammaTug = varargin{10};
    startTug = varargin{11};
    
end

eVOut = eV;
ePushVOut = ePushV;
tau0PushOut = tau0Push;
taufPushOut = taufPush;
ePullVOut = ePullV;
tau0PullOut = tau0Pull;
taufPullOut = taufPull;
dTugOut = dTug;
tfTugOut = tfTug;
gammaTugOut = gammaTug;
startTugOut = startTug;

end
