%% Oculus positioning
close all;
n = length(true_acc);
filtering_mode = 0;

hp_filtered_acc = zeros(n,3);
hp_filtered_acc = zeros(n,3);
alpha = 0.2;
rc = 1/(2*pi*0.4);
dt =1/fs;

ema_filtered_acc = zeros(n,3);
oculus_velocity = zeros(n,3);
filtered_position = zeros(n,3);
ema_filtered_acc(1,:) = true_acc(1,:);
hp_filtered_acc = zeros(n,3);
adaptive_filtered_velocity = zeros(n,3);

acceleration_magnitude = zeros(n,1);

acceleration_decay_threshold = 0.1;
acceleration_decay_range = 0.4;


acceleration_fc = 0.1;
acceleration_rc = 1/2*pi*acceleration_fc;
acceleration_alpha = acceleration_rc/(acceleration_rc+dt);


%%Filter acceleration and calculate magnitude and hp filter acceleration;
for i=2:n  
    ema_filtered_acc(i,:) = ema_filtered_acc(i-1,:) + alpha*(true_acc(i,:)-ema_filtered_acc(i-1,:));
    acceleration_magnitude(i) = norm(ema_filtered_acc(i,1)+ema_filtered_acc(i,2)+ema_filtered_acc(i,3));    
    
    hp_filtered_acc(i,:) = hp_filtered_acc(i-1,:)*acceleration_alpha + ...
      (ema_filtered_acc(i,:) - ema_filtered_acc(i-1,:))*acceleration_alpha;
  
    
end


%Plot filtered and unfiltered acc

% figure
% subplot(2,1,1)
% plot(true_acc);
% subplot(2,1,2)
% plot(ema_filtered_acc);
% 
 adaptive_filter_p = 50;


%Integration step -> Acc to velocity
for i=3:n    
    oculus_velocity(i,:) = oculus_velocity(i-1,:) + ...
    (dt/2)*(hp_filtered_acc(i,:)+hp_filtered_acc(i-1,:));
end


%%Adaptive high pass filtering for velocity

for i = 2:n
    
    if(abs(acceleration_magnitude(i))>1/adaptive_filter_p)
        
        adaptive_fc = 1/abs(acceleration_magnitude(i))^adaptive_filter_p;
        
    else
        adaptive_fc = 2;
    end
    rc = 1/(2*pi*adaptive_fc);
    
    adaptive_alpha = rc/(rc+dt);
    
    
    
    adaptive_filtered_velocity(i,:) = adaptive_filtered_velocity(i-1,:)*adaptive_alpha + (oculus_velocity(i,:)-oculus_velocity(i-1,:))*adaptive_alpha;
    
    
end

for i=1:n
    if acceleration_magnitude<acceleration_decay_threshold
        factor = acceleration_decay_range^(acceleration_decay_threshold-abs(acceleration_magnitude))
        %adaptive_filtered_velocity(i,:) = adaptive_filtered_velocity(i,:)*factor
    end
    
end

%%Integration step 2 -> Velocity to position

for i=3:n
    
    filtered_position(i,:) = filtered_position(i-1,:) + dt/2*(adaptive_filtered_velocity(i,:)+...
        + adaptive_filtered_velocity(i-1,:));

end
        
l = 1:length(true_acc);
% figure
% subplot(1,2,1)
% plot(true_acc)
% subplot(1,2,2)
% plot(ema_filtered_acc);



close all
subplot(4,1,1)
plot(hp_filtered_acc(:,[1 2]));
title('Oculus accelerations')
legend('X','Y','Z');
subplot(4,1,2)
plot(adaptive_filtered_velocity)
title('Oculus velocities')
legend('X','Y','Z');

subplot(4,1,3)
plot(filtered_position(:,[1 2]))
title('Oculus positions')
legend('X','Y');

subplot(4,1,4)
plot(zupt)
title('Zero Velocity Update')
axis auto
legend('State');

