%%Clipping code
fs = mpu_sampling_frequency;
max_time = 36000;

Time = 0:1/fs:max_time/fs;
Accel_X = Accel_X(1:max_time);

Time= Time(1:36000);
plot(Time, Accel_X);

Accel_X_NoBias = Accel_X - mean(Accel_X);
plot(Time, Accel_X_NoBias);

