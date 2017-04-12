function out1 = f_holConstrPosition_fourbar(in1)
%F_HOLCONSTRPOSITION_FOURBAR
%    OUT1 = F_HOLCONSTRPOSITION_FOURBAR(IN1)

%    This function was generated by the Symbolic Math Toolbox version 7.0.
%    12-Apr-2017 18:21:54

h1 = in1(:,23);
h2 = in1(:,24);
q11 = in1(:,11);
q13 = in1(:,13);
q19 = in1(:,19);
q21 = in1(:,21);
out1 = [-h1+q11+q13-pi.*(1.3e1./1.8e2);-h2+q19+q21-pi.*(1.3e1./1.8e2)];
