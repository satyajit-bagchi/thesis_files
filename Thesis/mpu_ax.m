%% Mpu Accelerometer


mpu_ax_bias = mean(Accel_X);

%myfft(Accel_X_NoBias*mpu_ax_sensitivity, 1/mpu_sampling_frequency);

%% Plotting 

if(length(mpuAxSim)>length(Accel_X))
    mpuAxSim = mpuAxSim(1:end-1);
end

mpuAxSimNoBias = mpuAxSim - mean(mpuAxSim);
mpuAxZSimNoBias = mpuAxZSim - mean(mpuAxZSim);


%% Comparison

figure(1)
plot(Time,[mpuAxSim, Accel_X])
legend('Sim', 'Real');
figure(2)
subplot(2,2,1)
[f2, amp2] = myfft(Accel_X_NoBias*mpu_ax_sensitivity,1/mpu_sampling_frequency);
hold on;
[f2, amp2] = myfft(mpuAxSimNoBias*mpu_ax_sensitivity,1/mpu_sampling_frequency);
legend('Real','Sim');

subplot(2,2,2)
[f2, amp2] = myfft(Accel_X_NoBias*mpu_ax_sensitivity,1/mpu_sampling_frequency);
legend('Real');

subplot(2,2,3)
[f2, amp2] = myfft(mpuAxSimNoBias*mpu_ax_sensitivity,1/mpu_sampling_frequency);
legend('Sim');


%% Ax Z

close all
if(length(mpuZAxSim)>length(Accel_X))
    mpuZAxSim = mpuZAxSim(2:end);
end

figure
plot(Time(2:end),[mpuZAxSim(2:end), Accel_Z(2:end)])
legend('Sim', 'Real');
figure
subplot(2,2,1)
[f2, amp2] = myfft(Accel_Z*mpu_ax_sensitivity,1/mpu_sampling_frequency);
hold on;
[f2, amp2] = myfft(mpuZAxSim*mpu_ax_sensitivity,1/mpu_sampling_frequency);
legend('Real','Sim');

subplot(2,2,2)
[f2, amp2] = myfft(Accel_Z*mpu_ax_sensitivity,1/mpu_sampling_frequency);
legend('Real');

subplot(2,2,3)
[f2, amp2] = myfft(mpuZAxSim*mpu_ax_sensitivity,1/mpu_sampling_frequency);
legend('Sim');
