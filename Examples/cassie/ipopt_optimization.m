%% Direct Collocation Based Optimization
restoredefaultpath;
clear; close all; clc;
MODEL_PATH = '..\..\..\Model-Generator\models\cassie';
IPOPT_PATH = '..\..\..\lib\ipopt';
set_paths(MODEL_PATH,IPOPT_PATH);
addpath(genpath('..\..\..\RobotAnimator'))

% Load optimization problem
optName = 'cassie'
opt = loadOptProblem(optName);
opt.options

% add optimization variables
opt = configureOptVariables(opt);

% generate optimization boundaries
opt = genBoundaries(opt);

% generate initial guess
opt = generateZ0(opt); 

% add constraints
opt = configureConstraints(opt);

% add cost function
opt = configureObjective(opt);

% Get Initial Condition
x0 = opt.Z0;
old = load('x0'); x0 = old.x;% + 0.01*rand(size(old.x));

%% Solve Optimization Problem
debugMode = false;

% % IPOPT options
options.lb = opt.lb;
options.ub = opt.ub;
options.cl = opt.cl;
options.cu = opt.cu;

options.ipopt.mu_strategy      = 'adaptive';
options.ipopt.max_iter         = 5000;
options.ipopt.tol              = 1e2;
%     disp(['max iterations = ', num2str(options.ipopt.max_iter)])
%     disp(['tolerance = ', num2str(options.ipopt.tol)])

options.ipopt.dual_inf_tol           = 1e2;
options.ipopt.constr_viol_tol        = 1e-4;
options.ipopt.compl_inf_tol          = 1e2;

%options.acceptable_tol  = 1e3;
%options.acceptable_compl_inf_tol    = 1e0;

% check_derivatives_for_naninf  = 'yes';

options.ipopt.hessian_approximation = 'limited-memory';
options.ipopt.limited_memory_update_type = 'bfgs';  % {bfgs}, sr
options.ipopt.limited_memory_max_history = 50;  % {6}
options.ipopt.recalc_y = 'yes';
options.ipopt.recalc_y_feas_tol = 1e-3;

%options.ipopt.bound_relax_factor = 1e-3;
options.ipopt.linear_solver = 'ma57';
options.ipopt.fixed_variable_treatment = 'RELAX_BOUNDS';
% options.ipopt.derivative_test = 'first-order';
options.ipopt.point_perturbation_radius = 0;
options.ipopt.bound_push = 0.000001;

% options.ipopt.derivative_test_perturbation = 1e-8;
% options.ipopt.derivative_test_print_all = 'yes';
options.ipopt.ma57_automatic_scaling = 'no';
options.ipopt.linear_scaling_on_demand = 'no';
% The callback functions.
funcs.objective    = @(x)IpoptObjective(x, opt.costArray, opt.constrArray, debugMode);
funcs.constraints  = @(x)IpoptConstraints(x, opt.constrArray, opt.dimsConstr, debugMode);
funcs.gradient     = @(x)IpoptGradient(x, opt.costArray, ...
    opt.costRows, opt.costCols, opt.nOptVar, debugMode);
funcs.jacobian     = @(x)IpoptJacobian(x, opt.dimsConstr, ...
    opt.constrArray, opt.constrRows, opt.constrCols, opt.nOptVar, debugMode);
funcs.jacobianstructure = @()IpoptJacobianStructure(opt.dimsConstr, ...
    opt.constrRows, opt.constrCols, opt.nOptVar, debugMode);
% funcs.hessian           = @hessian;
% funcs.hessianstructure  = @hessianstructure;

% Start optimization
tic
[x, info] = ipopt(x0,funcs,options);
toc

% Construct outputs
[outputs] = getOptOutput(opt.domains, x)

%% Animation
positions_function = @positions;
t_log = [linspace(0,outputs{1}.t(end),length(outputs{1}.t)), outputs{1}.t(end) + linspace(0,outputs{2}.t(end),length(outputs{2}.t))];
q_log = [outputs{1}.q;outputs{2}.q]';

f = figure;
anim = CassieAnimator(t_log, q_log, @positions);
anim.isLooping = false;
anim.updateWorldPosition = true;
anim.endTime = 20;
conGUI = Animator.AnimatorControls();
conGUI.anim = anim;
anim.pov = Animator.AnimatorPointOfView.Free;
anim.speed = 1;
anim.Animate(true);

% %% Get played trajectory
% [q_all, t_all] = anim.ReturnTrajectory();


