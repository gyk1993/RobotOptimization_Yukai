function out1 = f_flatSwingFoot_RightStance(in1)
%F_FLATSWINGFOOT_RIGHTSTANCE
%    OUT1 = F_FLATSWINGFOOT_RIGHTSTANCE(IN1)

%    This function was generated by the Symbolic Math Toolbox version 7.0.
%    01-Apr-2017 10:02:27

pFoot9 = in1(:,9);
pFoot12 = in1(:,12);
out1 = pFoot9-pFoot12;