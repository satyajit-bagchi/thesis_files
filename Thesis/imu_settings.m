%% imu settings

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

dax_threshold = 20;