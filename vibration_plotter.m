

close all

figure
subplot(2,3,1)
plot(Accel_X);
title('Acc X');

subplot(2,3,2)
plot(Accel_Y);
title('Acc Y');


subplot(2,3,3)
plot(Accel_Z);
title('Acc Z');


subplot(2,3,4)
plot(Gyro_X);
title('Gyro X');


subplot(2,3,5)
plot(Gyro_Y);
title('Gyro Y');


subplot(2,3,6)
plot(Gyro_Z);
title('Gyro Z');

figure
subplot(2,3,1)

temp = Accel_X - mean(Accel_X);

[f2, amp2] = myfft(Accel_X,1/mpu_sampling_frequency);
legend('Acc X fft')

subplot(2,3,2)
[f2, amp2] = myfft(Accel_Y*mpu_ax_sensitivity,1/mpu_sampling_frequency);
legend('Acc Y fft')

subplot(2,3,3)
[f2, amp2] = myfft(Accel_Z*mpu_ax_sensitivity,1/mpu_sampling_frequency);
legend('Acc Z fft')

subplot(2,3,4)
[f2, amp2] = myfft(Gyro_X*mpu_gyro_sensitivity,1/mpu_sampling_frequency);
legend('Gyro X fft ')

subplot(2,3,5)
[f2, amp2] = myfft(Gyro_Y*mpu_gyro_sensitivity,1/mpu_sampling_frequency);
legend('Gyro Y fft')

subplot(2,3,6)
[f2, amp2] = myfft(Gyro_Z*mpu_gyro_sensitivity,1/mpu_sampling_frequency);
legend('Gyro Z fft')

figure

subplot(2,3,1)

[f2, amp2] = myfft(Accel_X1,1/mpu_sampling_frequency);
legend('Acc X fft still')

subplot(2,3,2)
[f2, amp2] = myfft(Accel_Y1*mpu_ax_sensitivity,1/mpu_sampling_frequency);
legend('Acc Y fft still')

subplot(2,3,3)
[f2, amp2] = myfft(Accel_Z1*mpu_ax_sensitivity,1/mpu_sampling_frequency);
legend('Acc Z fft still')

subplot(2,3,4)
[f2, amp2] = myfft(Gyro_X1*mpu_gyro_sensitivity,1/mpu_sampling_frequency);
legend('Gyro X fft still')

subplot(2,3,5)
[f2, amp2] = myfft(Gyro_Y1*mpu_gyro_sensitivity,1/mpu_sampling_frequency);
legend('Gyro Y fft still')

subplot(2,3,6)
[f2, amp2] = myfft(Gyro_Z1*mpu_gyro_sensitivity,1/mpu_sampling_frequency);
legend('Gyro Z fft still')

figure
[f2, amp2] = myfft(vib*mpu_ax_sensitivity,1/mpu_sampling_frequency);


