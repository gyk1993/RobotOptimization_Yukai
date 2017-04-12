function out1 = f_intTrapVel_RightStance(in1,N)
%F_INTTRAPVEL_RIGHTSTANCE
%    OUT1 = F_INTTRAPVEL_RIGHTSTANCE(IN1,N)

%    This function was generated by the Symbolic Math Toolbox version 7.0.
%    12-Apr-2017 18:23:39

T = in1(:,1);
ddq1_1 = in1(:,24);
ddq1_2 = in1(:,25);
ddq1_3 = in1(:,26);
ddq1_4 = in1(:,27);
ddq1_5 = in1(:,28);
ddq1_6 = in1(:,29);
ddq1_7 = in1(:,30);
ddq1_8 = in1(:,31);
ddq1_9 = in1(:,32);
ddq2_1 = in1(:,68);
ddq2_2 = in1(:,69);
ddq2_3 = in1(:,70);
ddq2_4 = in1(:,71);
ddq2_5 = in1(:,72);
ddq2_6 = in1(:,73);
ddq2_7 = in1(:,74);
ddq2_8 = in1(:,75);
ddq2_9 = in1(:,76);
ddq1_10 = in1(:,33);
ddq1_11 = in1(:,34);
ddq1_12 = in1(:,35);
ddq1_13 = in1(:,36);
ddq1_14 = in1(:,37);
ddq1_15 = in1(:,38);
ddq1_16 = in1(:,39);
ddq1_17 = in1(:,40);
ddq1_18 = in1(:,41);
ddq1_19 = in1(:,42);
ddq1_20 = in1(:,43);
ddq1_21 = in1(:,44);
ddq1_22 = in1(:,45);
ddq2_10 = in1(:,77);
ddq2_11 = in1(:,78);
ddq2_12 = in1(:,79);
ddq2_13 = in1(:,80);
ddq2_14 = in1(:,81);
ddq2_15 = in1(:,82);
ddq2_16 = in1(:,83);
ddq2_17 = in1(:,84);
ddq2_18 = in1(:,85);
ddq2_19 = in1(:,86);
ddq2_20 = in1(:,87);
ddq2_21 = in1(:,88);
ddq2_22 = in1(:,89);
dq1_1 = in1(:,2);
dq1_2 = in1(:,3);
dq1_3 = in1(:,4);
dq1_4 = in1(:,5);
dq1_5 = in1(:,6);
dq1_6 = in1(:,7);
dq1_7 = in1(:,8);
dq1_8 = in1(:,9);
dq1_9 = in1(:,10);
dq2_1 = in1(:,46);
dq2_2 = in1(:,47);
dq2_3 = in1(:,48);
dq2_4 = in1(:,49);
dq2_5 = in1(:,50);
dq2_6 = in1(:,51);
dq2_7 = in1(:,52);
dq2_8 = in1(:,53);
dq2_9 = in1(:,54);
dq1_10 = in1(:,11);
dq1_11 = in1(:,12);
dq1_12 = in1(:,13);
dq1_13 = in1(:,14);
dq1_14 = in1(:,15);
dq1_15 = in1(:,16);
dq1_16 = in1(:,17);
dq1_17 = in1(:,18);
dq1_18 = in1(:,19);
dq1_19 = in1(:,20);
dq1_20 = in1(:,21);
dq1_21 = in1(:,22);
dq1_22 = in1(:,23);
dq2_10 = in1(:,55);
dq2_11 = in1(:,56);
dq2_12 = in1(:,57);
dq2_13 = in1(:,58);
dq2_14 = in1(:,59);
dq2_15 = in1(:,60);
dq2_16 = in1(:,61);
dq2_17 = in1(:,62);
dq2_18 = in1(:,63);
dq2_19 = in1(:,64);
dq2_20 = in1(:,65);
dq2_21 = in1(:,66);
dq2_22 = in1(:,67);
t2 = N-1.0;
t3 = 1.0./t2;
out1 = [-dq1_1+dq2_1-T.*t3.*(ddq1_1+ddq2_1).*(1.0./2.0);-dq1_2+dq2_2-T.*t3.*(ddq1_2+ddq2_2).*(1.0./2.0);-dq1_3+dq2_3-T.*t3.*(ddq1_3+ddq2_3).*(1.0./2.0);-dq1_4+dq2_4-T.*t3.*(ddq1_4+ddq2_4).*(1.0./2.0);-dq1_5+dq2_5-T.*t3.*(ddq1_5+ddq2_5).*(1.0./2.0);-dq1_6+dq2_6-T.*t3.*(ddq1_6+ddq2_6).*(1.0./2.0);-dq1_7+dq2_7-T.*t3.*(ddq1_7+ddq2_7).*(1.0./2.0);-dq1_8+dq2_8-T.*t3.*(ddq1_8+ddq2_8).*(1.0./2.0);-dq1_9+dq2_9-T.*t3.*(ddq1_9+ddq2_9).*(1.0./2.0);-dq1_10+dq2_10-T.*t3.*(ddq1_10+ddq2_10).*(1.0./2.0);-dq1_11+dq2_11-T.*t3.*(ddq1_11+ddq2_11).*(1.0./2.0);-dq1_12+dq2_12-T.*t3.*(ddq1_12+ddq2_12).*(1.0./2.0);-dq1_13+dq2_13-T.*t3.*(ddq1_13+ddq2_13).*(1.0./2.0);-dq1_14+dq2_14-T.*t3.*(ddq1_14+ddq2_14).*(1.0./2.0);-dq1_15+dq2_15-T.*t3.*(ddq1_15+ddq2_15).*(1.0./2.0);-dq1_16+dq2_16-T.*t3.*(ddq1_16+ddq2_16).*(1.0./2.0);-dq1_17+dq2_17-T.*t3.*(ddq1_17+ddq2_17).*(1.0./2.0);-dq1_18+dq2_18-T.*t3.*(ddq1_18+ddq2_18).*(1.0./2.0);-dq1_19+dq2_19-T.*t3.*(ddq1_19+ddq2_19).*(1.0./2.0);-dq1_20+dq2_20-T.*t3.*(ddq1_20+ddq2_20).*(1.0./2.0);-dq1_21+dq2_21-T.*t3.*(ddq1_21+ddq2_21).*(1.0./2.0);-dq1_22+dq2_22-T.*t3.*(ddq1_22+ddq2_22).*(1.0./2.0)];
