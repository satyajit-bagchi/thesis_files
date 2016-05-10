%% Simple Kalman

%Code assumes gravity subtracted accelerations are in vectors called true_acc_x,
%y etc.

%State vector = [x x_dot x_dot_dot y y_dot y_dot_dot z z_dot z_dot_dot]
struct_init_Kalman;
n = length(ax);
delta_t = 1/mpu_sampling_frequency;

%% Initialization


zxs = []; %Measured positions
zys = [];
zzs= [];

zaxs = []; %Measured accelerations
zays = [];
zazs = [];

xxs = []; %Estimated positions
xys = [];
xzs = [];


xvxs = []; %Estimated velocities
xvys = [];
xvzs = [];

xaxs = []; %Estimated accelerations
xays = [];
xazs = [];

residual_xxs = [];
residual_xys = [];
residual_xzs = [];

pxs = [];
pys = [];
pzs = [];



likelihoods = [];


iterations = n;

for i = 1:iterations
    
    if(zupt(i)==1)
        s.x(2) = 0;
        s.x(5) = 0;
        s.x(8) = 0;
    end
    
    s.z = true_acc(i,:)'; %Take the ith row of a matrix of measurements X
    
    
    zax = s.z(1);
    zay = s.z(2);
    zaz = s.z(3);
    
    xx = s.x(1); %Estimated position x
    xvx = s.x(2); %Estimated velocity v
    xax = s.x(3); %Estimated acceleration x
    
    xy = s.x(4); %Estimated position y
    xvy = s.x(5); %Estimated velocity y
    xay = s.x(6); %Estimated acceleration y
    
    xz = s.x(7); %Estimated position z
    xvz = s.x(8); %Estimated velocity z
    xaz = s.x(9); %Estimated acceleration z
    
    
    p = diag(s.P);
    
    px = p(1);
    pvx = p(2);
    pax = p(3);
    
    py = p(4);
    pvy = p(5);
    pay = p(6);
    
    pz = p(7);
    pvz = p(8);
    paz = p(9);

    
    %Append measurement to list
    zaxs = [zaxs; zax]; 
    
    %Append measurement to list
    zays = [zays; zay ];
    
    %Append measurement to list
    zazs = [zazs; zaz ];
    
    
    xxs = [xxs; xx]; %Append position estimate to list
    xys = [xys; xy]; 
    xzs = [xzs; xz]; 
    
    xvxs = [xvxs; xvx]; %Append velocity estimate to list
    xvys = [xvys; xvy]; 
    xvzs = [xvzs; xvz]; 
    
    xaxs = [xaxs; xax]; %Append acceleration estimate to list
    xays = [xays; xay];
    xazs = [xazs; xaz];
    
    pxs = [pxs; px];
    pys = [pys; py];
    pzs = [pzs; pz];
    
    
    % S = ... This is something I need to think about. calculation contains terms from previous and current state 
    s = kalmanf(s); %Update struct
    
    
    Y = s.z - s.H*s.x;
    
   % italicL = (1./(sqrt(2*pi*S))) * exp(-0.5*Y'*inv(S)*Y) %What should be
  %the dimensions of this function??
  
  
    
    
end


%% X 
subplot(3,3,1)

title ('Position X')
hold on;
grid on;


%ZXPlot= plot(zxs,'b-');

XXPlot = plot(xxs,'r-');

legend('Estimate');

subplot(3,3,4)


title ('Velocity X')
hold on;
grid on;


%ZVXPlot= plot(zvxs,'b-');

XVXPlot = plot(xvxs,'r-');

legend('Estimated Velocity');

%Acceleration

subplot(3,3,7)

title ('Acceleration X');
hold on;
grid on;


ZAXPlot= plot(zaxs,'b-');

XAXPlot = plot(xaxs,'r-');

legend('Measurement','Estimate');




%% Y 
subplot(3,3,2)

title ('Position Y')

hold on;
grid on;

XYPlot = plot(xys,'r-');

legend('Estimate');

subplot(3,3,5)

title ('Velocity X')
hold on;
grid on;

XVYPlot = plot(xvys,'r-');

legend('Estimated Velocity');

%Acceleration Y

subplot(3,3,8)

title ('Acceleration Y');
hold on;
grid on;

ZAYPlot= plot(zays,'b-');

XAYPlot = plot(xays,'r-');

legend('Measurement','Estimate');




%% Z
subplot(3,3,3)

title ('Position Z')

hold on;
grid on;

XZPlot = plot(xzs,'r-');

legend('Estimate');

subplot(3,3,6)

title ('Velocity Z')
hold on;
grid on;


%ZVZPlot= plot(zvxs,'b-');

XVZPlot = plot(xvzs,'r-');

legend('Estimated Velocity');

%Acceleration Z§

subplot(3,3,9)

title ('Acceleration Z');
hold on;
grid on;

ZAZPlot= plot(zazs,'b-');

XAZPlot = plot(xazs,'r-');

legend('Measurement','Estimate');




%% Residuals
% 
% figure
% 
% subplot(1,3,1)
% 
% title ('Residual X')
% 
% hold on;
% grid on;
% 
% PXXPlot = plot(pxs, 'mo');
% RXXPlot= plot(residual_xxs,'k-');
% 
% 
% legend('Variance','Zero Order Residual');
% 
% 
% subplot(1,3,2)
% 
% title ('Residual Y')
% 
% hold on;
% grid on;
% 
% PXYPlot = plot(pys, 'mo');
% RXYPlot= plot(residual_xys,'k-');
% 
% 
% legend('Variance','Zero Order Residual');
% 
% 
% 
% subplot(1,3,3)
% 
% title ('Residual Z')
% 
% hold on;
% grid on;
% 
% PXZPlot = plot(pzs, 'mo');
% RXZPlot= plot(residual_xzs,'k-');
% 
% 
% legend('Zero Order Residual','Variance');

