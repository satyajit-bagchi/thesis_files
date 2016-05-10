data = importdata('C:\STM32CubeExpansion_MEMS1_V2.0.0\Utilities\PC_software\Sensors_DataLog\SensorsDataLog\20160502_22.14.23.tsv', '\t');

mpu_sampling_frequency = 119;

gx = data.data(:,4);
gy = data.data(:,5);
gz = data.data(:,6);

ax = data.data(:,1);
ay = data.data(:,2);
az = data.data(:,3);

ax = (ax-stm_ax_bias).*10e-3;
ay = (ay-stm_ay_bias).*10e-3;
az = (az-stm_az_bias).*10e-3;

gx = (gx-stm_gx_bias).*10e-3;
gy = (gy-stm_gy_bias).*10e-3;
gz = (gz-stm_gz_bias).*10e-3;

gx_backup = gx;
gy_backup = gy;
gz_backup = gz;

ax_backup = ax;
ay_backup = ay;
az_backup = az;

Mahony_matlab;

