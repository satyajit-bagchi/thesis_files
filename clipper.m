%% Constants
mpu_gyro_sensitivity = 0.0610; %LSB/dps
mpu_sampling_frequency = 200; %Hz
mpu_gyro_noise_density = 0.01;% dps/rtHz
mpu_w = 250;%Hz
mpu_ax_sensitivity = 1/16384; %g/LSB
mpu_ax_noise_density = 300e-6; %g/rtHz
mpu_ax_w = 460;%Hz
g=9.813;
k=0.05;
fs = mpu_sampling_frequency;
ex_acc_x = 0; %Noise power(g)
ex_acc_y = 0;
ex_acc_z = 0;

%% Hard coded calibration parameters

%Means of the gyroscopes and accelerometers

gx_mean = -18.0674 * mpu_gyro_sensitivity; %dps
gy_mean = 31.3672 * mpu_gyro_sensitivity;
gz_mean = 2.7593 * mpu_gyro_sensitivity;

ax_mean = -690.2795 * mpu_ax_sensitivity; %g
ay_mean = -252.1630 * mpu_ax_sensitivity;
az_mean = -0.0457; %g


dax_threshold = 20;
%% Preprocessing

% pax = pax(2:end);
% pay = pay(2:end);
% paz = paz(2:end);
% 
% pgx = pgx(2:end);
% pgy = pgy(2:end);
% pgz = pgz(2:end);

%ax = Accel_X;
%ay = Accel_Y;
%az = Accel_Z;


%gx = Gyro_X;
%gy = Gyro_Y;
%gz = Gyro_Z;



%% 
ax = ax(2:end);
ay = ay(2:end);
az = az(2:end);

gx = gx(2:end);
gy = gy(2:end);
gz = gz(2:end);


gx = gx * mpu_gyro_sensitivity;
gy = gy * mpu_gyro_sensitivity;
gz = gz * mpu_gyro_sensitivity;


ax = ax * mpu_ax_sensitivity;
ay = ay * mpu_ax_sensitivity;
az = az * mpu_ax_sensitivity;


gx = gx - gx_mean;
gy = gy - gy_mean;
gz = gz - gz_mean;

ax = ax - ax_mean;
ay = ay - ay_mean;
az = az - az_mean;

gx_backup = gx; gy_backup=gy; gz_backup=gz;









