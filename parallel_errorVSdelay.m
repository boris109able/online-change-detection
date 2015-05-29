epsilon = 0.5;
step = 0.5;
count = 1;
[row, len] = size(0:step:10);
ARL = zeros(len,1);
delay = zeros(len,1);
ARLTime = zeros(len,1);
delayTime = zeros(len,1);
for B = 2:step:6
    disp(count);
    tic;
    [ARL(count), ARLTime(count)] = parallel_error(B, epsilon);
    [delay(count), delayTime(count)] = parallel_delay(B, epsilon);
    count = count + 1;
    toc;
    save('ARL','ARLTime','delay','delayTime');
end
figure(3)
semilogx(ARL,delay);
xlabel('ARL','FontSize', 16);
ylabel('Delay', 'FontSize', 16);
title('Error vs Delay','FontSize', 18);