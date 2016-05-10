%% Sabbatelli function
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

eul = quat2eul(Q,'ZYX');
plot(eul*180/pi);
legend('Z','Y','X')
