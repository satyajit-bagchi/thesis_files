%Function based on code from Brian Douglas

function [f, amp] = myfft(data, tsamp)

Fs = 1/tsamp; %Sampling frequency
T = tsamp; %Sampling time
L = length(data);

x = data;

NFFT = 2^nextpow2(L); %Next power of 2 from length of x
y = fft(x,NFFT)/L; %Performs FFT

f = Fs/2*linspace(0,1,NFFT/2+1);%Generates frequency vector

%Plotting

amp = 2*abs(y(1:NFFT/2+1));
loglog(f,amp);
title('Single-sided Amplitude spectrum of data(t)');
xlabel('Frequency');
ylabel('|Data(f)|')
