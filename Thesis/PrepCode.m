%% Variables

sampling_frequency = 819.2; %Hz
collection_time = 180; %Seconds
gyro_sensitivity = 0.01; % dps/LSB
gyro_bias = 0.9140; %degrees
gyro_noise_density = 0.011; %dps/rtHz
gyroscope_wn = 17.5e3; %Khz
lp_cutoff = 400; %Hz
w=lp_cutoff*2*pi;
zeta = 0.5;
%zeta = sqrt(2)/2; %Temp value
z = zeta;

%% Calculations
time = 0:1/sampling_frequency:collection_time;

if length(time)>length(adis)
    time = time(1:end-1);
end
    


%% Clip data

%adis = adis(1:length(time));
adisNoBias = adis - mean(adis);

dStruct.freq = adisNoBias;
dStruct.time = time;

wn = gyroscope_wn;
w = lp_cutoff*2*pi;


%% Plotting
plot(time, adis);

%[tau, AVAR] = allan(time, data);

