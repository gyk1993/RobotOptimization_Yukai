function out1 = f_swingFootVelocity_LeftStance(in1,in2)
%F_SWINGFOOTVELOCITY_LEFTSTANCE
%    OUT1 = F_SWINGFOOTVELOCITY_LEFTSTANCE(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 7.0.
%    01-Apr-2017 10:02:02

s1 = in2(:,1);
s2 = in2(:,2);
s3 = in2(:,3);
vFoot1 = in1(:,1);
vFoot2 = in1(:,2);
vFoot3 = in1(:,3);
out1 = [s1.*vFoot1;s2.*vFoot2;s3.*vFoot3];