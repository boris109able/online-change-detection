function[delay, timeElapsed] = parallel_delay(B, epsilon)
T = 1.0e+5;% if time exceed this T, then stop to save time
p = 20;%dimension
s = 4;%sparsity
%setting up simulation parameter
sigma1 = 1;%X variance
sigma2 = 1;%noise variance
%setting alpha1
alpha1 = zeros(p,1);
alpha1(1:2*s) = 0.5;
%set MonteCarlo simulation parameters
totalRun = 1.0e+05;
error = 0;
sumTime = 0;
sumDelay = 0;
%begin MonteCarlo simulation
for run = 1:totalRun
    tStart=tic;
    tdelay = 0;
    R = zeros(p,1);
    Gamma = zeros(p, 1);
    beta = zeros(p,1);
    for t = 1:T
        %coming data
        x = normrnd(0, sigma1, p, 1);
        y = alpha1'*x+normrnd(0,sigma2,1,1);
        R = R + x*y;
        Gamma = Gamma + x.*x;
        beta = Gamma.^((1+epsilon)/2);
        C = R./beta;
        if sum(C>B)>0
            tdelay = t;
            break;
        end
    end
    if tdelay==0
        tdelay = T;
    end
    sumDelay = sumDelay + tdelay;
    tElapsed=toc(tStart);
    sumTime = sumTime + tElapsed;
end
delay = sumDelay/totalRun;
timeElapsed = sumTime/totalRun;

% % testing program
% T = 10^5;
% test_sequence = zeros(1, T);
% R = zeros(p,1);
% Gamma = zeros(p, 1);
% beta = zeros(p,1);
% 
% for ii = 1:T
%     x = normrnd(0, sigma1, p, 1);
%     y = alpha1'*x+normrnd(0,sigma2,1,1);
%     R = R + x*y;
%     Gamma = Gamma + x.*x;
%     beta = Gamma.^((1+epsilon)/2);
%     C = R./beta;
%     test_sequence(ii) = C(1);
% end
% 
% figure(2)
% plot(1:T, test_sequence);
% xlabel('Time Instance','fontsize',20)
% ylabel('Value of Statistic','fontsize',20)
% title('the evolution of statistic under H0','fontsize',20)
end