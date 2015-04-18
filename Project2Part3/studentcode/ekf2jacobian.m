function J = ekf2jacobian(x_in,w_m_in,a_m_in,n_g_in,n_a_in)
%EKF2JACOBIAN
%    J = EKF2JACOBIAN(IN1,IN2,IN3,IN4,IN5)

%    This function was generated by the Symbolic Math Toolbox version 6.1.
%    17-Apr-2015 14:03:56

a_m1 = a_m_in(1,:);
a_m2 = a_m_in(2,:);
a_m3 = a_m_in(3,:);
n_a1 = n_a_in(1,:);
n_a2 = n_a_in(2,:);
n_a3 = n_a_in(3,:);
n_g1 = n_g_in(1,:);
n_g3 = n_g_in(3,:);
w_m1 = w_m_in(1,:);
w_m3 = w_m_in(3,:);
x4 = x_in(4,:);
x5 = x_in(5,:);
x6 = x_in(6,:);
x10 = x_in(10,:);
x12 = x_in(12,:);
x13 = x_in(13,:);
x14 = x_in(14,:);
x15 = x_in(15,:);
t2 = cos(x5);
t3 = sin(x5);
t4 = t2.^2;
t5 = t3.^2;
t6 = t4+t5;
t7 = 1.0./t6;
t8 = cos(x4);
t9 = sin(x4);
t10 = n_g3-w_m3+x12;
t11 = t4.*t8;
t12 = t5.*t8;
t13 = t11+t12;
t14 = 1.0./t13.^2;
t15 = t4.*t9;
t16 = t5.*t9;
t17 = t15+t16;
t18 = n_g1-w_m1+x10;
t19 = 1.0./t13;
t20 = sin(x6);
t21 = cos(x6);
t22 = -a_m1+n_a1+x13;
t23 = -a_m3+n_a3+x15;
t24 = -a_m2+n_a2+x14;
t25 = t2.*t21;
t26 = t3.*t21;
t27 = t2.*t9.*t21;
t28 = t2.*t8.*t21.*t23;
t29 = t3.*t20;
t30 = t2.*t20;
t31 = t3.*t9.*t21;
t32 = t2.*t9.*t20;
t33 = t27-t29;
J = reshape([0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-t2.*t10.*t14.*t17+t3.*t14.*t17.*t18,t28-t9.*t20.*t24+t2.*t8.*t20.*t22,t28+t9.*t21.*t24-t3.*t8.*t21.*t22,-t8.*t24+t2.*t9.*t23-t3.*t9.*t22,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-t2.*t7.*t10+t3.*t7.*t18,0.0,t3.*t10.*t19+t2.*t18.*t19,-t23.*(t25+t31)+t22.*(t26-t3.*t9.*t20),-t23.*(t30+t31)-t22.*t33,t2.*t8.*t22+t3.*t8.*t23,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,t22.*(t27+t30)+t23.*(t29-t2.*t9.*t20)+t8.*t21.*t24,-t23.*(t26+t32)-t22.*(t25-t3.*t9.*t20)+t8.*t20.*t24,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-t2.*t7,0.0,t3.*t19,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-t3.*t7,0.0,-t2.*t19,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-t25+t32,-t30-t31,t3.*t8,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,t8.*t20,-t8.*t21,-t9,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-t26+t27,t33,-t2.*t8,0.0,0.0,0.0,0.0,0.0,0.0],[15, 15]);
