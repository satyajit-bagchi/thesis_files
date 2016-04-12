%% Prep code - MPU9250

Gyro_Z_NoBias = Gyro_Z - mean(Gyro_Z);
mpu_gyro_bias = mean(Gyro_Z);
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

if(length(mpuGyroSim)>length(Gyro_Z))
    mpuGyroSim = mpuGyroSim(1:end-1);
end

mpuGyroSimNoBias = mpuGyroSim - mean(mpuGyroSim);
figure(1)
plot(Time,[mpuGyroSim, Gyro_Z])
legend('Sim', 'Real');
figure(2)
subplot(2,2,1)
[f2, amp2] = myfft(Gyro_Z_NoBias*mpu_gyro_sensitivity,1/mpu_sampling_frequency);
hold on;
[f2, amp2] = myfft(mpuGyroSimNoBias*mpu_gyro_sensitivity,1/mpu_sampling_frequency);
legend('Real','Sim');

subplot(2,2,2)
[f2, amp2] = myfft(Gyro_Z_NoBias*mpu_gyro_sensitivity,1/mpu_sampling_frequency);
legend('Real');

subplot(2,2,3)
[f2, amp2] = myfft(mpuGyroSimNoBias*mpu_gyro_sensitivity,1/mpu_sampling_frequency);
legend('Sim');
