function [desired_state] = simplepath(t, qn)
% DIAMOND trajectory generator for a diamond

% =================== Your code goes here ===================
% You have to set the pos, vel, acc, yaw and yawdot variables

pos = [0; 0; 0];
vel = [0; 0; 0];
acc = [0; 0; 0];
yaw = 0;
yawdot = 0;

if t > 0.5
    pos = [0; 1; 0];
%     pos = [1; 1; 1];
end

% =================== Your code ends here ===================

desired_state.pos = pos(:);
desired_state.vel = vel(:);
desired_state.acc = acc(:);
desired_state.yaw = yaw;
desired_state.yawdot = yawdot;

end
