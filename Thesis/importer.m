%data = importdata('C:\Users\TOOsab\Desktop\datalogs\XYZ_90_-90_rotation.csv', ',');
%data = importdata('C:\Users\TOOsab\Desktop\datalogs\mpu9250_30s_still_x_500.csv', ',');
%data = importdata('C:\Users\TOOsab\Desktop\datalogs\position_dataset_1min_still.csv', ',');
%sdata = importdata('C:\Users\TOOsab\Desktop\datalogs\dataLog-375808570.csv', ',');
data = importdata('C:\Users\TOOsab\Desktop\datalogs\air_y_500_bf.csv', ',')
%data = importdata('C:\STM32CubeExpansion_MEMS1_V2.0.0\Utilities\PC_software\Sensors_DataLog\SensorsDataLog\20160502_22.14.23.tsv', '\t');
%data = importdata('C:\Users\TOOsab\Desktop\datalogs\Adis_position_square_0000.csv', ';')



gx = data.data(:,2);
gy = data.data(:,3);
gz = data.data(:,4);

ax = data.data(:,5);
ay = data.data(:,6);
az = data.data(:,7);

