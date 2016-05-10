%% Adis calibrator

adis_ax_bias = -0.0303; %dps
adis_ay_bias = 0.0186;
%adis_az_bias = 0.0021;
adis_az_bias = 0;



adis_gx_bias = -0.1206;
adis_gy_bias = 0.0299;
adis_gz_bias = 0.8589;


ax = ax - adis_ax_bias;
ay = ay - adis_ay_bias;
az = az - adis_az_bias;

gx = gx - adis_gx_bias;
gy = gy - adis_gy_bias;
gz = gz - adis_gz_bias;

M =[0.1216    5.9782   -8.8899
    5.9782   -3.4270   -7.5809
   -8.8899   -7.5809   -1.6090];

B =[3.5304
   -1.3747
   -0.7560];

% n=length(ax);
% calib_acc = zeros(n,3);
% for i=1:n
%     calib_acc(i,:) = (M*([ax(i) ay(i) az(i)] - B')')';
% end
% ax = calib_acc(:,1);
% ay = calib_acc(:,2);
% az = calib_acc(:,3);

