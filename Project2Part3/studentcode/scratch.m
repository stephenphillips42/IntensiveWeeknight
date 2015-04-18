%% EKF 1
clear

% Create the symbols and functions we need
x = sym('x',[9,1]); % x = [p; q; b_g];
v_m = sym('v_m',[3,1]); % Measured velocity
w_m = sym('w_m',[3,1]); % Measured angular velocity
n = sym('n',[9,1]); % Noise vector
G = @(q) [cos(q(2)) 0 -cos(q(1))*sin(q(2));
              0     1         0;
          sin(q(2)) 0  cos(q(1))*cos(q(2)) ];
% Jacobian
xdot = [v_m - n(1:3);
        inv(G(x(4:6)))*(w_m - x(7:9) - n(4:6));
        n(7:9) ];

J = jacobian(xdot,x);
Jnoise = jacobian(xdot,n);

%% EKF 2

clear

% Create the symbols and functions we need
x = sym('x',[15,1]); % x = [p; q; pdot; b_g; b_a];
w_m = sym('w_m',[3,1]); % Measured angular velocity
a_m = sym('a_m',[3,1]); % Measured acceleration
n = sym('n',[12,1]); % Gyroscope noise

R = @(q) [ cos(q(3))*cos(q(2))-sin(q(1))*sin(q(3))*cos(q(2)), -cos(q(1))*sin(q(3)), cos(q(3))*sin(q(2))-cos(q(2))*sin(q(1))*cos(q(3));
           cos(q(2))*sin(q(3))+cos(q(3))*sin(q(1))*sin(q(2)), cos(q(1))*cos(q(3)), sin(q(3))*sin(q(2))-cos(q(3))*cos(q(2))*sin(q(1));
           -cos(q(1))*sin(q(2)), sin(q(1)), cos(q(1))*cos(q(2)) ];
G = @(q) [cos(q(2)) 0 -cos(q(1))*sin(q(2));
              0     1         0;
          sin(q(2)) 0  cos(q(1))*cos(q(2)) ];

xdot = [ x(7:9);
         inv(G(x(4:6)))*(w_m - x(10:12) - n(1:3));
         [0,0,-9.81]'+R(x(4:6))*(a_m - x(13:15) - n(4:6));
         n(7:9);
         n(10:12) ];

J = jacobian(xdot,x);
     

%%


