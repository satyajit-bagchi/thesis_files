if(length(gyroSim)>length(adis))
    gyroSim = gyroSim(1:end-1);
end
figure(1)
plot(time,[gyroSim, adis])
legend('Sim', 'Real');
figure(2)
[f, amp] = myfft(adisNoBias*0.01,1/819.2);
hold on;
[f, amp] = myfft(gyroSimNoBias*0.01,1/819.2);

%[tau, AVAR] = allan(time, adisNoBias*0.025);