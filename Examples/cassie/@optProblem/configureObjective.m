function [obj] = configureObjective(obj, varargin)
    % addCost - register cost function
    %
    % Copyright 2014-2015 Texas A&M University AMBER Lab
    % Author: Ayonga Hereid <ayonga@tamu.edu>
    
    gait_type=varargin{1};
    
    
    obj.nzmaxCost = 0;
    costInfos = cell(obj.nDomain,1);
    
    DOF = 22;  % Degrees of Freedom
    DOA = 10;  % Degrees of Actuation
    M = 5;     % Bezier degree
    NHC = 12;  % Number of holonomic constraints
    
    %% All Domain Costs
    for i=1:obj.nDomain
        
        % Additive torque cost
        obj.domains{i} = addCost(obj.domains{i},'torqueCost',...
            {{'u'}}, 1:obj.domains{i}.nNode);
        
        % Torso Roll & Pitch Deviation cost
        desired = zeros(2*DOF,1);
        weight = zeros(2*DOF,1); weight([4,5,27,28]) = [100;100;10;10];
        selected = zeros(2*DOF,1); selected([4,5,27,28]) = [1;1;1;1];
        extra = [desired; weight; selected].';
        obj.domains{i} = addCost(obj.domains{i},'stateCost',...
            {{'q','dq'}}, 1:obj.domains{i}.nNode, extra);
        
        if gait_type == 'forward_periodic'
            % Hip Abduction & Yaw Deviation cost
            desired = zeros(2*DOF,1);
            weight = zeros(2*DOF,1); weight([8,9,16,17,30,31,38,39]) = [100;100;100;100;10;10;10;10];
            selected = zeros(2*DOF,1); selected([8,9,16,17,30,31,38,29]) = [1;1;1;1;1;1;1;1];
            extra = [desired; weight; selected].';
            obj.domains{i} = addCost(obj.domains{i},'stateCost',...
                {{'q','dq'}}, 1:obj.domains{i}.nNode, extra);
        end
        
        % configure domain structure
        obj.domains{i} = configObjectiveStructure(obj.domains{i},...
            obj.nzmaxCost);
        
        obj.nzmaxCost = obj.nzmaxCost + obj.domains{i}.nzmaxCost;
        costInfos{i} = obj.domains{i}.costArray;
    end
    
    
    obj.costArray = vertcat(costInfos{:});
    nCosts = numel(obj.costArray);
    % construct the row and column indices for the sparse jacobian
    % matrix
    obj.costRows = ones(obj.nzmaxCost,1);
    obj.costCols = ones(obj.nzmaxCost,1);
    for i=1:nCosts
        
        j_index = obj.costArray(i).j_index;
        obj.costCols(j_index) = obj.costArray(i).deps;

    end
end
