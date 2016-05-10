data = importdata('C:\Users\TOOsab\Desktop\datalogs\RPY_90.csv', ',');
load('rotation_x.mat')
load('rotation_y.mat')
load('rotation_z.mat')
imu_time = data.data(:,1);

gx = data.data(:,2);
gy = data.data(:,3);
gz = data.data(:,4);

ax = data.data(:,5);
ay = data.data(:,6);
az = data.data(:,7);

%screwdriver_rot_x = screwdriver_rot_x(:,(1:n+100));
%screwdriver_rot_y = screwdriver_rot_y(:,(1:n+100));
%screwdriver_rot_z = screwdriver_rot_z(:,(1:n+100));

clipper;

n = length(ax);

Sabbatelli2Stage;

close all;

offset_eul = eul;

l_r = length(screwdriver_rot_x);
l_i = length(ax);

x_data = resample(screwdriver_rot_x(2,:),l_i, l_r);
x_data = x_data';

y_data = resample(screwdriver_rot_y(2,:),l_i, l_r);
y_data = y_data';
y_data = -y_data;

z_data = resample(screwdriver_rot_z(2,:),l_i, l_r);;
z_data = z_data';

figure

plot(x_data*180/pi);
hold on;
plot(y_data*180/pi);
hold on;
plot(z_data*180/pi);
legend('X','Y','Z');
title('Vicon information');

%% 
subplot(3,1,1)
plot(offset_eul(32:end,3)*180/pi);
hold on
plot(y_data*180/pi);
title('Angle X(roll)')
legend('Algorithm ','Vicon');

subplot(3,1,2)
plot(offset_eul(:,2)*180/pi)
hold on
plot(x_data*180/pi);
title('Angle Y(pitch)')
legend('Algorithm','Vicon');

subplot(3,1,3)
plot(offset_eul(:,1)*180/pi)
hold on
plot(z_data*180/pi);
title('Angle Z(yaw)');
legend('Algorithm','Vicon');

r = xcorr(offset_eul(:,3), y_data);

t1 = finddelay(offset_eul(:,3), y_data)

[test1 test2] = alignsignals(offset_eul(:,1), y_data)

imu_t = zeros(length(imu_time),1);
imu_t(1) = 0;
for i=2:length(imu_time)
    
    imu_t(i) = imu_time(i-1) - imu_time(i);
    
end