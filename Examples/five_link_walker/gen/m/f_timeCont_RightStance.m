function out1 = f_timeCont_RightStance(in1)
%F_TIMECONT_RIGHTSTANCE
%    OUT1 = F_TIMECONT_RIGHTSTANCE(IN1)

%    This function was generated by the Symbolic Math Toolbox version 7.0.
%    30-Mar-2017 15:25:59

T1 = in1(:,1);
T2 = in1(:,2);
out1 = T1-T2;
