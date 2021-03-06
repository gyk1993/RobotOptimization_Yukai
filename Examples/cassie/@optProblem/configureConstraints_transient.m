function [obj] = configureConstraints(obj, varargin)
    % configureConstraints - register constraints
    %
    % Copyright 2014-2015 Texas A&M University AMBER Lab
    % Author: Ayonga Hereid <ayonga@tamu.edu>
    constraints = cell(obj.nDomain,1);
    
    DOF = 22;  % Degrees of Freedom
    DOA = 10;  % Degrees of Actuation
    M = 5;     % Bezier degree
    NHC = 12;  % Number of holonomic constraints

    domains = obj.domains;
    
    
    
    %% begin at perturbed velocity, end at desired velocity.
    load('0ms_1.mat')
    x_0   = [outputs{1}.q(1,1:22), outputs{1}.dq(1,1:22)]';
    load('0ms_1.mat')
    x_end = [outputs{1}.q(end,1:22), outputs{1}.dq(end,1:22)]';
    
    selected=ones(2*DOF,1);
    extra=[selected;x_0]';
    domains{1} = addConstraint(domains{1},'Nonlinear-Equality',...
        'xConstrainExternal',2*DOF,1,{{'q','dq'}},-5e-4,5e-4,extra);
    selected=ones(2*DOF,1);selected([1,2,3])=0;
    extra=[selected;x_end]';
    domains{obj.nDomain} = addConstraint(domains{obj.nDomain},'Nonlinear-Equality',...
        'xConstrainExternal',2*DOF,domains{obj.nDomain}.nNode,{{'q','dq'}},-5e-4,5e-4,extra);

    %% Right Stance
    
    % Initialize h to 0
    h0_des = zeros(1,NHC);
    domains{1} = addConstraint(domains{1},'Nonlinear-Equality',...
        'h0', NHC, 1, {{'h'}},-5e-4,5e-4,h0_des);
    
    % Initialize yaw to 0
    yaw_des = 0;
    domains{1} = addConstraint(domains{1},'Nonlinear-Equality',...
        'yaw', 1, 1, {{'q'}},-5e-4,5e-4,yaw_des);
    
        
    
    %% connect domains together
    for i=1:obj.nDomain-1
        deps_1 = domains{i}.optVarIndices.qend(end,:);
        deps_2 = domains{i+1}.optVarIndices.q(1,:);
        domains{2} = addConstraint(domains{2},'Inter-Domain-Nonlinear',...
            'qCont',DOF,1,{deps_1,deps_2},-5e-4,5e-4);
        deps_1 = domains{i}.optVarIndices.dqend(end,:);
        deps_2 = domains{i+1}.optVarIndices.dq(1,:);
        domains{2} = addConstraint(domains{2},'Inter-Domain-Nonlinear',...
            'qCont',DOF,1,{deps_1,deps_2},-5e-4,5e-4);
    end

    % register constraints
    
    
    for i=1:obj.nDomain
        domain = domains{i};
        
        %% Dynamics
        
        % dynamics equation: D*ddq + H(q,dq) + F_spring - Be*u - J^T(q)*Fe = 0;
        domain = addConstraint(domain,'Nonlinear-Equality',...
            'dynamics',DOF,1:domain.nNode,...
            {{'q','dq','ddq','u','Fe'}},-5e-4,5e-4);
        
        % holonomic constraint (position level): h(q) - hd = 0;
        domain = addConstraint(domain,'Nonlinear-Equality',...
            'holonomicPos',NHC,1,...
            {{'q','h'}},-5e-4,5e-4);
        
        % holonomic constraint (velocity level): J(q)dq = 0;
        domain = addConstraint(domain,'Nonlinear-Equality',...
            'holonomicVel',NHC,1,...
            {{'q','dq'}},-5e-4,5e-4);
       
        % holonomic constraint (acceleration level):
        % J(q)ddq + Jdot(q,dq)dq = 0;
        domain = addConstraint(domain,'Nonlinear-Equality',...
            'holonomicAccel',NHC,1:domain.nNode,...
            {{'q','dq','ddq'}},-5e-4,5e-4);
        
        %  Impact 
        % D(dq_end - dq) - J'*Fimp = 0
        % J*dq = 0
        domain = addConstraint(domain,'Nonlinear-Equality',...
            'impact',DOF+NHC,domain.nNode,{{'q','dq','Fimp','dqend'}},-5e-4,5e-4);
        
        % qend - q = 0
        domain = addConstraint(domain,'Nonlinear-Equality',...
            'qCont',DOF,domain.nNode,{{'q','qend'}},-5e-4,5e-4);
        
        % feet positions
        domain = addConstraint(domain,'Nonlinear-Equality',...
            'footPosition',12,1:domain.nNode,...
            {{'q','pFoot'}},-5e-4,5e-4);     
        
        % feet velocities
        domain = addConstraint(domain,'Nonlinear-Equality',...
            'footVelocity',12,1:domain.nNode,...
            {{'q','dq','vFoot'}},-5e-4,5e-4);    
        
        % Guard - ground height
        groundHeight = 0.0*i;
        domain = addConstraint(domain,'Nonlinear-Equality',...
            'guard_groundHeight',2,domain.nNode,{{'pFoot'}},-5e-4,5e-4,groundHeight);
        
        %% Physical Constraints
        
        % Flat Swing Foot
        domain = addConstraint(domain,'Nonlinear-Equality',...
            'flatSwingFoot',1,1:domain.nNode,{{'pFoot'}},-5e-4,5e-4);
        
        % Ground Reaction Force
        mu = 0.7;
        domain = addConstraint(domain,'Nonlinear-Inequality',...
            'GRF',2,1:domain.nNode,{{'Fe'}},-Inf,0,mu);

        % 2 * Mid step length ==  step length (helps keep the leg angles from moving for no reason)
        selected = [1, 1, 0];
        extra = [selected];
        deps_1 = domain.optVarIndices.pFoot(1,:);
        deps_2 = domain.optVarIndices.pFoot(ceil(end/2),:);
        deps_3 = domain.optVarIndices.pFoot(end,:);
        domain = addConstraint(domain,'Inter-Domain-Nonlinear',...
            'halfwayStepLength',3,domain.nNode,{deps_1,deps_2,deps_3},-1e-1,1e-1,extra);

        % Swing Foot velocity
%         selected = [1,0,0];
%         if velocity(1) > 0
%             domain = addConstraint(domain,'Nonlinear-Inequality',...
%                 'swingFootVelocity',3,domain.nNode-2:domain.nNode,{{'vFoot'}},-5,0,selected);
%         elseif velocity(1) < 0
%             domain = addConstraint(domain,'Nonlinear-Inequality',...
%                 'swingFootVelocity',3,domain.nNode-2:domain.nNode,{{'vFoot'}},0,5,selected);
%         end
        
        % Base to stanceFoot height (we don't want knees extended too much)
        domain = addConstraint(domain,'Nonlinear-Inequality',...
            'base2stanceHeight',1,1:domain.nNode,{{'q','pFoot'}},0.5, 1.0);
        
        % Foot width (keeps feet from being too close together)
        domain = addConstraint(domain,'Nonlinear-Inequality',...
            'footWidth',2,1:domain.nNode,{{'pFoot'}},0.25, 0.3);

        % Ground Height Foot Clearance
%         domain = addConstraint(domain,'Nonlinear-Inequality',...
%             'guard_groundHeight',2,1:domain.nNode,{{'pFoot'}},-5e-4,Inf,groundHeight);
        
        % Mid Foot Clearance
        footClearance = 0.15;
        domain = addConstraint(domain,'Nonlinear-Inequality',...
            'guard_groundHeight',2,ceil(domain.nNode/2),{{'pFoot'}},footClearance-0.01,footClearance+0.01,groundHeight);

        
        %% Time Based Virtual Constraints
        nodeList = 1:domain.nNode;
        for j = nodeList
            extra = [domain.nNode,j];

            if j == 1
                % y = 0
                domain = addConstraint(domain,'Nonlinear-Equality',...
                    'y_timeBased',DOA,j,...
                    {{'q','t','a'}},-5e-4,5e-4,extra);

                % dy = 0
                domain = addConstraint(domain,'Nonlinear-Equality',...
                    'dy_timeBased',DOA,j,...
                    {{'q','dq','t','a'}},-5e-4,5e-4,extra);
            end
            
            % ddy = 0
            epsilon = 10;
            extra = [domain.nNode, j, epsilon^2, 2*epsilon, ];
            domain = addConstraint(domain,'Nonlinear-Equality',...
                'ddy_timeBased',DOA,j,...
                {{'q','dq','ddq','t','a'}},-5e-4,5e-4,extra);
        end

        
        %% Parameter Continuity
       
        % bezier parameter continuity
        domain = addConstraint(domain,'Linear-Equality',...
            'aCont',DOA*(M+1),1:(domain.nNode-1),...
            {{'a'},{'a'}},-5e-4,5e-4);
        
        % holonimic constraints continuity
        domain = addConstraint(domain,'Linear-Equality',...
            'hCont',NHC,1:(domain.nNode-1),...
            {{'h'},{'h'}},-5e-4,5e-4);

        % Step Time Continuity
        domain = addConstraint(domain,'Linear-Equality',...
            'timeCont',1,1:domain.nNode-1,...
            {{'t'},{'t'}},-5e-4,5e-4);
        

       %% Integration Scheme 
        
        switch obj.options.IntegrationScheme
            case 'Trapezoidal'
                nodeList = 1:1:domain.nNode-1;
                extra = domain.nNode;
                for j = nodeList                    
                    domain = addConstraint(domain,'Nonlinear-Equality',...
                        'intTrapPos',DOF,j,...
                        {{'t','q','dq'},{'q','dq'}},0,0,extra);
                    
                    domain = addConstraint(domain,'Nonlinear-Equality',...
                        'intTrapVel',DOF,j,...
                        {{'t','dq','ddq'},{'dq','ddq'}},0,0,extra);
                end
                
            case 'HermiteSimpson'
                nodeList = 1:2:domain.nNode-2;
                extra = (domain.nNode+1)/2;
                for j = nodeList
                    domain = addConstraint(domain,'Nonlinear-Equality',...
                        'intPos',DOF,j,...
                        {{'t','q','dq'},{'dq'},{'q','dq'}},0,0,extra);
                    
                    domain = addConstraint(domain,'Nonlinear-Equality',...
                        'intVel',DOF,j,...
                        {{'t','dq','ddq'},{'ddq'},{'dq','ddq'}},0,0,extra);
                    
                    domain = addConstraint(domain,'Nonlinear-Equality',...
                        'midPointPos',DOF,j,...
                        {{'t','q','dq'},{'q'},{'q','dq'}},0,0,extra);
                    
                    domain = addConstraint(domain,'Nonlinear-Equality',...
                        'midPointVel',DOF,j,...
                        {{'t','dq','ddq'},{'dq'},{'dq','ddq'}},0,0,extra);
                end
                
            otherwise
                error('Unknown Integration Scheme')
        end

 
        %% Configure Contraint Structure and Update Opt Problem
        
        % configure domain structure
        domain = configConstrStructure(domain,...
            obj.dimsConstr,obj.nzmaxConstr);

        constraints{i} = domain.constrArray;
        % update the dimension of constraints and jacobian
        obj.dimsConstr = obj.dimsConstr + domain.dimsConstr;

        obj.nzmaxConstr= obj.nzmaxConstr + domain.nzmaxConstr;
        
        domains{i} = domain;

    end
    
    obj.domains = domains;
    
    obj.constrArray = vertcat(constraints{:});
    nConstr = numel(obj.constrArray);
    
    

    % generate entry structure for sparse jacobian matrix
    obj.constrRows = ones(obj.nzmaxConstr,1);
    obj.constrCols = ones(obj.nzmaxConstr,1);
    constr_lb         = zeros(obj.dimsConstr,1);
    constr_ub         = zeros(obj.dimsConstr,1);
    for i=1:nConstr
        % get dimension of the constraint dimension
        dims = obj.constrArray(i).dims;
        indices = obj.constrArray(i).c_index;
        % get jacobian entry indices
        j_index = obj.constrArray(i).j_index;
        
        % get number of dependent variables
        deps = obj.constrArray(i).deps;
        num_deps = numel(deps);
        
        % rows (i)
        obj.constrRows(j_index,1) = reshape(indices*ones(1,num_deps),...
            [numel(j_index),1]);
        % columns (j)
        obj.constrCols(j_index,1) = reshape(ones(dims,1)*deps,...
            [numel(j_index),1]);
        
        
        % constraints bound
        constr_lb(indices,1) = obj.constrArray(i).cl;
        constr_ub(indices,1) = obj.constrArray(i).cu;
    end
    
    obj.cl = constr_lb;
    obj.cu = constr_ub;
    
    
end