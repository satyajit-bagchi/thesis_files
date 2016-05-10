latitude = 59.369951;
longitude = 18.064004;
mag_sensitivity = 0.6; %uT / LSB

Comp_Z = Comp_Z(1:25866);
time_mag = 0:1/200:25866/200;
time_mag=time_mag(1:end-1);
plot(time_mag, Comp_Z*0.6);
