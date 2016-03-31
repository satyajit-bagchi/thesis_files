%% Serial Receive

imu = serial('COM4','BaudRate',115200);
fopen(imu);

actualGyroData = zeros(1,17100);

for i=1:17100
    actualGyroData(i)=fscanf(imu,'%d');
    disp(i/171);
end

fclose(imu);

timevector = 1:17100;

plot(timevector,actualGyroData);
xlabel('Sample')
ylabel('Gyro reading')