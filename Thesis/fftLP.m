X = fft(true_acc(:,1));

Xf = X;

Xf(1) = 

k = myfft(X,dt);

%L = length(true_acc); %Signal length

M = 256;

x = zeros(L,1);

n = 0:M-1;

L = 257; %filter length

fc = 100;

blo = fir1(12,0.01,chebwin(35,30));
outlo = filter(blo,1,true_acc(:,1));

plot(true_acc(:,1),'r');
hold on;
plot(outlo,'b');


    
    


