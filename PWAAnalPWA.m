clear model pwasys
echo on;
clc
% *************************************************************************
%  ANALYZING A PWA MODEL FOR STABILITY (GLOBAL LYAPUNOV APPROACH)
% *************************************************************************
% 
% PWATOOL can analyze a PWA model to determine if it is stable at a given
% point xcl.
%
% If the PWA model has only one region, i.e. the system is linear, then 
% PWATOOL can definitely determine if the system is stable or unstable. 
%
% However, for the PWA models with more than one region, PWATOOL can only
% determine the model is stable if it finds a Lyapunov function for the
% system. If PWATOOL cannot find such Lyapunov function, the system may
% or may not be stable.
%
% We explain how the system is analyzed for checking stability.
%
pause; %strike any key to continue
clc
%              STABILITY ANALYSIS: A GLOABL LYAPUNOV APPROACH
%
%
% Let a PWA model in regions R_i (i=1,2,...,NR) be described by 
%
%           dx/dt = A{i} x+ a{i}+ B{i} u      x is in region R_i    (*)
% 
% where regions R_i are defined to be 
%
%             R_i = {x | E{i} x + e{i} >= 0 }.    i=1,2,...,NR
%
% (OPTIONAL) Also, let the controller output in each region R_i be
%
%              u=K{i} x +k{i}              if x is in R_i.
%
% NOTE: If controller gains K{i} and k{i} are not defined, the system is
% considered to be open-loop and controller gains K{i} and k{i} will be set
% to zero. Therefore, without loss of generality, in the rest of this 
% section assume K{i} and k{i} are zero if the system is open-loop.
%
pause; %strike any key to continue
clc
% PWATOOL analyzes the system by searching for a global quadratic Lyapunov
% function for the system; PWATOOL searches for a positive definite matrix
% 'Q' that satisfies the following conditions for a constant positive
% scalar 'alpha'. 
%
%
%    1)  V(x)  = x'*Q*x         >0                 for x satisfying (*)
%    2)  dV/dt = d(x' Q x)/dt   <-alpha * V(x)     for x satisfying (*) 
%
% Conditions (1) and (2) amount to the following LMIs:
%
pause; %strike any key to continue
clc
% Reference: B. Samadi and L. Rodrigues. Extension of local linear 
%            controllers to global piecewise affine controllers for uncertain
%            non-linear systems. International Journal of Systems Science,
%            39(9):867-879, 2008.
%
% Let Z{i} be a matrix of proper size with non-negative elements which are
% to be found. Then, the following LMIs are obtained for i=1,2,...,NR.
%
% (1) Q>0
%
% (2) In regions R_i which contain the equilibrium point xcl
%
%     Q*(A{i}+B{i}*K{i})+(A{i}+B{i}*K{i})'*Q+alpha*Q <0
%
%
% (3) In regions R_i which do NOT contain the equilibrium point xcl
%
%     [Q*(A{i}+B{i}*K{i})+(A{i}+B{i}*K{i})'*Q+alpha*Q+E{i}'*Z{i}*E{i}     Q*(a{i}+B{i}*k{i})+E{i}'*Z{i}*e{i};
%     (Q*(a{i}+B{i}*k{i})+E{i}'*Z{i}*e{i})'                                                 e{i}'*Z{i}*e{i}]  < 0
%
pause; %strike any key to continue
clc
% NOTE 1: PWATOOL uses Yalmip to solve above LMIs. A solution, then, may or
%         may not be found by the solver. Since the previous LMIs are
%         sufficient conditions for stability, we can conclude the system is
%         stable only if we find a Q>0 that satisfies above LMIs. In case a
%         matrix Q>0 is not found we may not generally be able to comment
%         on the stability of the system. 
%
pause; %strike any key to continue
clc
% NOTE 2: The regions can also be approximated with ellipsoids which in the
%         case of slab regions they will be degenerate ellipsoids. This 
%         yields to a different set of LMIs which again are sufficient
%         conditions for stability:
%
%         Please hit number 1 in the main PWATOOL menu to learn about
%         approximating a polytopic or slab region with ellipsoids
%
% References: (1) L. Rodrigues and S. Boyd. Piecewise-affine state feedback 
%             for piecewise-affine slab systems using convex optimization. 
%             Systems and Control Letters, 54:835-853, 200
%
%             (2) A. Hassibi and S. Boyd. Quadratic stabilization and
%             control of piecewise-linear systems. Proceedings of the
%             American Control Conference, 6:3659-3664, 1998
% 
%             (3) L. Vandenberghe, S. Boyd, and S.-P. Wu. Determinant
%             maximization with linear matrix inequality constraints. SIAM
%             Journal on Matrix Analysis and Applications,9(2):499-533,1998
%
pause; %strike any key to continue
clc
% To obtain LMIs with ellipsoidal approximation, let 'Elip_i' be the
% ellipsoid that approximates region R_i and is described as follows:
% 
%                Elip_i={x | || EL{i} x + eL{i}|| < 1}
% 
% Also let miu{i} be the negative scalars which are to be found. Then, we
% should satisfy
%
% (1) Q>0
%
% (2) In regions R_i which contain the equilibrium point xcl
%
%     Q*(A{i}+B{i}*K{i})+(A{i}+B{i}*K{i})'*Q+alpha*Q <0
%
%
% (3) In regions R_i which do NOT contain the equilibrium point xcl
%
%     [Q*(A{i}+B{i}*K{i})+(A{i}+B{i}*K{i})'*Q+alpha*Q+miu{i}*EL{i}'*EL{i}        Q*(a{i}+B{i}*k{i})+miu{i}*EL{i}'*eL{i};
%     (Q*(a{i}+B{i}*k{i})+miu{i}*EL{i}'*eL{i})'                                                -miu{i}*(1-eL{i}'*eL{i});]<0
%
%
pause; %strike any key to continue
clc
%          STABILITY ANALYSIS OF A PWA MODEL USING PWATOOL
% 
% We use the nonlinear resistor example (L. Rodrigues and S. Boyd, 2005)
% to show how PWATOOL analyzes a PWA model using a global Lyapunov function.
%
% |-----------------------------------------------------------------------|
% | STEP 0: Creating a PWA model
% |-----------------------------------------------------------------------|
%
% Please hit number 2 in the PWATOOL menu for 'CREATING A PWA MODEL'. 
%
% For the nonlinear resistor example we load the variable 'non_res_pwa'
% 
         load non_res_pwa
%
% by doing so, a variable called 'pwasys' will contain the PWA model of the
% nonlinear resistor.
%
pause; %strike any key to continue
clc
% |-----------------------------------------------------------------------|
% | STEP 1: CHECKING THE STABILITY OF A PWA SYSTEM
% |-----------------------------------------------------------------------|
% 
% To check the stability of the PWA model 'pwasys' at the equilibrium
% point 'xcl', simply, type 
%
%           pwaanalysis(pwasys, setting);         
%
% where setting is a structured variable with the following fields:
%
pause; %strike any key to continue
%
% setting.Lyapunov: shows whether 'global' or 'pwq' (piecewise quadratic)
%                   Lyapunov function should be used in the analysis
%
% For the nonlinear resistor model we set 
%
      setting.Lyapunov='global';
%
% This means that PWATOOL uses only global Lyapunov function in analysis.
%
pause; %strike any key to continue
clc
% setting.ApxMeth:  shows whether 'ellipsoidal' or 'quadratic' curve
%                   method should be used to approximate the regions.
%
% For the PWA model we don't set this field so that it takes the default
% value {'quadratic', 'ellipsoidal'}.
%
pause; %strike any key to continue
%
% setting.alpha :  specifies the decay rate in finding the Lyapunov function.
%                  Generally, bigger values of alpha make the convergence 
%                  harder.
%
% For the nonlinear resistor model, we set
%
      setting.alpha=.1;
%
pause; %strike any key to continue
clc
% setting.xcl   :  shows the desired equilibrium point which user sets.
%                  If it is not set by the user, PWATOOL uses the
%                  pwainc.xcl (if exists) as the equilibrium point.
%                  PWATOOL issues an error and stops running if xcl is not
%                  defined or if at xcl we cannot satisfy the equilibrium
%                  point equations analytically.
%
% For the nonlinear resistor model, we set
%
     setting.xcl=[0.371428571428570;
                  0.642857142857146];
%
% We call 'pwaanalysis' to analyze the stability of the model at xcl
%
pause; %strike any key to continue
%
       pwaanalysis(pwasys, setting);
%
% 
% We, next, discuss the analysis result.
%
pause; %strike any key to continue
clc
% |-----------------------------------------------------------------------|
% | STEP 2: RESULTS AND DUISCUSSIONS
% |-----------------------------------------------------------------------|
%
%             CASE A: THE PWA SYSTEM HAS ONLY ONE REGION 
%
% In this case if a positive definite matrix Q is found the system is
% stable; otherwise the system is unstable
%
pause; %strike any key to continue
%
%           CASE B: THE PWA SYSTEM HAS MORE THAN ONE REGION
%
% In this case we can only say the system is stable if a positive definite
% matrix Q is found; otherwise we cannot comment on the stability of the
% system.
%
pause; %strike any key to continue
clc
% In nonlinear resistor example, the message
% "I could not verify if the open-loop PWA system is stable at xcl."
% implies that LMIs have not been able to find a matrix Q>0 that solves
% the LMIs. Therefore, the open-loop equilibrium point xcl above may or may
% not be an equilibrium point for the system.
%
% Let us see if the model can be stabilized by a controller.
%
pause; %strike any key to continue
clc
% |-----------------------------------------------------------------------|
% | STEP 2: FORMATS OF CALLING PWAANALYSIS
% |-----------------------------------------------------------------------|
%
% pwaanalysis can also be called by three inputs as follows.
%
%        pwaanalysis(pwasys, setting, gain);
% 
% In this format, 'gain' should be the control gain Kbar (please hit
% number 1 in the main menu of PWATOOL to learn about Kbar).
%
% We use a stabilizing gain Kbar to check this option
%
pause; %strike any key to continue
%
        load Kbar
%
% Now, let's analyze pwasys around xcl one more time; this time the loop is
% closed through the gain Kbar
%
pause; %strike any key to continue
%
        pwaanalysis(pwasys, setting, Kbar);
%         
pause; %strike any key to continue
%
% The message "The closed-loop PWA system is stable at xcl." shows PWATOOL
% has been successful in finding a matrix Q>0 for solving the LIMs and
% hance the closed-loop system is stable around xcl.
%
pause; %strike any key to continue
clc
% 'pwanalysis' also produces an output which is 1, whenever it has verified
% the stability of the system at a given point xcl. Therefore, the
% following formats in calling pwaanalysis are valid:
%
%  Y = pwaanalysis(pwasys, setting); 
%  Y = pwaanalysis(pwasys, setting, gain); 
%
pause; %strike any key to return to the main menu
echo off
 


