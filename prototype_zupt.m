W = 3;

sigma = 0.1*pi/180;
T = zeros(1,n-W+1)

gx = gx * pi/180;
gy = gy * pi/180;
gz = gz * pi/180;

for k=1:n-W+1
    for l = k:k + W -1
        T(k) = norm([gx(l) gy(l) gz(l)])^2;
    end
end

T = T./sigma;

plot(T);

