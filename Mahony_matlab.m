%%  Mahony's filter - Matlab implementation
gx = gx_backup;
gy = gy_backup;
gz = gz_backup;

fs = 1;
fs = mpu_sampling_frequency;
twoKp = 2*1;
twoKi = 2*5;

integralFBx = 0;
integralFBy = 0;
integralFBz = 0;

n = length(ax);

gx = gx * pi/180;
gy = gy * pi/180;
gz = gz * pi/180;


% q0 = [];
% q1 = [];
% q2 = [];
% q3 = [];
%
% q0 = [1.0 q0];
% q1 = [0.0 q1];
% q2 = [0.0 q2];
% q3 = [0.0 q3];



q0 = 1;
q1 = 0;
q2 = 0;
q3 = 0;

q0_list = [];
q1_list = [];
q2_list = [];
q3_list = [];

rNorm = 1;


for i=1:n
    
    %%Normalizing accelerometer measurement
    
    if((0~=ax(i))&&(0~=ay(i))&&(0~=az(i)))
        
        rNorm = 1/sqrt(ax(i)^2 + ay(i)^2 + az(i)^2);
        ax(i) = ax(i)*rNorm;
        ay(i) = ay(i)*rNorm;
        az(i) = az(i)*rNorm;
        
        %%Estimate direction of gravity
        
        halfvx = q1 * q3 - q0 * q2;
        halfvy = q0 * q1 + q2 * q3;
        halfvz = q0 * q0 - 0.5 + q3 * q3;
        
        halfex = (ay(i) * halfvz - az(i) * halfvy);
        halfey = (az(i) * halfvx - ax(i) * halfvz);
        halfez = (ax(i) * halfvy - ay(i) * halfvx);
        
        
        integralFBx = twoKi*halfex * (1.0/fs);
        integralFBy = twoKi*halfey * (1.0/fs);
        integralFBz = twoKi*halfez * (1.0/fs);
        
        %%Proportional feedback
        gx(i) = gx(i) + twoKp * halfex;
        gy(i) = gy(i) + twoKp * halfey;
        gz(i) = gz(i) + twoKp * halfez;
    end
    %%Integrate rate of change
    
    gx(i) = gx(i) * (0.5*(1/fs));
    gy(i) = gy(i) * (0.5*(1/fs));
    gz(i) = gz(i) * (0.5*(1/fs));
    
    qa = q0;
    qb = q1;
    qc = q2;
    
    q0 = q0 + (-qb * gx(i) - qc * gy(i) - q3 * gz(i));
    q1 = q1 + (qa * gx(i) + qc * gz(i) - q3* gy(i));
    q2 = q2 + (qa * gy(i) - qb * gz(i) + q3* gx(i));
    q3 = q3 + (qa * gz(i) + qb * gy(i) - qc * gx(i));
    
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
plot(eul);
legend('Z','Y','X')



