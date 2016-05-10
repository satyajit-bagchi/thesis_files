%%Stm constants

%2000 dps, 2g;


stm_gyro_sensitivity = 70 * 10e-3; %dps/lsb
stm_ax_sensitivity = 0.061 * 10e-3; % g/lsb
stm_baro_sensitivity = 1;

gyro_sensitivity = stm_gyro_sensitivity;
axm_sensitivity = stm_ax_sensitivity;

stm_sampling_frequency = 119;
fs = stm_sampling_frequency;

stm_ax_bias = -7.1862;
stm_ay_bias = 5.396055;
stm_az_bias = 9; %bias in mg

stm_gx_bias = 1190;
stm_gy_bias = 409.3494;
stm_gz_bias = 561.5282;

stm_barometer_bias = 1.0228*10e3;
stm_barometer_std = 0.0758;

