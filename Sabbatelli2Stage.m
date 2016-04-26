%% Sabbatelli single stage Kalman filter


%% Notes

% Rotation convention is XYZ. I'm not sure how that will affect the
% resultant quaternion

% Input to this script should be gyro in dps, acceleration in g.

% This script assumes imus have been appropriately calibrated.

close all;

%% Setup
gx = gx_backup;
gy = gy_backup;
gz = gz_backup;

gx = gx*pi/180;
gy = gy*pi/180;
gz = gz*pi/180;

R = zeros(3,3,length(gx));
comp_acc = [zeros(length(gx),3)];
true_acc = [zeros(length(gx),3)];
linear_velocity = [zeros(length(gx),3)];
linear_position = [zeros(length(gx),3)];

R = [2 0 0
     0 2 0
     0 0 2];
 
 Q = 10e-6*eye(4);
 
 P = 0.5*eye(4);
 
 q = [1 0 0 0 ];
 
 q0 = q(1);
 q1 = q(2);
 q2 = q(3);
 q3 = q(4);
 
 V = eye(3); %Yeah, I dont know what the fuck i'm supposed to set this to 
 
q_old_posterior = q'; 
P_old_posterior = P;
Q_new = Q;
V_new = V;
R_new = R;

n = length(ax);
delta_t = 1/fs;
q0_list = [q0];
q1_list = [q1];
q2_list = [q2];
q3_list = [q3];

 %%What is V?
 

%% A priori state estimation



%Step 1

for i=1:n

 q0 = q0_list(i);
 q1 = q1_list(i);
 q2 = q2_list(i);
 q3 = q3_list(i);

 wx = gx(i); wy = gy(i); wz = gz(i); %Read gyro
 x_dot_dot = ax(i);
 y_dot_dot = ay(i);
 z_dot_dot = az(i);


%Step 2
ohm_n_nb = [0 -wx -wy -wz
            wx 0   wz -wy
            wy -wz 0   wx
            wz  wy -wx 0];

A = eye(4) + (1/2) * ohm_n_nb*delta_t; %Calculate discrete time state transition matrix

%Step 3
q_new_prior = A * q_old_posterior; %A priori system state estimation

%Step 4
P_new_prior = A * P_old_posterior * A' + Q_new;

%% Correction stage
H_new = 2*[-q2 q3 -q0 q1
           q1 q0  q3 q2
           q0 -q1 -q2 q3]; %Calculation of Jacobian matrix Hk

K_new = P_new_prior * H_new' * inv(H_new * P_new_prior * H_new' + V_new*R_new*V_new'); %Calculate Kalman gain

Z_new = [x_dot_dot;y_dot_dot;z_dot_dot]; %Read accelerometer data

h1 = [2*q1*q3 - 2*q0*q2
      2*q0*q1 + 2*q2*q3
      q0^2 - q1^2 - q2^2 + q3^2]; %h1(q_new_prior)
  
q_error = K_new*(Z_new - h1); %Correction factor(error)

q_new_posterior = q_new_prior + q_error; %State estimation

P_new_posterior = (eye(4) - K_new*H_new)*P_new_prior; %Error covariance matrix

q0_list = [q0_list q_new_posterior(1)];
q1_list = [q1_list q_new_posterior(2)];
q2_list = [q2_list q_new_posterior(3)];
q3_list = [q3_list q_new_posterior(4)];

R(:,:,i) = quatern2rotMat([q_new_posterior(1) q_new_posterior(2) q_new_posterior(3) q_new_posterior(4)])';
comp_acc(i,:) = (R(:,:,i) * [ax(i) ay(i) az(i)]');


%% Update matrices

q_old_posterior = q_new_posterior; 
P_old_posterior = P_new_posterior;
Q_new = Q;


end

Q = [q0_list' q1_list' q2_list' q3_list'];

eul = quat2eul(Q,'ZYX')*180/pi;
plot(eul);
legend('Z','Y','X')

% figure
% subplot(1,2,1)
% plot(comp_acc);
% legend('Compensated X acc','Compensated Y acc','Compensated Z acc')
% 
% true_acc = comp_acc - [zeros(1,length(gx))',zeros(1,length(gx))',ones(1,length(gx))'];
% %true_acc = comp_acc;
% true_acc = true_acc.*9.81;
% 
% 
% subplot(1,2,2)
% plot(true_acc)
% legend('True X acc','True Y acc','True Z acc');
% 
% probs = zeros(n,1);
% 
% 
% n = length(ax);
% avg_acc = zeros(n,3);
% moving_variance = zeros(n,1);
% acc_norm = zeros(n,1)
% 
% for i = 1:n
%     avg_acc(i,:) = (true_acc(i,1) + true_acc(i,2) + true_acc(i,3))/3;
%     acc_norm(i) = sqrt(ax(i)^2 + ay(i)^2 + az(i)^2);
% end
% 
% dax = zeros(1,length(ax));
% threshold = 2;
% for i=2:length(ax)
%     dax(i) = (ax(i-1)-ax(i))/(1/fs);
%     dax(i) = abs(dax(i));
% end
% 
% for i = 2:length(gx)
%     moving_variance(i) = (true_acc(i,1) - avg_acc(i))^2 + (true_acc(i,2) - avg_acc(i))^2 + (true_acc(i,3) - avg_acc(i))^2;
%     
%     logit = -5.45298873 + 12.03298115*acc_norm(i);
%     logit = exp(logit);
%     
%     prob = logit/(1 + logit);
%     probs(i) = prob;
%     
%     if(prob>0.9)
%         linear_velocity(i,:) = linear_velocity(i-1,:) + true_acc(i,:) * 1/fs;
%     end
%     
%     if(acc_norm(i)<1.0)
%         linear_velocity(i,:) = 0;
%     end
%     
%    % if moving_variance(i)<moving_variance_threshold
%    %     linear_velocity(i,:) = 0;
%    % end
% 
% %    if dax(i)<dax_threshold
% %        linear_velocity(i,:) = 0;
% %    end
%     
%     
% end
% 
% 
% 
% %Filtering velocity
% %order = 1;
% %filtCutOff = 0.1;
% %[b, a] = butter(order, (2*filtCutOff)/fs, 'high');
% %linear_velocity = filtfilt(b, a, linear_velocity)
% 
% for i = 2:length(gx)
%     linear_position(i,:) = linear_position(i-1,:) + linear_velocity(i,:) * 1/fs;    
% end
% 
% %Filtering position
% 
% 
% %order = 1;
% %filtCutOff = 0.1;
% %[b, a] = butter(order, (2*filtCutOff)/fs, 'high');
% %linear_position = filtfilt(b, a, linear_position);
% 
% figure
% plot(linear_position);
% legend('Position X', 'Position Y', 'Position Z');