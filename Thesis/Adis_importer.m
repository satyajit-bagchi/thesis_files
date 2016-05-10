%% ADIS importer

%data = importdata('C:\Users\TOOsab\Desktop\datalogs\Adis_position_square_0000.csv', ';')
%data = importdata('C:\Users\TOOsab\Desktop\datalogs\adis_quick_straight_left_3_0000.csv',';');

data = importdata('C:\Users\TOOsab\Desktop\datalogs\adis_rig_straight_right_straight_0000.csv',';');
calib = importdata('C:\Users\TOOsab\Desktop\datalogs\imu_calib.csv');


gx = data.data(:,1);
gy = data.data(:,2);
gz = data.data(:,3);


ax = data.data(:,4);
ay = data.data(:,5);
az = data.data(:,6);
