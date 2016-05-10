%% Visualization code
Stm_constants;
axas = axes('XLim',[-5.5 5.5],'YLim',[-5.5 5.5],'ZLim',[-5.5 5.5]);
view(3)
grid on
box on
vert = [1 1 1; 1 2 1; 2 2 1; 2 1 1 ; ...
    1 1 2;1 2 2; 2 2 2;2 1 2]-1.5;
fac = [1 2 3 4
    2 6 7 3];
    %4 3 7 8
    %1 5 8 4
    %1 2 6 5
    %5 6 7 8];
h = patch('Faces',fac,'Vertices',vert,'FaceColor','r');  % patch function

t = hgtransform('Parent',axas);
set(h,'Parent',t)

Rz = eye(4);

%% Kalman boilerplate code
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


delta_t = 1/fs;
q0_list = [q0];
q1_list = [q1];
q2_list = [q2];
q3_list = [q3];


%% Serial init code
s = serial('COM9','Baudrate',115200);

fopen(s);

for i=1:10000
    
    
    q0 = q0_list(i);
    q1 = q1_list(i);
    q2 = q2_list(i);
    q3 = q3_list(i);
    
    read_data = fscanf(s,'%d %d %d %d %d %d'); %Read gyro
    
    if(length(read_data)~=6)
        wx = 0;
        wy = 0;
        wz = 0;
        
        x_dot_dot = 0;
        y_dot_dot = 0;
        z_dot_dot = 1;
    
    else
        
        x_dot_dot = (read_data(1)-stm_ax_bias)*10e-3; %m/s/s
        y_dot_dot = (read_data(2)-stm_ay_bias)*10e-3;
        z_dot_dot = (read_data(3)-stm_az_bias)*10e-3;
        
        wx = (read_data(4)-stm_gx_bias)*10e-3*pi/180; %radians/second
        wy = (read_data(5)-stm_gy_bias)*10e-3*pi/180;
        %gz = (read_data(6)-stm_gz_bias)*10e-3*pi/180;
        
        wz = 0;
        
    end

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
    
    
    q_old_posterior = q_new_posterior;
    P_old_posterior = P_new_posterior;
    
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
    
    
end