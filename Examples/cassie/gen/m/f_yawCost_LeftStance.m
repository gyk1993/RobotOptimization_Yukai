function out1 = f_yawCost_LeftStance(in1,weight)
%F_YAWCOST_LEFTSTANCE
%    OUT1 = F_YAWCOST_LEFTSTANCE(IN1,WEIGHT)

%    This function was generated by the Symbolic Math Toolbox version 7.0.
%    12-Apr-2017 18:28:47

q9 = in1(:,9);
q17 = in1(:,17);
out1 = weight.*(q9.^2+q17.^2);
