%function[ARL, timeElapsed] = parallel_error(B, epsilon)
function[error_prob, timeElapsed] = parallel_error(B, epsilon)
T = 1.0e+6;% if time exceed this T, then stop to save time
p = 20;%dimension
s = 4;%sparsity
%setting up simulation parameter
sigma1 = 1;%X variance
sigma2 = 1;%noise variance
%set MonteCarlo simulation parameters
totalRun = 1.0e+5;
ARL = 0;
sumTime = 0;

error_counter = 0;
error_prob = 2;
%begin MonteCarlo simulation
for run = 1:totalRun
    disp(run)
    tStart=tic;
    R = zeros(p,1);
    Gamma = zeros(p, 1);
    beta = zeros(p,1);
    C = zeros(p,1);
    t = 0;
    loop_counter = 0;
    error_flag = 1;
    while sum(C>B)==0
        t = t + 1;
        %disp(t)
        %coming data
        x = normrnd(0, sigma1, p, 1);
        y = normrnd(0,sigma2,1,1);
        R = R + x*y;
        Gamma = Gamma + x.*x;
        beta = Gamma.^((1+epsilon)/2);
        C = R./beta;      
        %disp(t);
        %disp(C);
        %disp("-------------------------------------------------");
        
        loop_counter = loop_counter + 1;
        if loop_counter > T
            error_flag = 0;
            break;
        end
    end
    
    if 1 == error_flag
        error_counter = error_counter + 1;
    end
        
    %ARL = ARL + t;
    tElapsed=toc(tStart);
    sumTime = sumTime + tElapsed;
end
%ARL = ARL/totalRun;
timeElapsed = sumTime/totalRun;
error_prob = error_counter / totalRun;

% testing program
T = 10^5;
test_sequence = zeros(1, T);
R = zeros(p,1);
Gamma = zeros(p, 1);
beta = zeros(p,1);

for ii = 1:T
    x = normrnd(0, sigma1, p, 1);
    y = normrnd(0, sigma2, 1, 1);
    R = R + x*y;
    Gamma = Gamma + x.*x;
    beta = Gamma.^((1+epsilon)/2);
    C = R./beta;
    test_sequence(ii) = C(1);
end

figure(1)
plot(1:T, test_sequence);
xlabel('Time Instance','fontsize',20)
ylabel('Value of Statistic','fontsize',20)
title('the evolution of statistic under H0','fontsize',20)
end