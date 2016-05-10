%% Height tracking
Stm_constants;

fclose(s)

s = serial('COM9','Baudrate',115200);

fopen(s);

list = [];

az_list = [];

ht_list = [];

estimate_list =[];

%% Kalman boilerplate code

delta_t = 1/fs;

struct.x = [0 %height
            0 %velocity
            0];%acceleration 
   
struct.A = [1 delta_t 0.5*delta_t^2 
            0 1       delta_t
            0 0         1];

struct.B = [0];
    
struct.P = 0.5*eye(3);
    
struct.u = 0;

struct.H = [1 0 0
            0 0 1];

struct.z = [0; 0];

struct.R = [100*stm_barometer_std 0 
             0                  0.008^2];

struct.Q = 10e-6*eye(3);



    
    

   
   
   

for i=1:1000000000
    read_data = fscanf(s,'%d %d %d %d.%02d'); %Read gyro
    %read_data = fscanf(s);
    if(length(read_data)~=5 || isnan(read_data(1)))
        gx = 0;
        gy = 0;
        gz = 0;
        
        ax = -0.1;
        ay = 0.1;
        az = 1;
        
        bar = 0;
        
        disp('if');
        
    else
        
        ax = (read_data(1)-stm_ax_bias)*1e-3; %m/s/s
        ay = (read_data(2)-stm_ay_bias)*1e-3;
        az = (read_data(3)-stm_az_bias)*1e-3;
        
        %az = read_data(3);
        
        
        
        %disp(az);
        %disp('Entered');
        bar = read_data(4) + read_data(5)/100;
        
        bar = bar;
        
        delta_h = 44330*(1-(bar*100/10132.5)^0.190284);
        
        delta_h = delta_h +2.4490320e4;
        
        ht_list = [ht_list; delta_h];
        
        %disp(delta_h);
        
        list = [list; delta_h];
        
        
        %delta_h = delta_h/3.28083; %ft to m;
        %delta_h = delta_h - 3.5104e04;
        az = (az-0.996)*9.81;
        
        az_list = [az_list az];
        %disp(delta_h);
        %disp(struct.x(1));
        
        struct.z = [delta_h; az];
        
        struct.u = 0; %m/s/s;
        
        %disp(struct.u)
        
        struct = kalmanf(struct);
        
        %disp(struct.z)
        disp(struct.x(1));
        
        estimate_list = [estimate_list; struct.x(1)];
        
        %bar = bar-stm_barometer_bias; 
        
    end
    
    %disp(delta_h);
    
end
        

plot(estimate_list)
hold on
plot(ht_list)

plot(az_list)
legend('estimate','pressure', 'acceleration');

