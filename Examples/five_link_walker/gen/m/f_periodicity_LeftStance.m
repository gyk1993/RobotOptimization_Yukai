function out1 = f_periodicity_LeftStance(in1)
%F_PERIODICITY_LEFTSTANCE
%    OUT1 = F_PERIODICITY_LEFTSTANCE(IN1)

%    This function was generated by the Symbolic Math Toolbox version 7.0.
%    30-Mar-2017 15:28:48

dq1_1 = in1(:,8);
dq1_2 = in1(:,9);
dq1_3 = in1(:,10);
dq1_4 = in1(:,11);
dq1_5 = in1(:,12);
dq1_6 = in1(:,13);
dq1_7 = in1(:,14);
dq2_1 = in1(:,22);
dq2_2 = in1(:,23);
dq2_3 = in1(:,24);
dq2_4 = in1(:,25);
dq2_5 = in1(:,26);
dq2_6 = in1(:,27);
dq2_7 = in1(:,28);
q1_3 = in1(:,3);
q1_4 = in1(:,4);
q1_5 = in1(:,5);
q1_6 = in1(:,6);
q1_7 = in1(:,7);
q2_3 = in1(:,17);
q2_4 = in1(:,18);
q2_5 = in1(:,19);
q2_6 = in1(:,20);
q2_7 = in1(:,21);
out1 = [0.0;0.0;-q1_3+q2_3;-q1_4+q2_6;-q1_5+q2_7;-q1_6+q2_4;-q1_7+q2_5;-dq1_1+dq2_1;-dq1_2+dq2_2;-dq1_3+dq2_3;-dq1_4+dq2_6;-dq1_5+dq2_7;-dq1_6+dq2_4;-dq1_7+dq2_5];
