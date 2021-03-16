%% NOTE:
% For the Lorenz system, h=0.16 is only stable for GLRK 8th order
% All methods unstable for Chen system, this should not be run.

%% Examining statistical variation, short intervals
% For each method, integrate over periods of length 1 for 100 intervals,
% eg: [0, 1], [1, 2], [2, 3], [3, 4] ... , [99, 100]

h = 0.16;
t_exp = 0:h:300;

Z_GLRK4s1_016 = [];

for i = 1:6:1870
    
    Z_GLRK4_0_016 = NewtonCotes7pt(z_GLRK_0_16(i:i+6), h)/0.96;
    
    GLRK4_err = (Z_GLRK4_0_016 - Z_true)/Z_true*100;
    
    Z_GLRK4s1_016(end+1) = GLRK4_err; %#ok<*SAGROW>
    
    plot([t_exp(i) t_exp(i+6)], [GLRK4_err GLRK4_err],'Color',[0.4940 0.1840 0.5560])
    hold on
    
end

title("Percent Error for GLRK 8^{th} Order Method, h = 0.16, T = 1.04")
xlabel("t")
ylabel("%Error from Z_{true}")
ylim([-50 30])

grid on
plot([0 300], [0 0], 'k--')

clearvars Z_Heun_0_016 Z_RK4_0_016 Z_GLRK4_0_016 Heun_err RK4_err GLRK4_err h i t_exp ax1 ax2 ax3;

%% Examining statistical variation, medium intervals
% For each method, integrate over periods of length ~10 for 10 intervals,
% eg: [0, 10], [10, 20], [20, 30] ... , [290, 300]

h = 0.16;
t_exp = 0:h:300;

Z_GLRK4s10_016 = [];

for i = 1:63:1827
    
    Z_GLRK4_0_016 = NewtonCotes10pt(z_GLRK_0_16(i:i+63), h)/10.08;
    
    GLRK4_err = (Z_GLRK4_0_016 - Z_true)/Z_true*100;
    
    Z_GLRK4s10_016(end+1) = GLRK4_err;
    
    plot([t_exp(i) t_exp(i+63)], [GLRK4_err GLRK4_err],'Color',[0.4940 0.1840 0.5560])
    hold on
    
end

title("Percent Error for GLRK 8^{th} Order Method, h = 0.16, T = 10.08")
xlabel("t")
ylabel("%Error from Z_{true}")
ylim([-3 7])

grid on
plot([0 300], [0 0], 'k--')

clearvars Z_GLRK4_0_016 GLRK4_err h i t_exp;

%% Examining statistical variation, medium intervals
% For each method, integrate over periods of length 100 for a few intervals,
% eg: [0, 100], [50, 150], [100, 200], [150, 250], [200, 300]

h = 0.16;
t_exp = 0:h:300;

Z_GLRK4s50_016 = [];

for i = 1:312:1564
    
    Z_GLRK4_0_016 = NewtonCotes13pt(z_GLRK_0_16(i:i+312), h)/49.92;
    
    GLRK4_err = (Z_GLRK4_0_016 - Z_true)/Z_true*100;
    
    Z_GLRK4s50_016(end+1) = GLRK4_err;
    
    plot([t_exp(i) t_exp(i+312)], [GLRK4_err GLRK4_err],'Color',[0.4940 0.1840 0.5560])
    hold on
    
end

title("Percent Error for GLRK 8^{th} Order Method, h = 0.16, T = 49.92")
xlabel("t")
ylabel("%Error from Z_{true}")
ylim([-1.5 4])

grid on
plot([0 300], [0 0], 'k--')

clearvars Z_GLRK4_0_016 GLRK4_err h i t_exp;

%% Cleanup
close all;