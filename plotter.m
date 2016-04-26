figure
subplot(6,1,1)
plot(gx);
legend('Gyro_X')

subplot(6,1,2)
plot(gy);
legend('Gyro_Y')

subplot(6,1,3)
plot(gz);
legend('Gyro_Z')

subplot(6,1,4)
plot(ax);
legend('Acc_X')

subplot(6,1,5)
plot(ay);
legend('Acc_Y')

subplot(6,1,6)
plot(az);
legend('Acc_Z')

dax = zeros(1,length(ax))

for i=2:length(ax)
    dax(i) = (ax(i-1)-ax(i))/(1/fs);
end

figure
subplot(2,1,1)
plot(dax)
legend('Differentiated acceleration');

detector = zeros(1,length(ax));

threshold = 150;

detector = (dax>threshold);
subplot(2,1,2)
plot(detector);




