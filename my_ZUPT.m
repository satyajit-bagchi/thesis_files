%% Detectors
n = length(ax);
moving_variance = zeros(n,1);

R = zeros(3,3,n);
comp_acc = zeros(n,3);
real_acc = zeros(n,3);
avg_acc = zeros(n,1);

moving_variance_threshold = 1.01; %Random constant for now

for i=1:n
    
    comp_acc(i,:) = quat2rotm([q0_list(i) q1_list(i) q2_list(i) q3_list(i)]) * [ax(i) ay(i) az(i)]'; 
    real_acc(i,:) = comp_acc(i,:) - [0 0 1];
    
    avg_acc(i) = (real_acc(i,1) + real_acc(i,2) + real_acc(i,3))/3;
    
    moving_variance(i) = (real_acc(i,1) - avg_acc(i))^2 + (real_acc(i,2) - avg_acc(i))^2 + (real_acc(i,3) - avg_acc(i))^2; 
end

plot(moving_variance);