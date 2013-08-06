function [sys,x0,str,ts] = pwa_ctrl(t,x,u,flag,pwactrl,SimParam)
switch flag,
    
    %%%%%%%%%%%%%%%%%%
    % Initialization %
    %%%%%%%%%%%%%%%%%%
    case 0,
        [sys,x0,str,ts]=mdlInitializeSizes(pwactrl,SimParam);
        
        %%%%%%%%%%%%%%%
        % Derivatives %
        %%%%%%%%%%%%%%%
    case 1,
        sys=mdlDerivatives(t,x,u,nlsys);
        
        %%%%%%%%%%%
        % Outputs %
        %%%%%%%%%%%
    case 3,
        sys=mdlOutputs(t,x,u,pwactrl,SimParam);
        
        %%%%%%%%%%%%%%%%%%%
        % Unhandled flags %
        %%%%%%%%%%%%%%%%%%%
    case { 2, 4, 9 },
        sys = [];
        
        %%%%%%%%%%%%%%%%%%%%
        % Unexpected flags %
        %%%%%%%%%%%%%%%%%%%%
    otherwise
        error(['Unhandled flag = ',num2str(flag)]);
        
end
% end pwa_sfunc

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================

function [sys,x0,str,ts]=mdlInitializeSizes(pwactrl,SimParam)

m = size(pwactrl.Kbar{1},1);
n = size(pwactrl.Kbar{1},2)-1;

sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = m;
sizes.NumInputs      = n;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];

% end mdlInitializeSizes
%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u)

sys = [];
% end mdlDerivatives
%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u,pwactrl,SimParam)
xbar = [u;1];
if strcmp(lower(SimParam.ctrl),'linear'),
    Ri = pwa_recreg(pwactrl.xcl,pwactrl);
    sys = pwactrl.Kbar{Ri}*xbar;
elseif strcmp(lower(SimParam.ctrl),'pwa'),
    Ri = pwa_recreg(u,pwactrl);
    if isempty(Ri{1}),
        X = u
        t
        set_param(gcs,'SimulationCommand','stop');
        sys = 0*pwactrl.Kbar{1}*xbar;
    else
        sys = pwactrl.Kbar{Ri{1}(1)}*xbar;
    end
else
    error('SimParam.sys is undefined.');
end

% end mdlOutputs