%% NOTE:
% For the Lorenz system, h=0.08 is only stable for RK4 and GLRK 8th order
% For the Chen system, h=0.08 is unstable for all methods. This should not
% be run for the Chen system.

%% Examining statistical variation, short intervals
% For each method, integrate over periods of length 1 for 100 intervals,
% eg: [0, 1], [1, 2], [2, 3], [3, 4] ... , [99, 100]

h = 0.08;
t_exp = 0:h:300;

Z_RK4s1_008 = [];
Z_GLRK4s1_008 = [];

ax2 = subplot(1,2,1);
ax3 = subplot(1,2,2);

for i = 1:13:3738
    
    Z_RK4_0_008 = NewtonCotes14pt(z_RK4_0_08(i:i+13), h)/1.04;
    Z_GLRK4_0_008 = NewtonCotes14pt(z_GLRK_0_08(i:i+13), h)/1.04;
    
    RK4_err = (Z_RK4_0_008 - Z_true)/Z_true*100;
    GLRK4_err = (Z_GLRK4_0_008 - Z_true)/Z_true*100;
    
    Z_RK4s1_008(end+1) = RK4_err; %#ok<*SAGROW>
    Z_GLRK4s1_008(end+1) = GLRK4_err;
    
    subplot(ax2)
    plot([t_exp(i) t_exp(i+13)], [RK4_err RK4_err],'Color',[0.6350 0.0780 0.1840])
    hold on
    
    subplot(ax3)
    plot([t_exp(i) t_exp(i+13)], [GLRK4_err GLRK4_err],'Color',[0.4940 0.1840 0.5560])
    hold on
    
end

subplot(ax2)
title("Percent Error for RK4 Method, h = 0.08, T = 1.04")
xlabel("t")
ylabel("%Error from Z_{true}")
ylim([-50 30])

grid on
plot([0 300], [0 0], 'k--')

subplot(ax3)
title("Percent Error for GLRK 8^{th} Order Method, h = 0.08, T = 1.04")
xlabel("t")
ylabel("%Error from Z_{true}")
ylim([-50 30])

grid on
plot([0 300], [0 0], 'k--')

clearvars Z_Heun_0_008 Z_RK4_0_008 Z_GLRK4_0_008 Heun_err RK4_err GLRK4_err h i t_exp ax1 ax2 ax3;

%% Examining statistical variation, medium intervals
% For each method, integrate over periods of length ~10 for 10 intervals,
% eg: [0, 10], [10, 20], [20, 30] ... , [290, 300]

h = 0.08;
t_exp = 0:h:300;

Z_RK4s10_008 = [];
Z_GLRK4s10_008 = [];

ax2 = subplot(1,2,1);
ax3 = subplot(1,2,2);

for i = 1:125:3626
    
    Z_RK4_0_008 = (NewtonCotes10pt(z_RK4_0_08(i:i+117), h) + NewtonCotes9pt(z_RK4_0_08(i+117:i+125), h))/10;
    Z_GLRK4_0_008 = (NewtonCotes10pt(z_GLRK_0_08(i:i+117), h) + NewtonCotes9pt(z_GLRK_0_08(i+117:i+125), h))/10;
    
    RK4_err = (Z_RK4_0_008 - Z_true)/Z_true*100;
    GLRK4_err = (Z_GLRK4_0_008 - Z_true)/Z_true*100;
    
    Z_RK4s10_008(end+1) = RK4_err;
    Z_GLRK4s10_008(end+1) = GLRK4_err;
    
    subplot(ax2)
    plot([t_exp(i) t_exp(i+125)], [RK4_err RK4_err],'Color',[0.6350 0.0780 0.1840])
    hold on
    
    subplot(ax3)
    plot([t_exp(i) t_exp(i+125)], [GLRK4_err GLRK4_err],'Color',[0.4940 0.1840 0.5560])
    hold on
    
end

subplot(ax2)
title("Percent Error for RK4 Method, h = 0.08, T = 10")
xlabel("t")
ylabel("%Error from Z_{true}")
ylim([-3 7])

grid on
plot([0 300], [0 0], 'k--')

subplot(ax3)
title("Percent Error for GLRK 8^{th} Order Method, h = 0.08, T = 10")
xlabel("t")
ylabel("%Error from Z_{true}")
ylim([-3 7])

grid on
plot([0 300], [0 0], 'k--')

clearvars Z_Heun_0_008 Z_RK4_0_008 Z_GLRK4_0_008 Heun_err RK4_err GLRK4_err h i t_exp ax1 ax2 ax3;

%% Examining statistical variation, medium intervals
% For each method, integrate over periods of length 100 for a few intervals,
% eg: [0, 100], [50, 150], [100, 200], [150, 250], [200, 300]

h = 0.08;
t_exp = 0:h:300;

Z_RK4s50_008 = [];
Z_GLRK4s50_008 = [];

ax2 = subplot(1,2,1);
ax3 = subplot(1,2,2);

for i = 1:625:3126
    
    Z_RK4_0_008 = (NewtonCotes12pt(z_RK4_0_08(i:i+616), h) + NewtonCotes10pt(z_RK4_0_08(i+616:i+625), h))/50;
    Z_GLRK4_0_008 = (NewtonCotes12pt(z_GLRK_0_08(i:i+616), h) + NewtonCotes10pt(z_GLRK_0_08(i+616:i+625), h))/50;
    
    RK4_err = (Z_RK4_0_008 - Z_true)/Z_true*100;
    GLRK4_err = (Z_GLRK4_0_008 - Z_true)/Z_true*100;
    
    Z_RK4s50_008(end+1) = RK4_err;
    Z_GLRK4s50_008(end+1) = GLRK4_err;
    
    subplot(ax2)
    plot([t_exp(i) t_exp(i+625)], [RK4_err RK4_err],'Color',[0.6350 0.0780 0.1840])
    hold on
    
    subplot(ax3)
    plot([t_exp(i) t_exp(i+625)], [GLRK4_err GLRK4_err],'Color',[0.4940 0.1840 0.5560])
    hold on
    
end

subplot(ax2)
title("Percent Error for RK4 Method, h = 0.08, T = 50")
xlabel("t")
ylabel("%Error from Z_{true}")
ylim([-1.5 4])

grid on
plot([0 300], [0 0], 'k--')

subplot(ax3)
title("Percent Error for GLRK 8^{th} Order Method, h = 0.08, T = 50")
xlabel("t")
ylabel("%Error from Z_{true}")
ylim([-1.5 4])

grid on
plot([0 300], [0 0], 'k--')

clearvars Z_Heun_0_008 Z_RK4_0_008 Z_GLRK4_0_008 Heun_err RK4_err GLRK4_err h i t_exp ax1 ax2 ax3;

%% Cleanup
close all;