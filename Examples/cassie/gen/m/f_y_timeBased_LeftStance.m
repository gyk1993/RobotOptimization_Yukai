function out1 = f_y_timeBased_LeftStance(in1,in2)
%F_Y_TIMEBASED_LEFTSTANCE
%    OUT1 = F_Y_TIMEBASED_LEFTSTANCE(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 7.0.
%    12-Apr-2017 18:26:33

N = in2(:,1);
a_1_1 = in1(:,24);
a_1_2 = in1(:,34);
a_1_3 = in1(:,44);
a_1_4 = in1(:,54);
a_1_5 = in1(:,64);
a_1_6 = in1(:,74);
a_2_1 = in1(:,25);
a_2_2 = in1(:,35);
a_2_3 = in1(:,45);
a_2_4 = in1(:,55);
a_2_5 = in1(:,65);
a_2_6 = in1(:,75);
a_3_1 = in1(:,26);
a_3_2 = in1(:,36);
a_3_3 = in1(:,46);
a_3_4 = in1(:,56);
a_3_5 = in1(:,66);
a_3_6 = in1(:,76);
a_4_1 = in1(:,27);
a_4_2 = in1(:,37);
a_4_3 = in1(:,47);
a_4_4 = in1(:,57);
a_4_5 = in1(:,67);
a_4_6 = in1(:,77);
a_5_1 = in1(:,28);
a_5_2 = in1(:,38);
a_5_4 = in1(:,58);
a_5_5 = in1(:,68);
a_5_6 = in1(:,78);
a_6_1 = in1(:,29);
a_6_2 = in1(:,39);
a_6_4 = in1(:,59);
a_6_5 = in1(:,69);
a_6_6 = in1(:,79);
a_7_1 = in1(:,30);
a_7_2 = in1(:,40);
a_7_4 = in1(:,60);
a_7_5 = in1(:,70);
a_7_6 = in1(:,80);
a_8_1 = in1(:,31);
a_8_2 = in1(:,41);
a_8_4 = in1(:,61);
a_8_5 = in1(:,71);
a_8_6 = in1(:,81);
a_9_1 = in1(:,32);
a_9_2 = in1(:,42);
a_9_4 = in1(:,62);
a_9_5 = in1(:,72);
a_9_6 = in1(:,82);
a_10_1 = in1(:,33);
a_10_2 = in1(:,43);
a_10_4 = in1(:,63);
a_10_5 = in1(:,73);
a_10_6 = in1(:,83);
index = in2(:,2);
q8 = in1(:,8);
q9 = in1(:,9);
q10 = in1(:,10);
q11 = in1(:,11);
q16 = in1(:,16);
q17 = in1(:,17);
q18 = in1(:,18);
q19 = in1(:,19);
q22 = in1(:,22);
t5 = N-1.0;
t6 = index-1.0;
t9 = 1.0./t5;
t10 = t6.*t9;
t2 = t10-1.0;
t3 = t2.^2;
t4 = t3.^2;
t7 = t6.^2;
t8 = t7.^2;
t11 = 1.0./t5.^5;
t12 = t6.*t9.*5.0;
t13 = t12-5.0;
t14 = 1.0./t5.^4;
t15 = 1.0./t5.^2;
t16 = 1.0./t5.^3;
out1 = [q8+a_1_1.*t2.*t4-a_2_1.*t4.*t6.*t9.*5.0+a_5_1.*t8.*t13.*t14-a_6_1.*t6.*t8.*t11+a_3_1.*t2.*t3.*t7.*t15.*1.0e1-a_4_1.*t3.*t6.*t7.*t16.*1.0e1;q9+a_7_1.*t2.*t4+a_1_2.*t8.*t13.*t14-a_2_2.*t6.*t8.*t11-a_8_1.*t4.*t6.*t9.*5.0+a_9_1.*t2.*t3.*t7.*t15.*1.0e1-a_10_1.*t3.*t6.*t7.*t16.*1.0e1;q10+a_3_2.*t2.*t4-a_4_2.*t4.*t6.*t9.*5.0+a_7_2.*t8.*t13.*t14-a_8_2.*t6.*t8.*t11+a_5_2.*t2.*t3.*t7.*t15.*1.0e1-a_6_2.*t3.*t6.*t7.*t16.*1.0e1;q11+a_9_2.*t2.*t4+a_3_3.*t8.*t13.*t14-a_4_3.*t6.*t8.*t11-a_10_2.*t4.*t6.*t9.*5.0+a_1_3.*t2.*t3.*t7.*t15.*1.0e1-a_2_3.*t3.*t6.*t7.*t16.*1.0e1;0.0;q16+a_1_4.*t2.*t4-a_2_4.*t4.*t6.*t9.*5.0+a_5_4.*t8.*t13.*t14-a_6_4.*t6.*t8.*t11+a_3_4.*t2.*t3.*t7.*t15.*1.0e1-a_4_4.*t3.*t6.*t7.*t16.*1.0e1;q17+a_7_4.*t2.*t4+a_1_5.*t8.*t13.*t14-a_2_5.*t6.*t8.*t11-a_8_4.*t4.*t6.*t9.*5.0+a_9_4.*t2.*t3.*t7.*t15.*1.0e1-a_10_4.*t3.*t6.*t7.*t16.*1.0e1;q18+a_3_5.*t2.*t4-a_4_5.*t4.*t6.*t9.*5.0+a_7_5.*t8.*t13.*t14-a_8_5.*t6.*t8.*t11+a_5_5.*t2.*t3.*t7.*t15.*1.0e1-a_6_5.*t3.*t6.*t7.*t16.*1.0e1;q19+a_9_5.*t2.*t4+a_3_6.*t8.*t13.*t14-a_4_6.*t6.*t8.*t11-a_10_5.*t4.*t6.*t9.*5.0+a_1_6.*t2.*t3.*t7.*t15.*1.0e1-a_2_6.*t3.*t6.*t7.*t16.*1.0e1;q22+a_5_6.*t2.*t4-a_6_6.*t4.*t6.*t9.*5.0+a_9_6.*t8.*t13.*t14-a_10_6.*t6.*t8.*t11+a_7_6.*t2.*t3.*t7.*t15.*1.0e1-a_8_6.*t3.*t6.*t7.*t16.*1.0e1];
