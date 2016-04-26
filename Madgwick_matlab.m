%% Matlab implementation of Madgwicks MARG algorithm

close all;

beta = 0.1; %Gradient descent gain

gx = gx_backup;
gy = gy_backup;
gz = gz_backup;

gx = gx * pi/180; 
gy = gy * pi/180;
gz = gz * pi/180;

fs = 1;
fs = mpu_sampling_frequency;

integralFBx = 0;
integralFBy = 0;
integralFBz = 0;


q0 = 1;
q1 = 0;
q2 = 0;
q3 = 0;

q0_list = [];
q1_list = [];
q2_list = [];
q3_list = [];

rNorm = 1;

%Rate of change of quaternion from gyroscope

for i=1:n
    
    qDot1 = 0.5 * (-q1 * gx(i) - q2 * gy(i)- q3 * gz(i));
    qDot2 = 0.5 * (q0 * gx(i) + q2 * gz(i) - q3 * gy(i));
    qDot3 = 0.5 * (q0 * gy(i) - q1 * gz(i) + q3 * gx(i));
    qDot4 = 0.5 * (q0 * gz(i) + q1 * gy(i) - q2 * gx(i));
    
    if((0~=ax(i))&&(0~=ay(i))&&(0~=az(i)))
        
        %Normalizing accelerometer measurement
        
        rNorm = 1/sqrt(ax(i)^2 + ay(i)^2 + az(i)^2);
        ax(i) = ax(i)*rNorm;
        ay(i) = ay(i)*rNorm;
        az(i) = az(i)*rNorm;
        
        %Precomputing some variables
        
        u2q0 = 2.0 * q0;
        u2q1 = 2.0 * q1;
        u2q2 = 2.0 * q2;
        u2q3 = 2.0 * q3;
        u4q0 = 4.0 * q0;
        u4q1 = 4.0 * q1;
        u4q2 = 4.0 * q2;
        u8q1 = 8.0 * q1;
        u8q2 = 8.0 * q2;
        
        q0q0 = q0 * q0;
        q1q1 = q1 * q1;
        q2q2 = q2 * q2;
        q3q3 = q3 * q3;
        
        s0 = u4q0 * q2q2 + u2q2 * ax(i) + u4q0 * q1q1 - u2q1 * ay(i);
        s1 = u4q1 * q3q3 - u2q3 * ax(i) + 4.0 * q0q0 * q1 - u2q0 * ay(i) - u4q1 + u8q1 * q1q1 + u8q1 * q2q2 + u4q1 * az(i);
        s2 = 4.0 * q0q0 * q2 + u2q0 * ax(i) + u4q2 * q3q3 - u2q3 * ay(i) - u4q2 + u8q2 * q1q1 + u8q2 * q2q2 + u4q2 * az(i);
        
        s3 = 4.0 * q1q1 * q3 - u2q1 * ax(i) + 4.0 * q2q2 * q3 - u2q2 * ay(i);
        
        rNorm = 1/sqrt(s0^2 + s1^2 + s2^2 + s3^2);
        
        s0 = s0 * rNorm;
        s1 = s1 * rNorm;
        s2 = s2 * rNorm;
        s3 = s3 * rNorm;
        
        qDot1 = qDot1 - beta * s0;
        qDot2 = qDot2 - beta * s1;
        qDot3 = qDot3 - beta * s2; 
        qDot4 = qDot4 - beta * s3;
        
    end
    
    q0 = q0 + qDot1 * (1.0/fs);
    q1 = q1 + qDot2 * (1.0/fs);
    q2 = q2 + qDot3 * (1.0/fs);
    q3 = q3 + qDot4 * (1.0/fs);
    
    %Normalizing quaternion to unit norm
    
    rNorm = 1/sqrt(q0^2 + q1^2 + q2^2 + q3^2);
    
    q0 = q0*rNorm;
    q1 = q1*rNorm;
    q2 = q2*rNorm;
    q3 = q3*rNorm;
    
    q0_list = [q0_list q0];
    q1_list = [q1_list q1];
    q2_list = [q2_list q2];
    q3_list = [q3_list q3];
   
    
end
Q = [q0_list' q1_list' q2_list' q3_list'];
%eul = quat2eul(Q,'ZYX');
%eul = quat2eul(quatconj(Q),'ZYX')*180/pi;
eul = quat2eul(Q,'ZYX')*180/pi;

%eul = eul;
%eul = (eul(1:end-10,:));

%eul = eul*(pi/180); %Transform to radians
%eul=wrapTo2Pi(eul); %Wrap to 2 pi
%eul = eul*180/pi; %Transform to degrees for plotting
figure
%subplot(1,2,1)
plot(eul);
legend('Z','Y','X')

% figure
% subplot(1,2,2)
% t=1:length(gx);
% %psi = (180/pi)*wrapToPi((pi/180)*psi);
% %theta = (180/pi)*wrapToPi((pi/180)*theta);
% %phi = (180/pi)*wrapToPi((pi/180)*phi);
% %plot(t,[psi, theta, phi]);
% %legend('psi','theta','phi');
% 
% figure
% subplot(3,2,1)
% plot(t, gx,'r');
% legend('filtered x')
% hold on
% subplot(3,2,2)
% plot(t, gx_backup,'b');
% legend('output x')
% 
% 
% 
% subplot(3,2,3)
% plot(t, gy,'r');
% legend('filtered y')
% hold on
% subplot(3,2,4)
% plot(t, gy_backup,'b');
% legend('output y')
% 
% 
% subplot(3,2,5)
% plot(t, gz,'r');
% legend('filtered z')
% hold on
% subplot(3,2,6)
% plot(t, gz_backup,'b');
% legend('output z')

    
    
        
        
        
        
        
                
        
        
        
        

