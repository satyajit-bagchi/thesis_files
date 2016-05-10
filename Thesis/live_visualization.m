%% Visualization live
%%Kalman boilerplate

max_length = 1000000;
R = zeros(3,3,max_length);

i = 0;

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
fs = mpu_sampling_frequency;
delta_t = 1/fs;
q0_list = [q0];
q1_list = [q1];
q2_list = [q2];
q3_list = [q3];

%%What is V?

%Visualization boilerplate
ax = axes('XLim',[-1.5 1.5],'YLim',[-1.5 1.5],'ZLim',[-1.5 1.5]);
view(3)
grid on

[x,y,z] = cylinder([0.2 0]);

h(1) = surface(x,y,z,'FaceColor','red');
h(2) = surface(x,y,-z,'FaceColor','green');
h(3) = surface(z,x,y,'FaceColor','blue');
%h(4) = surface(-z,x,y,'FaceColor','cyan');
h(4) = surface(z,x,y,'FaceColor','blue');
%h(5) = surface(z,x,y,'FaceColor','blue');
h(5) = surface(y,z,x,'FaceColor','magenta');
h(6) = surface(z,x,y,'FaceColor','blue');


%h(6) = surface(y,-z,x,'FaceColor','yellow');

t = hgtransform('Parent',ax);
set(h,'Parent',t)

Rz = eye(4);

%% Reading file boilerplate

file = fopen('C:\Users\TOOsab\Desktop\Live\dataLog-11532498.csv');
line = fgetl(file);
if((line(1)=='T'))
    read_data = [0 0 0 0 0 0 0];
    
else
    read_data = eval( [ '[', line, ']' ] );
    
end

live_gx = read_data(2)*mpu_gyro_sensitivity*pi/180; %radians/s
live_gy = read_data(3)*mpu_gyro_sensitivity*pi/180;
live_gz = read_data(4)*mpu_gyro_sensitivity*pi/180;

live_ax = read_data(5)*mpu_ax_sensitivity; %g
live_ay = read_data(6)*mpu_ax_sensitivity;
live_az = read_data(7)*mpu_ax_sensitivity;



while ischar(line)
    wx = live_gx; wy = live_gy ; wz = live_gz; %Read gyro
    
    x_dot_dot = live_ax;
    y_dot_dot = live_ay;
    z_dot_dot = live_az;
    
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
    
    
    
    
    %% Update matrices
    
    q_old_posterior = q_new_posterior;
    P_old_posterior = P_new_posterior;
    Q_new = Q;
    
    
    line = fgetl(file);
    
    if((line(1)=='T'))
        read_data = [0 0 0 0 0 0 0];
    else
        read_data = eval( [ '[', line, ']' ] );
        
    end
    
    
    live_gx = read_data(2)*mpu_gyro_sensitivity*pi/180; %radians/s
    live_gy = read_data(3)*mpu_gyro_sensitivity*pi/180;
    live_gz = read_data(4)*mpu_gyro_sensitivity*pi/180;
    
    live_ax = read_data(5)*mpu_ax_sensitivity; %g
    live_ay = read_data(6)*mpu_ax_sensitivity;
    live_az = read_data(7)*mpu_ax_sensitivity;
    
    
    
    new_quaternion = [q_new_posterior(1) q_new_posterior(2) q_new_posterior(3) q_new_posterior(4)];
    
    
    eul = quat2eul(new_quaternion,'ZYX');
    
    Rz = eul2rotm([eul(1) eul(2) eul(3)],'ZYX');
    transform = rotm2tform(Rz);
    
    % Scaling matrix
    %Sxy = makehgtform('scale',r/4);
    % Concatenate the transforms and
    % set the transform Matrix property
    set(t,'Matrix',transform)
    drawnow
    
    i = i +1;
    %disp(eul);
    
    %disp(i)
    
    
    
    
    
end





