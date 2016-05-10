W = 5;

sigma = 0.1*pi/180;
T = zeros(1,n-W+1);

zupt = zeros(n,1);
zupt_threshold = 100;

T_gx = gx_backup;
T_gy = gy_backup;
T_gz = gz_backup;

T_gx = T_gx * pi/180;
T_gy = T_gy * pi/180;
T_gz = T_gz * pi/180;

for k=1:n-W+1
    for l = k:k + W -1
        %T(k) = T(k)+norm([T_gx(l) T_gy(l) T_gz(l)])^2;
        %T(k)=T(k)+(norm([ax(l) ay(l) az(l)])-1)^2;
        T(k)=T(k)+(norm(true_acc(l,:)))^2;
    end
end

T = T./sigma;


for k=1:length(T)
    if T(k)<zupt_threshold;
       zupt(k:k+W-1)=ones(1,W); 
    end    
end

subplot(2,1,1)
plot(T);
title('Test statistics')
subplot(2,1,2)
plot(zupt)
title('Zupt')

%mean1 = mean(T(1:6000));
%mean2 = mean(T(7500:end));
