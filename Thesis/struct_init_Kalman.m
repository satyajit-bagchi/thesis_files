%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%2nd order Kalman filter for positions 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dt = 1/mpu_sampling_frequency; %Sampling time

imu_var = 10*4.4643e-06; %Imu variance, randomly chosen



s.x = [0 %X 
       0 %X_dot
       0 %X_dot_dot
       0 %Y
       0 %Y_dot
       0 %Y_dot_dot
       0 %Z
       0 %Z_dot
       0 %Z_dot_dot
       ];%Random initial estimate
       
s.A = [1     dt     0.5*dt^2     0     0     0         0     0     0
       0     1     dt            0     0     0         0     0     0
       0     0     1             0     0     0         0     0     0
       0     0     0             1     dt    0.5*dt^2  0     0     0
       0     0     0             0     1     dt        0     0     0
       0     0     0             0     0     1         0     0     0
       0     0     0             0     0     0         1     dt    0.5*dt^2
       0     0     0             0     0     0         0     1     dt
       0     0     0             0     0     0         0     0     1
       ];
   

s.Q = zeros(9,9);
s.Q(2,2) = imu_var^2;
s.Q(3,3) = imu_var^2;
s.Q(5,5) = imu_var^2;
s.Q(6,6) = imu_var^2;
s.Q(8,8) = imu_var^2;
s.Q(9,9) = imu_var^2;

s.H = [0 0 1 0 0 0 0 0 0
       0 0 0 0 0 1 0 0 0
       0 0 0 0 0 0 0 0 1];

s.P = [1     0     0     0     0     0    0     0     0
       0     1     0     0     0     0    0     0     0
       0     0     1     0     0     0    0     0     0
       0     0     0     1     0     0    0     0     0
       0     0     0     0     1     0    0     0     0
       0     0     0     0     0     1    0     0     0
       0     0     0     0     0     0    1     0     0
       0     0     0     0     0     0    0     1     0
       0     0     0     0     0     0    0     0     1]*5;
       
          
s.R = [imu_var   0       0       
         0       imu_var 0 
         0       0       imu_var];
         

s.B = 0;
s.u = 0;

s.z = [true_acc(1,1) true_acc(1,2) true_acc(1,3)]';

