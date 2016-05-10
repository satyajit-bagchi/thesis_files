%% Hard coded calibration parameters

%Means of the gyroscopes and accelerometers

gx_mean = -18.0674 * mpu_gyro_sensitivity; %dps
gy_mean = 31.3672 * mpu_gyro_sensitivity;
gz_mean = 2.7593 * mpu_gyro_sensitivity;

ax_mean = -690.2795 * mpu_ax_sensitivity; %g
ay_mean = -252.1630 * mpu_ax_sensitivity;
az_mean = -0.0457; %g


gx = gx - gx_mean;
gy = gy - gy_mean;
gz = gz - gz_mean;

ax = ax - ax_mean;
ay = ay - ay_mean;
az = az - az_mean;

n = length(ax);


ax_list = ax;
ay_list = ay;
az_list = az;
