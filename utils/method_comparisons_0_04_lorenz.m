%% NOTE:
% Stable for all methods in Lorenz system
% Stable for RK4 and GLRK for Chen, but NOT Heun's

%% Examining statistical variation, short intervals
% For each method, integrate over periods of length 1 for 100 intervals,
% eg: [0, 1], [1, 2], [2, 3], [3, 4] ... , [99, 100]

h = 0.04;
t_exp = 0:h:300;

Z_Heuns1_004 = [];
Z_RK4s1_004 = [];
Z_GLRK4s1_004 = [];

ax1 = subplot(1,3,1);
ax2 = subplot(1,3,2);
ax3 = subplot(1,3,3);

for i = 1:25:7476
    
    Z_Heun_0_004 = NewtonCotes6pt(z_Heun_0_04(i:i+25), h)/1;
    Z_RK4_0_004 = NewtonCotes6pt(z_RK4_0_04(i:i+25), h)/1;
    Z_GLRK4_0_004 = NewtonCotes6pt(z_GLRK_0_04(i:i+25), h)/1;
    
    Heun_err = (Z_Heun_0_004 - Z_true)/Z_true*100;
    RK4_err = (Z_RK4_0_004 - Z_true)/Z_true*100;
    GLRK4_err = (Z_GLRK4_0_004 - Z_true)/Z_true*100;
    
    Z_Heuns1_004(end+1) = Heun_err; %#ok<*SAGROW>
    Z_RK4s1_004(end+1) = RK4_err; %#ok<*SAGROW>
    Z_GLRK4s1_004(end+1) = GLRK4_err;
    
    subplot(ax1)
    plot([t_exp(i) t_exp(i+25)], [Heun_err Heun_err],'Color',[0 0.4470 0.7410])
    hold on
    
    subplot(ax2)
    plot([t_exp(i) t_exp(i+25)], [RK4_err RK4_err],'Color',[0.6350 0.0780 0.1840])
    hold on
    
    subplot(ax3)
    plot([t_exp(i) t_exp(i+25)], [GLRK4_err GLRK4_err],'Color',[0.4940 0.1840 0.5560])
    hold on
    
end

subplot(ax1)
title("Percent Error for Heun's Method, h = 0.04, T = 1")
xlabel("t")
ylabel("%Error from Z_{true}")
ylim([-50 30])

grid on
plot([0 300], [0 0], 'k--')

subplot(ax2)
title("Percent Error for RK4 Method, h = 0.04, T = 1")
xlabel("t")
ylabel("%Error from Z_{true}")
ylim([-50 30])

grid on
plot([0 300], [0 0], 'k--')

subplot(ax3)
title("Percent Error for GLRK 8^{th} Order Method, h = 0.04, T = 1")
xlabel("t")
ylabel("%Error from Z_{true}")
ylim([-50 30])

grid on
plot([0 300], [0 0], 'k--')

clearvars Z_Heun_0_004 Z_RK4_0_004 Z_GLRK4_0_004 Heun_err RK4_err GLRK4_err h i t_exp ax1 ax2 ax3;

%% Examining statistical variation, medium intervals
% For each method, integrate over periods of length ~10 for 10 intervals,
% eg: [0, 10], [10, 20], [20, 30] ... , [290, 300]

h = 0.04;
t_exp = 0:h:300;

Z_Heuns10_004 = [];
Z_RK4s10_004 = [];
Z_GLRK4s10_004 = [];

ax1 = subplot(1,3,1);
ax2 = subplot(1,3,2);
ax3 = subplot(1,3,3);

for i = 1:250:7251
    
    Z_Heun_0_004 = NewtonCotes11pt(z_Heun_0_04(i:i+250), h)/10;
    Z_RK4_0_004 = NewtonCotes11pt(z_RK4_0_04(i:i+250), h)/10;
    Z_GLRK4_0_004 = NewtonCotes11pt(z_GLRK_0_04(i:i+250), h)/10;
    
    Heun_err = (Z_Heun_0_004 - Z_true)/Z_true*100;
    RK4_err = (Z_RK4_0_004 - Z_true)/Z_true*100;
    GLRK4_err = (Z_GLRK4_0_004 - Z_true)/Z_true*100;
    
    Z_Heuns10_004(end+1) = Heun_err;
    Z_RK4s10_004(end+1) = RK4_err;
    Z_GLRK4s10_004(end+1) = GLRK4_err;
    
    subplot(ax1)
    plot([t_exp(i) t_exp(i+250)], [Heun_err Heun_err],'Color',[0 0.4470 0.7410])
    hold on
    
    subplot(ax2)
    plot([t_exp(i) t_exp(i+250)], [RK4_err RK4_err],'Color',[0.6350 0.0780 0.1840])
    hold on
    
    subplot(ax3)
    plot([t_exp(i) t_exp(i+250)], [GLRK4_err GLRK4_err],'Color',[0.4940 0.1840 0.5560])
    hold on
    
end

subplot(ax1)
title("Percent Error for Heun's Method, h = 0.04, T = 10")
xlabel("t")
ylabel("%Error from Z_{true}")
ylim([-3 7])

grid on
plot([0 300], [0 0], 'k--')

subplot(ax2)
title("Percent Error for RK4 Method, h = 0.04, T = 10")
xlabel("t")
ylabel("%Error from Z_{true}")
ylim([-3 7])

grid on
plot([0 300], [0 0], 'k--')

subplot(ax3)
title("Percent Error for GLRK 8^{th} Order Method, h = 0.04, T = 10")
xlabel("t")
ylabel("%Error from Z_{true}")
ylim([-3 7])

grid on
plot([0 300], [0 0], 'k--')

clearvars Z_Heun_0_004 Z_RK4_0_004 Z_GLRK4_0_004 Heun_err RK4_err GLRK4_err h i t_exp ax1 ax2 ax3;

%% Examining statistical variation, medium intervals
% For each method, integrate over periods of length 100 for a few intervals,
% eg: [0, 100], [50, 150], [100, 200], [150, 250], [200, 300]

h = 0.04;
t_exp = 0:h:300;

Z_Heuns50_004 = [];
Z_RK4s50_004 = [];
Z_GLRK4s50_004 = [];

ax1 = subplot(1,3,1);
ax2 = subplot(1,3,2);
ax3 = subplot(1,3,3);

for i = 1:1250:6251
    
    Z_Heun_0_004 = NewtonCotes11pt(z_Heun_0_04(i:i+1250), h)/50;
    Z_RK4_0_004 = NewtonCotes11pt(z_RK4_0_04(i:i+1250), h)/50;
    Z_GLRK4_0_004 = NewtonCotes11pt(z_GLRK_0_04(i:i+1250), h)/50;
    
    Heun_err = (Z_Heun_0_004 - Z_true)/Z_true*100;
    RK4_err = (Z_RK4_0_004 - Z_true)/Z_true*100;
    GLRK4_err = (Z_GLRK4_0_004 - Z_true)/Z_true*100;
    
    Z_Heuns50_004(end+1) = Heun_err;
    Z_RK4s50_004(end+1) = RK4_err;
    Z_GLRK4s50_004(end+1) = GLRK4_err;
    
    subplot(ax1)
    plot([t_exp(i) t_exp(i+1250)], [Heun_err Heun_err],'Color',[0 0.4470 0.7410])
    hold on
    
    subplot(ax2)
    plot([t_exp(i) t_exp(i+1250)], [RK4_err RK4_err],'Color',[0.6350 0.0780 0.1840])
    hold on
    
    subplot(ax3)
    plot([t_exp(i) t_exp(i+1250)], [GLRK4_err GLRK4_err],'Color',[0.4940 0.1840 0.5560])
    hold on
    
end

subplot(ax1)
title("Percent Error for Heun's Method, h = 0.04, T = 50")
xlabel("t")
ylabel("%Error from Z_{true}")
ylim([-1.5 4])

grid on
plot([0 300], [0 0], 'k--')

subplot(ax2)
title("Percent Error for RK4 Method, h = 0.04, T = 50")
xlabel("t")
ylabel("%Error from Z_{true}")
ylim([-1.5 4])

grid on
plot([0 300], [0 0], 'k--')

subplot(ax3)
title("Percent Error for GLRK 8^{th} Order Method, h = 0.04, T = 50")
xlabel("t")
ylabel("%Error from Z_{true}")
ylim([-1.5 4])

grid on
plot([0 300], [0 0], 'k--')

clearvars Z_Heun_0_004 Z_RK4_0_004 Z_GLRK4_0_004 Heun_err RK4_err GLRK4_err h i t_exp ax1 ax2 ax3;

%% Cleanup
close all;