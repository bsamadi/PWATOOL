clear model pwasys pwainc setting
echo on;
clc
% *************************************************************************
%  SYNTHESIZING CONTROLLERS FOR A NONLINEAR model (GLOBAL LYAPUNOV APPROACH)
% *************************************************************************
% 
% PWATOOL can synthesize PWA controllers to stabilize a nonlinear system
% around a desired equilibrium point xcl. 
%
% We use the "Local Controller Extension" method (see B. Samadi and
% L. Rodrigues, 2008) to design a local controller at the equilibrium point
% region and extend it later to the whole regions. 
%
% Reference: B. Samadi and L. Rodrigues. Extension of local linear 
%            controllers to global piecewise affine controllers for uncertain
%            non-linear systems. International Journal of Systems Science,
%            39(9):867-879, 2008.
 
% Let us explain how PWA controllers are synthesized by PWATOOL. 
%
pause; %strike any key to continue
clc
%        SYNTHESIZING PWA CONTROLLERS; A GLOBAL LYAPUNOV APPROACH
%
%
% Consider a nonlinear model 
%
%          dx/dt = A x + a + f(x) + B(x) u                 (*)
%
% and the PWADI that approximates it for i=1,2,...,NR and j=1,2
% 
%          sigma_j:   dx/dt = A{i,j} x+ a{i,j}+ B{i,j} u      x is in region R_i
%
% where region R_i is defiend as
%
%             R_i = {x | E{i} x + e{i} >= 0 }.    i=1,2,...,NR.
% 
pause; %strike any key to continue
%
% Let the common boundary between regions R_i and R_h (if applicable) be
% contained in   
%
%             F{i,h} s + f{i,h}
%
% where s ranges over the vector space R^{n-1}
%
pause; %strike any key to continue
%
% In order to stabilize the nonlinear model around xcl, we find PWA 
% controllers u= K{i} x + k{i} that stabilize both envelopes sigma_1 and 
% sigma_2 around 'xcl'. 
%
% We use Lyapunov function to ensure the stability of the closed-loop
% PWADIs. 
%
pause; %strike any key to continue
clc
% By global Lyapunov approach in synthesizing PWA controllers 
% u = K{i} x + k{i}, we mean that a positive definite matrix Q>0 as well as
% the controller gains K{i} and and k{i} should be found such that the 
% following two conditions hold:
%
%    1)  V(x)  = x' Q x         >0                 for x defined by sigma_j
%    2)  dV/dt = d(x' Q x)/dt   <-alpha * V(x)     for x defined by sigma_j
%
% Here 'alpha' is the decay rate constant that should be set by the user in
% advance. In a sense, the higher alpha is, the faster the closed-loop 
% dynamics is.
%                                                   
pause; %strike any key to continue
clc
% Let Z{i} be matrices of proper size with non-negative elements which
% are to be found. Then, conditions (1) and (2) amount to the following
% problem, formulated as BMI:
%
pause; %strike any key to continue
clc
% PROBLEM: Find Q, K{i}, k{i} and Z{i} for i=1,2,...,NR such that for
% 
% (1) Q>0
%
% (2) In regions R_i which contain the equilibrium point xcl
%
%     Q*(A{i,j}+B{i,j}*K{i})+(A{i,j}+B{i,j}*K{i})'*Q+alpha*Q <0
%
%
% (3) In regions R_i which do NOT contain the equilibrium point xcl
%
%     [Q*(A{i,j}+B{i,j}*K{i})+(A{i,j}+B{i,j}*K{i})'*Q+alpha*Q+E{i}'*Z{i}*E{i}        Q*(a{i,j}+B{i,j}*k{i})+E{i}'*Z{i}*e{i};
%     (Q*(a{i,j}+B{i,j}*k{i})+E{i}'*Z{i}*e{i})'                                      e{i}'*Z{i}*e{i}]  < 0
%
% 
% (4) Continuity of the control outputs  (OPTIONAL)
% 
%     ((A{i,j}+B{i,j}*K{i})-(A{h,j}+B{h,j}*K{h})) * F{i,h}=0       for F{i,h} not empty and j=1,2
%     ((a{i,j}+B{i,j}*k{i})-(a{h,j}+B{h,j}*k{h})) * f{i,h}=0
% 
pause; %strike any key to continue
clc
% NOTE 1: PWATOOL uses Yalmip to solve above BMIs. A solution, then, may or
%         may not be found by the solver, depending on the size of the 
%         problem. 
%
pause; %strike any key to continue
%
% NOTE 2: Continuity of the control outputs is optional if the Lyapunov
%         function is global, i.e. V(x)= x'*Q*x. However, it is usually
%         desired that controller outputs show a continuous behavior at the
%         common border of regions. This condition, in fact, is derived
%         from the following constraint.
% 
%         (A{i,j}+B{i,j}*K{i}) * x+ (a{i,j}+B{i,j}*k{i}) = ...
%         (A{h,j}+B{h,j}*K{h}) * x+ (a{h,j}+B{h,j}*k{h})          for x on the boundary
%                                                                 of R_i and R_h (if not empty)
%
pause; %strike any key to continue
clc
% NOTE 3: The regions can also be approximated with ellipsoids which in the
%         case of slab regions they will be degenerate ellipsoids. This 
%         yields to a different set of BMIs.
%
% References: (1) A. Hassibi and S. Boyd. Quadratic stabilization and
%             control of piecewise-linear systems. Proceedings of the
%             American Control Conference, 6:3659-3664, 1998
% 
%             (2) L. Vandenberghe, S. Boyd, and S.-P. Wu. Determinant
%             maximization with linear matrix inequality constraints. SIAM
%             Journal on Matrix Analysis and Applications,9(2):499-533,1998
%
pause; %strike any key to continue
clc
% To obtain the controllers with ellipsoidal approximation, let 'Elip_i' be
% the ellipsoid that approximates region R_i:
% 
%                Elip_i={x | || EL{i} x + eL{i}|| < 1}
% 
%
pause; %strike any key to continue
% 
% Then, for i=1,2,...,NR and j=1,2 the following BMIs is sufficient
% conditions for stabilizing the nonlinear model around xcl.
%
% PROBLEM: Find Q, Q, K{i}, k{i} and miu{i} such that
%
% (1) Q>0, miu{i} <0
%
% (2) In regions R_i which contain the equilibrium point xcl
%
%     Q*(A{i,j}+B{i,j}*K{i})+(A{i,j}+B{i,j}*K{i})'*Q+alpha*Q <0
%
%
% (3) In regions R_i which do NOT contain the equilibrium point xcl
%
%     [Q*(A{i,j}+B{i,j}*K{i})+(A{i,j}+B{i,j}*K{i})'*Q+alpha*Q+miu{i}*EL{i}'*EL{i}        Q*(a{i,j}+B{i,j}*k{i})+miu{i}*EL{i}'*eL{i};
%     (Q*(a{i,j}+B{i,j}*k{i})+miu{i}*EL{i}'*eL{i})'                                      -miu{i}*(1-eL{i}'*eL{i});]<0
%
%
% (4) Continuity of the control outputs  (OPTIONAL)
% 
%     ((A{i,j}+B{i,j}*K{i})-(A{h,j}+B{h,j}*K{h})) * F{i,h}=0       for F{i,h} not empty and j=1,2
%     ((a{i,j}+B{i,j}*k{i})-(a{h,j}+B{h,j}*k{h})) * f{i,h}=0
%
%
pause; %strike any key to continue
clc
%             USING POWTOOL FOR SYNTHESIZING PWA CONTROLLERS
% 
% We use the nonlinear airfoil model (S. Afkhami and H. Alighanbari 2007)
% to show how PWA controllers can be designed by PWATOOL.
%
pause; %strike any key to continue
clc
% |-----------------------------------------------------------------------|
% | STEP 0: APPROXIMATING THE NONLINEAR MODEL WITH PWADI
% |-----------------------------------------------------------------------|
% 
% Please hit number 3 in the main menu of PWATOOL for "CREATING A PWADI
% MODEL"
%
% For the nonlinear airfoil model we load the variable 'flutter_pwadi'
% 
        load flutter_pwadi
%
% by doing so, a variable called 'pwainc' will contain the PWADI
% approximation of the nonlinear airfoil model.
% 
pause; %strike any key to continue
clc
% |-----------------------------------------------------------------------|
% | STEP 1: SYNTHESIZING PWA CONTROLLERS
% |-----------------------------------------------------------------------|
%
% PWA controllers can be synthesized by PWATOOL by the following command:
% 
% ctrl = pwasynth(pwainc, x0, setting)
%
% where 'pwainc' is the PWADI approximation of the nonlinear model, x0 is
% the initial point for simulation and 'setting' an array structure.
%
% We, first, choose the initial point
%
         x0=[.4 .63 .5 1.2]';
%
% Note that most of the fields of 'setting', if not set by the user, will
% take default values by PWATOOL. We explain the fields of 'setting' in the
% following.
%
pause; %strike any key to continue
clc
% setting.Lyapunov: shows whether 'global' or 'pwq' (piecewise quadratic)
%                   Lyapunov function should be used in the synthesis
%
% For the nonlinear airfoil model we set 
%
         setting.Lyapunov='global';
%
% This means that PWATOOL uses only global Lyapunov function in controller
% synthesis.
%
pause; %strike any key to continue
clc
% setting.ApxMeth:  shows whether 'ellipsoidal' or 'quadratic' curve
%                   method should be used to approximate the regions.
%
% For the nonlinear airfoil model we don't set this field so that PWATOOL 
% will consider the maximum possibility.
%
% 
pause; %strike any key to continue
clc
% setting.SynthMeth: shows whether 'LMI' or 'BMI' methods should be used.
%
% For the nonlinear airfoil model we don't set this setting.
%
pause; %strike any key to continue
clc
% setting.QLin  :  positive definite matrix of size n x n where n is the 
%                  order of the system. It is used as the LQR parameter
%                  for the region which contains the equilibrium point
%
% The nonlinear airfoil model is of degree 4. We set QLin as follows
%
    setting.QLin= 1.0e+003 *[2.0284    0.5278    0.7951    0.9888
                             0.5278    0.5848    0.6961    0.5005
                             0.7951    0.6961    1.7765    0.9525
                             0.9888    0.5005    0.9525    0.9831];
 
pause; %strike any key to continue
clc
% setting.RLin  :  positive definite matrix of size m x m where m is the 
%                  number of the inputs to the system. It is used as the 
%                  LQR parameter for the region which contains the 
%                  equilibrium point
%
% The nonlinear airfoil model has two inputs. Threfore we set 
%
setting.RLin= 1.0e+003 *[0.1465    0.4483
                         0.4483    1.3900];
%
 
pause; %strike any key to continue
clc
% setting.RandomQ: if set, shows setting.QLin is set randomly by PWATOOL.
%                  If it is zero, PWATOOL keeps the value that user enters
%                  for setting.QLin
%
% For the nonlinear airfoil model we reset this parameters:
%
     setting.RandomQ=0;
%
pause; %strike any key to continue
%
% setting.RandomR: if set, shows setting.RLin is set randomly by PWATOOL.
%                  If it is zero, PWATOOL keeps the value that user enters
%                  for setting.RLin
%
% For the nonlinear airfoil model we reset this parameters:
%
      setting.RandomR=0;
%
pause; %strike any key to continue
clc
% setting.alpha :  specifies the decay rate of the closed-loop system.
%                  Generally, the bigger alpha is the faster the dynamics
%                  of the system will be. However, bigger values of alpha
%                  make the convergence of the controller design harder.
%
% For the nonlinear airfoil dynamics, we set
%
      setting.alpha=.1;
%
pause; %strike any key to continue
clc
% setting.NormalDirectionOnly : specifies if only the normal directions at
%                  the boundaries should meet the continuity constraints.
%                  By default, it would be zero so that the whole
%                  directions are included in the continuity constraints.
%                  In that case, if convergence is obtained, the results are
%                  usually smoother than those obtained by
%                  NormalDirectionOnly set to 1. Please see the PWATOOL
%                  document for a detailed explanation.
%
%
pause; %strike any key to continue
clc
% setting.xcl   :  shows the desired equilibrium point which user sets.
%                  If it is not set by the user, PWATOOL uses the
%                  pwainc.xcl (if exists) as the equilibrium point.
%                  PWATOOL issues an error and stops running if at xcl
%                  we cannot satisfy the equilibrium point equations. 
%                  analytically.
%
% For the nonlinear airfoil model we set
%
      setting.xcl=[0 0 0 0 ]';
%       
pause; %strike any key to continue
clc
% setting.StopTime: shows the simulation time in seconds. If not set by the
%                   user, it will be set to 10 sec.
%
pause; %strike any key to continue
clc
% setting.IterationNumber: shows the maximum number of times that PWATOOL 
%                  tries to synthesize PWA controller if it fails in doing
%                  so in the first try. The default value is 5.
%
%
pause; %strike any key to continue
clc
% Table below shows a summary of setting's fields and their default values
%
% |------------------------------------------------------------------------
% |FIELD            STRUCTURE       SIZE             DEFAULT VALUE
% |------------------------------------------------------------------------
% |ApxMeth          Cell           (1 x 2)           {'ellipsoidal', 'quadratic'}
% |Lyapunov         Cell           (1 x 2)           {'global', 'pwq'}
% |SynthMeth        Cell           (1 x 2)           {'lmi', 'bmi'}
% |QLin             Array          (n x n)           Random QLin>0
% |RLin             Array          (m x m)           Random RLin>0
% |RandomQ          scalar         (1 x 1)           1
% |RandomR          scalar         (1 x 1)           1
% |alpha            scalar         (1 x 1)           0.1
% |xcl              Array          (n x 1)           pwasys.xcl (if exists)
% |StopTime         scalar         (1 x 1)           10 sec
% |IterationNumber  scalar         (1 x 1)           5
% |------------------------------------------------------------------------
%
%
pause; %strike any key to continue
clc
% |-----------------------------------------------------------------------|
% | SSTEP 2: RESULTS AND DUISCUSSIONS
% |-----------------------------------------------------------------------|
%
% Based on the settings that user has chosen for the fields 'Lyapunov', 
% 'ApxMeth' and 'SynthMeth', PWATOOL synthesizes PWA controllers by
% different methods. The current options are:
%
% 1) LMI approach with ellipsoidal approximation     (golabl Lyapunov)
% 2) BMI approach with ellipsoidal approximation     (golabl Lyapunov)
% 3) BMI approach with quadratic curve approximation (golabl Lyapunov)
% 4) BMI approach with ellipsoidal approximation     (pwq Lyapunov)
% 5) BMI approach with quadratic curve approximation (pwq Lyapunov)
%
pause; %strike any key to continue
%
% A variable named 'pwacont' stores the result of the synthesis if at
% least one of the methods among the possibilities converge. In this case
% another variable 'pwasetting' stores the setting that PWATOOL has used
% for the synthesis.
%
% However, if none of the methods, among the possibilities, converge in the
% first try, PWATOOL tries to a maximum of 'IterationNumber' times which by
% default is set to 5. 
%
pause; %strike any key to continue
clc
% Now let's run pwasynth to synthesize PWA controllers for the nonlinear
% airfoil model. We type
% 
% ctrl=pwasynth(pwainc, x0, setting);
% 
pause; %strike any key to continue
%
ctrl=pwasynth(pwainc, x0, setting);
 
pause; %strike any key to continue
clc
% The variable called 'pwacont' contains the PWA controllers:
%
    pwacont
%
pause; %strike any key to continue
clc
% 'pwacont' will contain several fields where each field is itself an 
% array cell, containing the information about he whole methods which have
% converged.
%
% We explain the fields of 'pwacont' in the following:
pause; %strike any key to continue
clc
% pwacont.Gian : contains the controller which has been designed (Kbar), in
%                the aggregated vector space. For example pwacont.Gain{1}
%                will be a cell of size (1 x n) where each element would
%                contain the controller Kbar{i}=[K{i} k{i}] for region R_i
%                (i=1,2,...,NR). 
%
pause; %strike any key to continue
clc
% pwacont.AppMethod:    shows the corresponding approximation method for
%                       pwacont.Gain which would be 'ellipsoidal' or
%                       'quaratic curve'.
%
pause; %strike any key to continue
clc
% pwacont.SynthesisType: shows the corresponding synthesis type for the Gain 
%                        which would be LMI or BMI
%
pause; %strike any key to continue
clc
% pwacont.Lyapunov :     shows the corresponding Lyapunov function type for
%                        the Gain which would be 'global' or 'pwq'.
%
pause; %strike any key to continue
clc
% pwacont.Sprocedure1 and 
% pwacont.Sprocedure2  : shows the corresponding S-procedure coefficients
%                        which PWATOOL has used for each method.
%
pause; %strike any key to continue
clc
% Table below shows a summary of 'pwacont' fields:
%
% |------------------------------------------------------------------------
% |FIELD             STRUCTURE       SIZE          COMMENT
% |------------------------------------------------------------------------
% |Gain              cell           (1 x *)        controller gain
% |AppMethod         cell           (1 x *)        approximation method
% |SynthesiMethod    cell           (1 x *)        synthesis method
% |Lyapunov          cell           (1 x *)        Lyapunov type
% |------------------------------------------------------------------------
%
% *: The size of the cells depend on the number of the methods that
%    converge.
%
pause; %strike any key to continue
clc
pwacont
% we see that two methods have converged:
%
% 1) BMI approach with ellipsoidal approximation     (golabl Lyapunov)
% 2) BMI approach with quadratic curve approximation (golabl Lyapunov)
% 
% This information is obtained from the first four fields of 'pwacont'.
%
pause; %strike any key to continue
clc
% For example, 'pwacont' shows the ellipsoidal approximation, by BMI
% approach and a global Lyapunov function has yielded a PWA controller for
% regions R_i (i=1,2,...,6) in the aggregated vector space y=[x;1] as
% follows:
%
pwacont.Gain{1}{:}
pause; %strike any key to return to the main menu
echo off
 


