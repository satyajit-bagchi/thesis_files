

ax = zeros(1,100);
ay = zeros(1,100);
az = ones(1,100);

gx = ones(1,100)*pi/180;
gy = zeros(1,100);
gz = zeros(1,100);


gx_backup = gx;
gy_backup = gy;
gz_backup = gz;

subplot(1,2,1)
plot(gx_backup)
subplot(1,2,2)
plot(gx*180/pi)

time = 1:length(ax);
figure
subplot(1,3,1)
plot(time,[gx, gx_backup*180/pi]);
legend('filtered gx', 'unfiltered gx'); 
subplot(1,3,2)
plot(time,[gy, gy_backup*180/pi]);
legend('filtered gy', 'unfiltered gy');
subplot(1,3,3)
plot(time, [gz, gz_backup*180/pi] );
legend('filtered gz', 'unfiltered gz');