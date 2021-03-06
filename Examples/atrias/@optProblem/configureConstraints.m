function [obj] = configureConstraints(obj, varargin)
    % configureConstraints - register constraints
    %
    % Copyright 2014-2015 Texas A&M University AMBER Lab
    % Author: Ayonga Hereid <ayonga@tamu.edu>
    constraints = cell(obj.nDomain,1);
    
    DOF = 16; % Degrees of Freedom
    DOA = 6;  % Degrees of Actuation
    M = 5;    % Bezier degree
    NHC = 7;  % Number of holonomic constraints
    
    %% Unique Contraints 
    
    % Store useful domain names
    RightStance = obj.domains{1};
    LeftStance = obj.domains{2};

    %% Right Stance
    
    % Initialize h to 0
    RightStance = addConstraint(RightStance,'Nonlinear-Equality',...
        'h0', NHC, 1, {{'h'}},-5e-4,5e-4);
    
    % Initialize yaw to 0
    RightStance = addConstraint(RightStance,'Nonlinear-Equality',...
        'yaw', 1, 1, {{'q'}},-5e-4,5e-4);
        
    %% Left Stance
    
    % Initialize state
    deps_1 = RightStance.optVarIndices.qend(end,:);
    deps_2 = LeftStance.optVarIndices.q(1,:);
    LeftStance = addConstraint(LeftStance,'Inter-Domain-Nonlinear',...
        'qCont',DOF,1,{deps_1,deps_2},-5e-4,5e-4);
    deps_1 = RightStance.optVarIndices.dqend(end,:);
    deps_2 = LeftStance.optVarIndices.dq(1,:);
    LeftStance = addConstraint(LeftStance,'Inter-Domain-Nonlinear',...
        'qCont',DOF,1,{deps_1,deps_2},-5e-4,5e-4);
    
    % Periodicity
    selected = ones(1,DOF); selected(1:3) = 0;
    deps_1 = LeftStance.optVarIndices.qend(end,:);
    deps_2 = RightStance.optVarIndices.q(1,:);
    LeftStance = addConstraint(LeftStance,'Inter-Domain-Nonlinear',...
        'qContSelected',DOF,1,{deps_1,deps_2},-5e-4,5e-4,selected);
    selected = ones(1,DOF); 
    deps_1 = LeftStance.optVarIndices.dqend(end,:);
    deps_2 = RightStance.optVarIndices.dq(1,:);
    LeftStance = addConstraint(LeftStance,'Inter-Domain-Nonlinear',...
        'qContSelected',DOF,1,{deps_1,deps_2},-5e-4,5e-4,selected);

    %% Store the modified domains back into the original variables
    obj.domains{1} = RightStance;
    obj.domains{2} = LeftStance;
    
    % register constraints
    for i=1:obj.nDomain
        domain = obj.domains{i};
        
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
            'footPosition',6,1:domain.nNode,...
            {{'q','pFoot'}},-5e-4,5e-4);     
        
        % feet velocities
        domain = addConstraint(domain,'Nonlinear-Equality',...
            'footVelocity',6,1:domain.nNode,...
            {{'q','dq','vFoot'}},-5e-4,5e-4);    
        
        %  Guard Ground Slope
        groundHeight = 0;
        domain = addConstraint(domain,'Nonlinear-Equality',...
            'guard_groundHeight',1,domain.nNode,{{'pFoot'}},-5e-4,5e-4,groundHeight);
        
        %% Physical Constraints
        
        % Ground Reaction Force
        mu = 0.5;
        domain = addConstraint(domain,'Nonlinear-Inequality',...
            'GRF',1,1:domain.nNode,{{'Fe'}},-Inf,0,mu);
        
        % Average Step Velocity
        velocity = [0,0];
        deps_1 = domain.optVarIndices.q(1,:);
        deps_2 = domain.optVarIndices.qend(end,:);
        deps_3 = domain.optVarIndices.t(end,:);
        domain = addConstraint(domain,'Inter-Domain-Nonlinear',...
            'averageStepVelocity',2,domain.nNode,...
            {deps_1,deps_2,deps_3},-5e-4,5e-4,velocity);

        % Knee Angles
        domain = addConstraint(domain,'Nonlinear-Inequality',...
            'stanceKneeAngle',1,1:domain.nNode,{{'q'}},deg2rad(50),deg2rad(85));
        domain = addConstraint(domain,'Nonlinear-Inequality',...
            'swingKneeAngle',1,1:domain.nNode,{{'q'}},deg2rad(50),deg2rad(85));
        
        % Swing Foot Retraction - y
        selected = [0,1,0];
        if velocity(2) >= 0
            domain = addConstraint(domain,'Nonlinear-Inequality',...
                'swingFootVelocity',3,domain.nNode-2:domain.nNode,{{'vFoot'}},-1,0,selected);
        elseif velocity(2) < 0
            domain = addConstraint(domain,'Nonlinear-Inequality',...
                'swingFootVelocity',3,domain.nNode-2:domain.nNode,{{'vFoot'}},0,1,selected);
        end

        % Make sure z foot velocity at end of step isnt too high
        selected = [0,0,1];
        domain = addConstraint(domain,'Nonlinear-Inequality',...
            'swingFootVelocity',3,domain.nNode-1:domain.nNode,{{'vFoot'}},-0.5,0,selected);
            
        % Ground Height Foot Clearance
        groundHeight = 0;
        domain = addConstraint(domain,'Nonlinear-Inequality',...
            'guard_groundHeight',1,1:domain.nNode,{{'pFoot'}},-5e-4,Inf,groundHeight);
        
        % Mid Foot Clearance
        groundHeight = 0;
        footClearance = 0.1;
        domain = addConstraint(domain,'Nonlinear-Inequality',...
            'guard_groundHeight',1,ceil(domain.nNode/2),{{'pFoot'}},footClearance-0.01,footClearance+0.01,groundHeight);

        
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
        
        obj.domains{i} = domain;

    end
    
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