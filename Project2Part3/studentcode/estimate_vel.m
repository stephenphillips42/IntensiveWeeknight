function [vel, omg] = estimate_vel(sensor, varargin)
%ESTIMATE_VEL 6DOF velocity estimator
%   sensor - struct stored in provided dataset, fields include
%          - is_ready: logical, indicates whether sensor data is valid
%          - t: timestamp
%          - rpy, omg, acc: imu readings, you should not use these in this phase
%          - img: uint8, 240x376 grayscale image
%          - id: 1xn ids of detected tags
%          - p0, p1, p2, p3, p4: 2xn pixel position of center and
%                                four corners of detected tags
%            Y
%            ^ P3 == P2
%            | || P0 ||
%            | P4 == P1
%            o---------> X
%   varargin - any variables you wish to pass into the function, could be
%              a data structure to represent the map or camera parameters,
%              your decision. But for the purpose of testing, since we don't
%              know what inputs you will use, you have to specify them in
%              init_script by doing
%              estimate_vel_handle = ...
%                  @(sensor) estimate_vel(sensor, your personal input arguments);
%   vel - 3x1 velocity of the quadrotor in world frame
%   omg - 3x1 angular velocity of the quadrotor

% Parameters
K = varargin{1};
tagsX = varargin{2};
tagsY = varargin{3};
R_wc = varargin{4};
T_wc = varargin{5};

NSELECT_POINTS = 500;
MIN_POINTS = 100;
RANSAC_ITERS = 400;
MIN_SAMPLE_SIZE = 3;
RANSAC_THRESH = 0.05;
dt = 1/50;

% Persistent variables
persistent last_image
persistent point_tracker
persistent points
persistent valid_state

if isempty(sensor.id)
    vel = [];
    omg = [];
    return
end

% Initialization code
if isempty(last_image)
    last_image = sensor.img;
    point_tracker = vision.PointTracker('MaxBidirectionalError',0.005);
    % points = corner(frame_image,'MinEigen',NSELECT_POINTS);
    points = detectBRISKFeatures(last_image);
    points = points.selectStrongest(NSELECT_POINTS);
    points = points.Location;
    initialize(point_tracker,points,last_image);
    valid_state = true;
    vel = [0;0;0];
    omg = [0;0;0];
    return
end

% Check if we have enough points to keep tracking
if ~valid_state
    % Redecting corners -- slow
    point_tracker = vision.PointTracker('MaxBidirectionalError',0.005);
    % points = corner(frame_image,'Harris',NSELECT_POINTS);
    points = detectBRISKFeatures(last_image);
    points = points.selectStrongest(NSELECT_POINTS);
    points = points.Location;
    initialize(point_tracker,points,last_image);
    valid_state = true;
end

% Get feature tracks
next_frame = sensor.img;
[new_points,valid_points] = step(point_tracker,next_frame);
if sum(valid_points) < MIN_POINTS
    valid_state = false;
end
cur_points = new_points(valid_points,:);
prev_points = points(valid_points,:);
last_image = next_frame;

% Flow computation
n = length(prev_points);
p_prev = K \ [prev_points'; ones(1,n)];
p_cur = K \ [cur_points'; ones(1,n)];
flow = (p_cur(1:2,:) - p_prev(1:2,:))/dt;% new_points - points;

% Compute the depths
Z = ((R_wc(:,3)'*T_wc)./(R_wc(:,3)'*p_cur))';

% scatter3(p_cur(1,:),p_cur(2,:),Z)
% axis equal

% RANSAC to estimate velocity and angular velocity
fx = @(x,y,z) [ -1./z, zeros(size(x)), x./z,     x.*y, -(1+x.^2),  y ];
fy = @(x,y,z) [ zeros(size(x)), -1./z, y./z, (1+y.^2),     -x.*y, -x ];

max_inliers = 0;
best_inliers = [];
for it = 1:RANSAC_ITERS
    sample = randperm(n,MIN_SAMPLE_SIZE);
    v_omgs = ...
        [fx(p_cur(1,sample)',p_cur(2,sample)',Z(sample));
          fy(p_cur(1,sample)',p_cur(2,sample)',Z(sample))] \ ...
          reshape(flow(:,sample)',[],1);
    errs = ([fx(p_cur(1,:)',p_cur(2,:)',Z);
             fy(p_cur(1,:)',p_cur(2,:)',Z)]*v_omgs - reshape(flow',[],1));
    errs = sum(reshape(errs.^2,[],2),2);
    inliers = errs < RANSAC_THRESH;
    if sum(inliers) > max_inliers
        max_inliers = sum(inliers);
        best_inliers = inliers;
    end
    if max_inliers == length(p_cur)
        break;
    end
end

% best_inliers = true(length(p_cur),1);
% fprintf('%d inliers vs %d total\n',max_inliers,n)

% zpoints = p_prev';
% znew_points = p_cur';
% quiver(zpoints(:,1),zpoints(:,2),znew_points(:,1)-zpoints(:,1),znew_points(:,2)-zpoints(:,2));
% figure
% imshow(frame_image)
% Recompute value
P = [ fx(p_cur(1,best_inliers)',p_cur(2,best_inliers)',Z(best_inliers));
      fy(p_cur(1,best_inliers)',p_cur(2,best_inliers)',Z(best_inliers))];
v_omgs = P \ reshape(flow(:,best_inliers)',[],1);


XYZ = [-0.04, 0.0, -0.03]';
Yaw = -pi/4;
Roll = pi;
Rz = @(th) [cos(th), -sin(th), 0; sin(th), cos(th), 0; 0, 0, 1];
Rx = @(th) [1, 0, 0; 0, cos(th), -sin(th); 0, sin(th), cos(th)];
R_toIMU = Rz(Yaw)*Rx(Roll);
T_toIMU = -R_toIMU'*XYZ;

omg = R_wc'*v_omgs(4:6);
vel = R_wc'*(v_omgs(1:3) - cross(T_toIMU,v_omgs(4:6)));

points = new_points;

end


