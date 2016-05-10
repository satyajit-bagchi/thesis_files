%% Adis positioning algorithm
true_acc = [ax ay az-1.0]*9.81;
subplot(3,2,1)
plot(ax);

title('Acceleration X');

subplot(3,2,2)
plot(gx_backup);
title('Gyroscope X');

subplot(3,2,3)
plot(ay);

title('Acceleration Y');

subplot(3,2,4)
plot(gy_backup);
title('Gyroscope Y');


subplot(3,2,5)
plot(az);

title('Acceleration Z');

subplot(3,2,6)
plot(gz_backup);
title('Gyroscope Z');

%Dead reckoning section

n = length(ax);

adis_velocity = zeros(n,3);
adis_position = zeros(n,3);
dt = 1/fs;

adis_lp_acc = zeros(n,3);
adis_hp_velocity = zeros(n,3);
adis_positive_velocity = zeros(n,3);
adis_lp_position = zeros(n,3);

order = 1;
filtCutOff = 10;
[b, a] = butter(order, (2*filtCutOff)/(1/dt), 'low');
adis_lp_acc = filtfilt(b, a, true_acc);
%adis_lp_acc = true_acc;


for i=3:n
    
    adis_velocity(i,:) = adis_velocity(i-1,:) + dt/2*(true_acc(i,:)+ ...
        true_acc(i-1,:));
    if zupt(i)==1
        %adis_velocity(i,:) = 0;
        %adis_velocity(i,:) = 0.7*adis_velocity(i-1,:);
        adis_velocity(i,:) = 0.4^(2377-abs(norm(true_acc(i,:))));
    end
    
    adis_position(i,:) = adis_position(i-1,:) + dt/2*(adis_velocity(i-1,:)+...
        adis_velocity(i,:));


end

for i=3:n
    adis_hp_velocity(i,:) = adis_hp_velocity(i-1,:) + ...
    (dt/2)*(adis_lp_acc(i,:)+adis_lp_acc(i-1,:));
    
end


order = 4;
filtCutOff = 0.1;
[b, a] = butter(order, (2*filtCutOff)/(1/dt), 'high');
adis_hp_velocity = filtfilt(b,a,adis_hp_velocity);



for i=3:n
    
    adis_lp_position(i,:) = adis_lp_position(i-1,:) + ...
    (dt/2)*(adis_hp_velocity(i,:) ...
    +adis_hp_velocity(i-1,:));
end

close all;

figure


subplot(3,2,1)

plot(adis_lp_acc)
title('Lowpass filtered acceleration')
legend('X','Y','Z');


subplot(3,2,2)
plot(true_acc);
title('True acceleration');
legend('X','Y','Z');



subplot(3,2,3);
plot(adis_hp_velocity)
title('Highpass filtered velocity');
legend('X','Y','Z');


subplot(3,2,4);

plot(adis_velocity);
title('Unfiltered Velocities')
legend('X','Y','Z');

subplot(3,2,5);
plot(adis_lp_position);
title('Lowpass filtered Positions')
legend('X','Y','Z');


subplot(3,2,6);
plot(adis_position);
title('Unfiltered Positions')
legend('X','Y','Z');



% figure
% subplot(2,1,1)
% 
% order = 1;
% filtCutOff = 2;
% [b, a] = butter(order, (2*filtCutOff)/(1/dt), 'low');
% 
% plot(true_acc);
% a
% subplot(2,1,2)
% plot(zupt);

% figure
% plot(true_acc(:,1))
% hold on
% plot([ax*9.81])
% legend('True acc', 'Ax');



figure
subplot(3,1,1)
plot(ax)
subplot(3,1,2)
plot(ay)
subplot(3,1,3)
plot(az)


