figure(1)
plot(Time,[mpuAxZSim, Accel_Z])
legend('Sim', 'Real');
figure(2)
subplot(2,2,1)
[f2, amp2] = myfft(Accel_Z*mpu_ax_sensitivity,1/mpu_sampling_frequency);
hold on;
[f2, amp2] = myfft(mpuAxZ*mpu_ax_sensitivity,1/mpu_sampling_frequency);
legend('Real','Sim');

subplot(2,2,2)
[f2, amp2] = myfft(Accel_Z_*mpu_ax_sensitivity,1/mpu_sampling_frequency);
legend('Real');

subplot(2,2,3)
[f2, amp2] = myfft(mpuAxZ*mpu_ax_sensitivity,1/mpu_sampling_frequency);
legend('Sim');