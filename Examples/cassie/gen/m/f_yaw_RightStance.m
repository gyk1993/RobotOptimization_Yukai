function out1 = f_yaw_RightStance(in1,yaw_des)
%F_YAW_RIGHTSTANCE
%    OUT1 = F_YAW_RIGHTSTANCE(IN1,YAW_DES)

%    This function was generated by the Symbolic Math Toolbox version 7.0.
%    12-Apr-2017 18:27:25

q6 = in1(:,6);
out1 = q6-yaw_des;
