data.freq = Gyro_X;
data.rate = 200; %Hz
tau = 1;

time = 0:1/200:length(Gyro_X)/200;
time = time(1:end-1);

time = 0:1/200:length(gx)/200;
time = time(1:end-1);

[t2 a2 ] = newallan(time, gx);
