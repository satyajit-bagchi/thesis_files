%% Visualization code

Stm_constants;
axas = axes('XLim',[-5.5 5.5],'YLim',[-5.5 5.5],'ZLim',[-5.5 5.5]);
view(3)
grid on
box on
vert = [1 1 1; 1 2 1; 2 2 1; 2 1 1 ; ...
    1 1 2;1 2 2; 2 2 2;2 1 2]-1.5;
fac = [1 2 3 4
    2 6 7 3;
    4 3 7 8
    1 5 8 4
    1 2 6 5
    5 6 7 8];
h = patch('Faces',fac,'Vertices',vert,'FaceColor','r');  % patch function

t = hgtransform('Parent',axas);
set(h,'Parent',t)

Rz = eye(4);

%% Mahony boilerplate

fs = stm_sampling_frequency;
twoKp = 2*5;
twoKi = 2*2;

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



%% Serial init code
s = serial('COM9','Baudrate',115200);

fopen(s);

%% Loop

for i=1:5127
    read_data = fscanf(s,'%d %d %d %d %d %d'); %Read gyro
    
    if(length(read_data)~=6 || isnan(read_data(1)))
        gx = 0;
        gy = 0;
        gz = 0;
        
        ax = -0.1;
        ay = 0.1;
        az = 1;
        
    else
        
        ax = (read_data(1)-stm_ax_bias)*10e-3; %m/s/s
        ay = (read_data(2)-stm_ay_bias)*10e-3;
        az = (read_data(3)-stm_az_bias)*10e-3;
        
        gx = (read_data(4)-stm_gx_bias)*10e-3*pi/180; %radians/second
        gy = (read_data(5)-stm_gy_bias)*10e-3*pi/180;
        gz = (read_data(6)-stm_gz_bias)*10e-3*pi/180;
        
        %gz = 0;
        
        %gx = gx_backup(i)*pi/180;
        %gy = gy_backup(i)*pi/180;
        %gz = gz_backup(i)*pi/180;
        
        %ax = ax_list(i);
        %ay = ay_list(i);
        %az = az_list(i);
        
    end
    
    rNorm = 1/sqrt(ax^2 + ay^2 + az^2);
    ax = ax*rNorm;
    ay = ay*rNorm;
    az = az*rNorm;
    
    %%Estimate direction of gravity
    
    halfvx = q1 * q3 - q0 * q2;
    halfvy = q0 * q1 + q2 * q3;
    halfvz = q0 * q0 - 0.5 + q3 * q3;
    
    halfex = (ay * halfvz - az * halfvy);
    halfey = (az * halfvx - ax * halfvz);
    halfez = (ax * halfvy - ay * halfvx);
    
    
    integralFBx = twoKi*halfex * (1.0/fs);
    integralFBy = twoKi*halfey * (1.0/fs);
    integralFBz = twoKi*halfez * (1.0/fs);
    
    %%Proportional feedback
    gx = gx + twoKp * halfex;
    gy = gy + twoKp * halfey;
    gz = gz + twoKp * halfez;
    
    
    %%Integrate rate of change
    
    gx = gx * (0.5*(1/fs));
    gy = gy * (0.5*(1/fs));
    gz = gz * (0.5*(1/fs));
    
    qa = q0;
    qb = q1;
    qc = q2;
    
    q0 = q0 + (-qb * gx - qc * gy - q3 * gz);
    q1 = q1 + (qa * gx + qc * gz - q3* gy);
    q2 = q2 + (qa * gy - qb * gz + q3* gx);
    q3 = q3 + (qa * gz + qb * gy - qc * gx);
    
    rNorm = 1/sqrt(q0^2 + q1^2 + q2^2 + q3^2);
    
    q0 = q0*rNorm;
    q1 = q1*rNorm;
    q2 = q2*rNorm;
    q3 = q3*rNorm;
    
    q0_list = [q0_list q0];
    q1_list = [q1_list q1];
    q2_list = [q2_list q2];
    q3_list = [q3_list q3];
    
    new_quaternion = [q0 q1 q2 q3];
    
    eul = quat2eul(new_quaternion,'ZYX');
    
    
    Rz = eul2rotm([eul(1) eul(2) eul(3)],'ZYX');
    transform = rotm2tform(Rz);
    
    % Scaling matrix
    %Sxy = makehgtform('scale',r/4);
    % Concatenate the transforms and
    % set the transform Matrix property
    set(t,'Matrix',transform)
    drawnow
    
    %delay(1)
end
