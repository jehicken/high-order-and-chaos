%% Stats matrix builder
% Used for Lorenz system specifically with 8 step sizes:
% 0.32, 0.16, 0.08, 0.04, 0.04/2, 0.04/2^6, 0.04/2^7, 0.04/16
% Different matrix for Chen system since methods unstable at different times

% For each combination of method, time-step, and integration period, we
% would like to know some statistics about the time-averages produced by
% that combination. For convenience, those statistics will be assembled in
% two three-dimensional array which differ in how the statistics are
% ordered.
%
% In each array, the third dimension refers to the method used. So the
% first "layer" is a submatrix belonging to Heun's, the second layer is a
% submatrix belonging to RK4, and the third layer belongs to GLRK(4)
%
% The data contained in a row of a submatrix are, in order:
%    Step Size (or Integration Period)
%    Integration Period (or Step Size)
%    Mean
%    Standard Deviation
%    Distance b/w 2nd and 1st Quartile
%    Distance b/w 3rd and 2nd Quartile
%    2nd Quartile
%
% In StatsSorted_T, Step Size is first and Integration Period is second. 
% In StatsSorted_h, Integration Period is first and Step Size is second.
% This distinction will more easily allow us to plot the data later on.
%
% The information in Table 2 may be read from the first 4 columns of 
% each layer of the StatsSorted_T matrix. 
%

h = 0.32;

StatsSorted_T = zeros(24,7,3);
StatsSorted_h = zeros(24,7,3);

% Define the Quartiles

% Heun's unstable for h > 0.04
quant = quantile(abs(Z_Heuns1_004),[0.25,0.5,0.75]);
Q1H_1_004 = quant(1);
Q2H_1_004 = quant(2);
Q3H_1_004 = quant(3);
quant = quantile(abs(Z_Heuns10_004),[0.25,0.5,0.75]);
Q1H_10_004 = quant(1);
Q2H_10_004 = quant(2);
Q3H_10_004 = quant(3);
quant = quantile(abs(Z_Heuns50_004),[0.25,0.5,0.75]);
Q1H_50_004 = quant(1);
Q2H_50_004 = quant(2);
Q3H_50_004 = quant(3);
quant = quantile(abs(Z_Heuns1_002),[0.25,0.5,0.75]);
Q1H_1_002 = quant(1);
Q2H_1_002 = quant(2);
Q3H_1_002 = quant(3);
quant = quantile(abs(Z_Heuns10_002),[0.25,0.5,0.75]);
Q1H_10_002 = quant(1);
Q2H_10_002 = quant(2);
Q3H_10_002 = quant(3);
quant = quantile(abs(Z_Heuns50_002),[0.25,0.5,0.75]);
Q1H_50_002 = quant(1);
Q2H_50_002 = quant(2);
Q3H_50_002 = quant(3);
quant = quantile(abs(Z_Heuns1_001),[0.25,0.5,0.75]);
Q1H_1_001 = quant(1);
Q2H_1_001 = quant(2);
Q3H_1_001 = quant(3);
quant = quantile(abs(Z_Heuns10_001),[0.25,0.5,0.75]);
Q1H_10_001 = quant(1);
Q2H_10_001 = quant(2);
Q3H_10_001 = quant(3);
quant = quantile(abs(Z_Heuns50_001),[0.25,0.5,0.75]);
Q1H_50_001 = quant(1);
Q2H_50_001 = quant(2);
Q3H_50_001 = quant(3);
quant = quantile(abs(Z_Heuns1_0005),[0.25,0.5,0.75]);
Q1H_1_0005 = quant(1);
Q2H_1_0005 = quant(2);
Q3H_1_0005 = quant(3);
quant = quantile(abs(Z_Heuns10_0005),[0.25,0.5,0.75]);
Q1H_10_0005 = quant(1);
Q2H_10_0005 = quant(2);
Q3H_10_0005 = quant(3);
quant = quantile(abs(Z_Heuns50_0005),[0.25,0.5,0.75]);
Q1H_50_0005 = quant(1);
Q2H_50_0005 = quant(2);
Q3H_50_0005 = quant(3);
quant = quantile(abs(Z_Heuns1_00025),[0.25,0.5,0.75]);
Q1H_1_00025 = quant(1);
Q2H_1_00025 = quant(2);
Q3H_1_00025 = quant(3);
quant = quantile(abs(Z_Heuns10_00025),[0.25,0.5,0.75]);
Q1H_10_00025 = quant(1);
Q2H_10_00025 = quant(2);
Q3H_10_00025 = quant(3);
quant = quantile(abs(Z_Heuns50_00025),[0.25,0.5,0.75]);
Q1H_50_00025 = quant(1);
Q2H_50_00025 = quant(2);
Q3H_50_00025 = quant(3);

% RK4 unstable for h > 0.08
quant = quantile(abs(Z_RK4s1_008),[0.25,0.5,0.75]);
Q1R_1_008 = quant(1);
Q2R_1_008 = quant(2);
Q3R_1_008 = quant(3);
quant = quantile(abs(Z_RK4s10_008),[0.25,0.5,0.75]);
Q1R_10_008 = quant(1);
Q2R_10_008 = quant(2);
Q3R_10_008 = quant(3);
quant = quantile(abs(Z_RK4s50_008),[0.25,0.5,0.75]);
Q1R_50_008 = quant(1);
Q2R_50_008 = quant(2);
Q3R_50_008 = quant(3);
quant = quantile(abs(Z_RK4s1_004),[0.25,0.5,0.75]);
Q1R_1_004 = quant(1);
Q2R_1_004 = quant(2);
Q3R_1_004 = quant(3);
quant = quantile(abs(Z_RK4s10_004),[0.25,0.5,0.75]);
Q1R_10_004 = quant(1);
Q2R_10_004 = quant(2);
Q3R_10_004 = quant(3);
quant = quantile(abs(Z_RK4s50_004),[0.25,0.5,0.75]);
Q1R_50_004 = quant(1);
Q2R_50_004 = quant(2);
Q3R_50_004 = quant(3);
quant = quantile(abs(Z_RK4s1_002),[0.25,0.5,0.75]);
Q1R_1_002 = quant(1);
Q2R_1_002 = quant(2);
Q3R_1_002 = quant(3);
quant = quantile(abs(Z_RK4s10_002),[0.25,0.5,0.75]);
Q1R_10_002 = quant(1);
Q2R_10_002 = quant(2);
Q3R_10_002 = quant(3);
quant = quantile(abs(Z_RK4s50_002),[0.25,0.5,0.75]);
Q1R_50_002 = quant(1);
Q2R_50_002 = quant(2);
Q3R_50_002 = quant(3);
quant = quantile(abs(Z_RK4s1_001),[0.25,0.5,0.75]);
Q1R_1_001 = quant(1);
Q2R_1_001 = quant(2);
Q3R_1_001 = quant(3);
quant = quantile(abs(Z_RK4s10_001),[0.25,0.5,0.75]);
Q1R_10_001 = quant(1);
Q2R_10_001 = quant(2);
Q3R_10_001 = quant(3);
quant = quantile(abs(Z_RK4s50_001),[0.25,0.5,0.75]);
Q1R_50_001 = quant(1);
Q2R_50_001 = quant(2);
Q3R_50_001 = quant(3);
quant = quantile(abs(Z_RK4s1_0005),[0.25,0.5,0.75]);
Q1R_1_0005 = quant(1);
Q2R_1_0005 = quant(2);
Q3R_1_0005 = quant(3);
quant = quantile(abs(Z_RK4s10_0005),[0.25,0.5,0.75]);
Q1R_10_0005 = quant(1);
Q2R_10_0005 = quant(2);
Q3R_10_0005 = quant(3);
quant = quantile(abs(Z_RK4s50_0005),[0.25,0.5,0.75]);
Q1R_50_0005 = quant(1);
Q2R_50_0005 = quant(2);
Q3R_50_0005 = quant(3);
quant = quantile(abs(Z_RK4s1_00025),[0.25,0.5,0.75]);
Q1R_1_00025 = quant(1);
Q2R_1_00025 = quant(2);
Q3R_1_00025 = quant(3);
quant = quantile(abs(Z_RK4s10_00025),[0.25,0.5,0.75]);
Q1R_10_00025 = quant(1);
Q2R_10_00025 = quant(2);
Q3R_10_00025 = quant(3);
quant = quantile(abs(Z_RK4s50_00025),[0.25,0.5,0.75]);
Q1R_50_00025 = quant(1);
Q2R_50_00025 = quant(2);
Q3R_50_00025 = quant(3);

% GLRK unstabe for h > 0.32
quant = quantile(abs(Z_GLRK4s1_032),[0.25,0.5,0.75]);
Q1G_1_032 = quant(1);
Q2G_1_032 = quant(2);
Q3G_1_032 = quant(3);
quant = quantile(abs(Z_GLRK4s10_032),[0.25,0.5,0.75]);
Q1G_10_032 = quant(1);
Q2G_10_032 = quant(2);
Q3G_10_032 = quant(3);
quant = quantile(abs(Z_GLRK4s50_032),[0.25,0.5,0.75]);
Q1G_50_032 = quant(1);
Q2G_50_032 = quant(2);
Q3G_50_032 = quant(3);
quant = quantile(abs(Z_GLRK4s1_016),[0.25,0.5,0.75]);
Q1G_1_016 = quant(1);
Q2G_1_016 = quant(2);
Q3G_1_016 = quant(3);
quant = quantile(abs(Z_GLRK4s10_016),[0.25,0.5,0.75]);
Q1G_10_016 = quant(1);
Q2G_10_016 = quant(2);
Q3G_10_016 = quant(3);
quant = quantile(abs(Z_GLRK4s50_016),[0.25,0.5,0.75]);
Q1G_50_016 = quant(1);
Q2G_50_016 = quant(2);
Q3G_50_016 = quant(3);
quant = quantile(abs(Z_GLRK4s1_008),[0.25,0.5,0.75]);
Q1G_1_008 = quant(1);
Q2G_1_008 = quant(2);
Q3G_1_008 = quant(3);
quant = quantile(abs(Z_GLRK4s10_008),[0.25,0.5,0.75]);
Q1G_10_008 = quant(1);
Q2G_10_008 = quant(2);
Q3G_10_008 = quant(3);
quant = quantile(abs(Z_GLRK4s50_008),[0.25,0.5,0.75]);
Q1G_50_008 = quant(1);
Q2G_50_008 = quant(2);
Q3G_50_008 = quant(3);
quant = quantile(abs(Z_GLRK4s1_004),[0.25,0.5,0.75]);
Q1G_1_004 = quant(1);
Q2G_1_004 = quant(2);
Q3G_1_004 = quant(3);
quant = quantile(abs(Z_GLRK4s10_004),[0.25,0.5,0.75]);
Q1G_10_004 = quant(1);
Q2G_10_004 = quant(2);
Q3G_10_004 = quant(3);
quant = quantile(abs(Z_GLRK4s50_004),[0.25,0.5,0.75]);
Q1G_50_004 = quant(1);
Q2G_50_004 = quant(2);
Q3G_50_004 = quant(3);
quant = quantile(abs(Z_GLRK4s1_002),[0.25,0.5,0.75]);
Q1G_1_002 = quant(1);
Q2G_1_002 = quant(2);
Q3G_1_002 = quant(3);
quant = quantile(abs(Z_GLRK4s10_002),[0.25,0.5,0.75]);
Q1G_10_002 = quant(1);
Q2G_10_002 = quant(2);
Q3G_10_002 = quant(3);
quant = quantile(abs(Z_GLRK4s50_002),[0.25,0.5,0.75]);
Q1G_50_002 = quant(1);
Q2G_50_002 = quant(2);
Q3G_50_002 = quant(3);
quant = quantile(abs(Z_GLRK4s1_001),[0.25,0.5,0.75]);
Q1G_1_001 = quant(1);
Q2G_1_001 = quant(2);
Q3G_1_001 = quant(3);
quant = quantile(abs(Z_GLRK4s10_001),[0.25,0.5,0.75]);
Q1G_10_001 = quant(1);
Q2G_10_001 = quant(2);
Q3G_10_001 = quant(3);
quant = quantile(abs(Z_GLRK4s50_001),[0.25,0.5,0.75]);
Q1G_50_001 = quant(1);
Q2G_50_001 = quant(2);
Q3G_50_001 = quant(3);
quant = quantile(abs(Z_GLRK4s1_0005),[0.25,0.5,0.75]);
Q1G_1_0005 = quant(1);
Q2G_1_0005 = quant(2);
Q3G_1_0005 = quant(3);
quant = quantile(abs(Z_GLRK4s10_0005),[0.25,0.5,0.75]);
Q1G_10_0005 = quant(1);
Q2G_10_0005 = quant(2);
Q3G_10_0005 = quant(3);
quant = quantile(abs(Z_GLRK4s50_0005),[0.25,0.5,0.75]);
Q1G_50_0005 = quant(1);
Q2G_50_0005 = quant(2);
Q3G_50_0005 = quant(3);
quant = quantile(abs(Z_GLRK4s1_00025),[0.25,0.5,0.75]);
Q1G_1_00025 = quant(1);
Q2G_1_00025 = quant(2);
Q3G_1_00025 = quant(3);
quant = quantile(abs(Z_GLRK4s10_00025),[0.25,0.5,0.75]);
Q1G_10_00025 = quant(1);
Q2G_10_00025 = quant(2);
Q3G_10_00025 = quant(3);
quant = quantile(abs(Z_GLRK4s50_00025),[0.25,0.5,0.75]);
Q1G_50_00025 = quant(1);
Q2G_50_00025 = quant(2);
Q3G_50_00025 = quant(3);

% Layer 1: Heun's. Unstable for h > 0.04. 
% Use NaN for unstable method/step-size combinations to avoid accidentally
% plotting with those values.
StatsSorted_T(:,:,1) = [h     1 NaN NaN NaN NaN NaN;...
                        h     10 NaN NaN NaN NaN NaN;...
                        h     50 NaN NaN NaN NaN NaN;...
                        h/2   1 NaN NaN NaN NaN NaN;...
                        h/2   10 NaN NaN NaN NaN NaN;...
                        h/2   50 NaN NaN NaN NaN NaN;...
                        h/2^2 1 NaN NaN NaN NaN NaN;...
                        h/2^2 10 NaN NaN NaN NaN NaN;...
                        h/2^2 50 NaN NaN NaN NaN NaN;...
                        h/2^3 1 mean(abs(Z_Heuns1_004)) std(Z_Heuns1_004) Q2H_1_004-Q1H_1_004 Q3H_1_004-Q2H_1_004 Q2H_1_004;...
                        h/2^3 10 mean(abs(Z_Heuns10_004)) std(Z_Heuns10_004) Q2H_10_004-Q1H_10_004 Q3H_10_004-Q2H_10_004 Q2H_10_004;...
                        h/2^3 50 mean(abs(Z_Heuns50_004)) std(Z_Heuns50_004) Q2H_50_004-Q1H_50_004 Q3H_50_004-Q2H_50_004 Q2H_50_004;...
                        h/2^4 1 mean(abs(Z_Heuns1_002)) std(Z_Heuns1_002) Q2H_1_002-Q1H_1_002 Q3H_1_002-Q2H_1_002 Q2H_1_002;...
                        h/2^4 10 mean(abs(Z_Heuns10_002)) std(Z_Heuns10_002) Q2H_10_002-Q1H_10_002 Q3H_10_002-Q2H_10_002 Q2H_10_002;...
                        h/2^4 50 mean(abs(Z_Heuns50_002)) std(Z_Heuns50_002) Q2H_50_002-Q1H_50_002 Q3H_50_002-Q2H_50_002 Q2H_50_002;...
                        h/2^5 1 mean(abs(Z_Heuns1_001)) std(Z_Heuns1_001) Q2H_1_001-Q1H_1_001 Q3H_1_001-Q2H_1_001 Q2H_1_001;...
                        h/2^5 10 mean(abs(Z_Heuns10_001)) std(Z_Heuns10_001) Q2H_10_001-Q1H_10_001 Q3H_10_001-Q2H_10_001 Q2H_10_001;...
                        h/2^5 50 mean(abs(Z_Heuns50_001)) std(Z_Heuns50_001) Q2H_50_001-Q1H_50_001 Q3H_50_001-Q2H_50_001 Q2H_50_001;...
                        h/2^6 1 mean(abs(Z_Heuns1_0005)) std(Z_Heuns1_0005) Q2H_1_0005-Q1H_1_0005 Q3H_1_0005-Q2H_1_0005 Q2H_1_0005;...
                        h/2^6 10 mean(abs(Z_Heuns10_0005)) std(Z_Heuns10_0005) Q2H_10_0005-Q1H_10_0005 Q3H_10_0005-Q2H_10_0005 Q2H_10_0005;...
                        h/2^6 50 mean(abs(Z_Heuns50_0005)) std(Z_Heuns50_0005) Q2H_50_0005-Q1H_50_0005 Q3H_50_0005-Q2H_50_0005 Q2H_50_0005;...
                        h/2^7 1 mean(abs(Z_Heuns1_00025)) std(Z_Heuns1_00025) Q2H_1_00025-Q1H_1_00025 Q3H_1_00025-Q2H_1_00025 Q2H_1_00025;...
                        h/2^7 10 mean(abs(Z_Heuns10_00025)) std(Z_Heuns10_00025) Q2H_10_00025-Q1H_10_00025 Q3H_10_00025-Q2H_10_00025 Q2H_10_00025;...
                        h/2^7 50 mean(abs(Z_Heuns50_00025)) std(Z_Heuns50_00025) Q2H_50_00025-Q1H_50_00025 Q3H_50_00025-Q2H_50_00025 Q2H_50_00025];

% Layer 2: RK4. Unstable for h > 0.08
StatsSorted_T(:,:,2) = [h     1 NaN NaN NaN NaN NaN;...
                        h     10 NaN NaN NaN NaN NaN;...
                        h     50 NaN NaN NaN NaN NaN;...
                        h/2   1 NaN NaN NaN NaN NaN;...
                        h/2   10 NaN NaN NaN NaN NaN;...
                        h/2   50 NaN NaN NaN NaN NaN;...
                        h/2^2 1 mean(abs(Z_RK4s1_008)) std(Z_RK4s1_008) Q2R_1_008-Q1R_1_008 Q3R_1_008-Q2R_1_008 Q2R_1_008;...
                        h/2^2 10 mean(abs(Z_RK4s10_008)) std(Z_RK4s10_008) Q2R_10_008-Q1R_10_008 Q3R_10_008-Q2R_10_008 Q2R_10_008;...
                        h/2^2 50 mean(abs(Z_RK4s50_008)) std(Z_RK4s50_008) Q2R_50_008-Q1R_50_008 Q3R_50_008-Q2R_50_008 Q2R_50_008;...
                        h/2^3 1 mean(abs(Z_RK4s1_004)) std(Z_RK4s1_004) Q2R_1_004-Q1R_1_004 Q3R_1_004-Q2R_1_004 Q2R_1_004;...
                        h/2^3 10 mean(abs(Z_RK4s10_004)) std(Z_RK4s10_004) Q2R_10_004-Q1R_10_004 Q3R_10_004-Q2R_10_004 Q2R_10_004;...
                        h/2^3 50 mean(abs(Z_RK4s50_004)) std(Z_RK4s50_004) Q2R_50_004-Q1R_50_004 Q3R_50_004-Q2R_50_004 Q2R_50_004;...
                        h/2^4 1 mean(abs(Z_RK4s1_002)) std(Z_RK4s1_002) Q2R_1_002-Q1R_1_002 Q3R_1_002-Q2R_1_002 Q2R_1_002;...
                        h/2^4 10 mean(abs(Z_RK4s10_002)) std(Z_RK4s10_002) Q2R_10_002-Q1R_10_002 Q3R_10_002-Q2R_10_002 Q2R_10_002;...
                        h/2^4 50 mean(abs(Z_RK4s50_002)) std(Z_RK4s50_002) Q2R_50_002-Q1R_50_002 Q3R_50_002-Q2R_50_002 Q2R_50_002;...
                        h/2^5 1 mean(abs(Z_RK4s1_001)) std(Z_RK4s1_001) Q2R_1_001-Q1R_1_001 Q3R_1_001-Q2R_1_001 Q2R_1_001;...
                        h/2^5 10 mean(abs(Z_RK4s10_001)) std(Z_RK4s10_001) Q2R_10_001-Q1R_10_001 Q3R_10_001-Q2R_10_001 Q2R_10_001;...
                        h/2^5 50 mean(abs(Z_RK4s50_001)) std(Z_RK4s50_001) Q2R_50_001-Q1R_50_001 Q3R_50_001-Q2R_50_001 Q2R_50_001;...
                        h/2^6 1 mean(abs(Z_RK4s1_0005)) std(Z_RK4s1_0005) Q2R_1_0005-Q1R_1_0005 Q3R_1_0005-Q2R_1_0005 Q2R_1_0005;...
                        h/2^6 10 mean(abs(Z_RK4s10_0005)) std(Z_RK4s10_0005) Q2R_10_0005-Q1R_10_0005 Q3R_10_0005-Q2R_10_0005 Q2R_10_0005;...
                        h/2^6 50 mean(abs(Z_RK4s50_0005)) std(Z_RK4s50_0005) Q2R_50_0005-Q1R_50_0005 Q3R_50_0005-Q2R_50_0005 Q2R_50_0005;...
                        h/2^7 1 mean(abs(Z_RK4s1_00025)) std(Z_RK4s1_00025) Q2R_1_00025-Q1R_1_00025 Q3R_1_00025-Q2R_1_00025 Q2R_1_00025;...
                        h/2^7 10 mean(abs(Z_RK4s10_00025)) std(Z_RK4s10_00025) Q2R_10_00025-Q1R_10_00025 Q3R_10_00025-Q2R_10_00025 Q2R_10_00025;...
                        h/2^7 50 mean(abs(Z_RK4s50_00025)) std(Z_RK4s50_00025) Q2R_50_00025-Q1R_50_00025 Q3R_50_00025-Q2R_50_00025 Q2R_50_00025];

% Layer 3: GLRK4. Unstable for h > 0.32
StatsSorted_T(:,:,3) = [h     1 mean(abs(Z_GLRK4s1_032)) std(Z_GLRK4s1_032) Q2G_1_032-Q1G_1_032 Q3G_1_032-Q2G_1_032 Q2G_1_032;...
                        h     10 mean(abs(Z_GLRK4s10_032)) std(Z_GLRK4s10_032) Q2G_10_032-Q1G_10_032 Q3G_10_032-Q2G_10_032 Q2G_10_032;...
                        h     50 mean(abs(Z_GLRK4s50_032)) std(Z_GLRK4s50_032) Q2G_50_032-Q1G_50_032 Q3G_50_032-Q2G_50_032 Q2G_50_032;...
                        h/2   1 mean(abs(Z_GLRK4s1_016)) std(Z_GLRK4s1_016) Q2G_1_016-Q1G_1_016 Q3G_1_016-Q2G_1_016 Q2G_1_016;...
                        h/2   10 mean(abs(Z_GLRK4s10_016)) std(Z_GLRK4s10_016) Q2G_10_016-Q1G_10_016 Q3G_10_016-Q2G_10_016 Q2G_10_016;...
                        h/2   50 mean(abs(Z_GLRK4s50_016)) std(Z_GLRK4s50_016) Q2G_50_016-Q1G_50_016 Q3G_50_016-Q2G_50_016 Q2G_50_016;...
                        h/2^2 1 mean(abs(Z_GLRK4s1_008)) std(Z_GLRK4s1_008) Q2G_1_008-Q1G_1_008 Q3G_1_008-Q2G_1_008 Q2G_1_008;...
                        h/2^2 10 mean(abs(Z_GLRK4s10_008)) std(Z_GLRK4s10_008) Q2G_10_008-Q1G_10_008 Q3G_10_008-Q2G_10_008 Q2G_10_008;...
                        h/2^2 50 mean(abs(Z_GLRK4s50_008)) std(Z_GLRK4s50_008) Q2G_50_008-Q1G_50_008 Q3G_50_008-Q2G_50_008 Q2G_50_008;...
                        h/2^3 1 mean(abs(Z_GLRK4s1_004)) std(Z_GLRK4s1_004) Q2G_1_004-Q1G_1_004 Q3G_1_004-Q2G_1_004 Q2G_1_004;...
                        h/2^3 10 mean(abs(Z_GLRK4s10_004)) std(Z_GLRK4s10_004) Q2G_10_004-Q1G_10_004 Q3G_10_004-Q2G_10_004 Q2G_10_004;...
                        h/2^3 50 mean(abs(Z_GLRK4s50_004)) std(Z_GLRK4s50_004) Q2G_50_004-Q1G_50_004 Q3G_50_004-Q2G_50_004 Q2G_50_004;...
                        h/2^4 1 mean(abs(Z_GLRK4s1_002)) std(Z_GLRK4s1_002) Q2G_1_002-Q1G_1_002 Q3G_1_002-Q2G_1_002 Q2G_1_002;...
                        h/2^4 10 mean(abs(Z_GLRK4s10_002)) std(Z_GLRK4s10_002) Q2G_10_002-Q1G_10_002 Q3G_10_002-Q2G_10_002 Q2G_10_002;...
                        h/2^4 50 mean(abs(Z_GLRK4s50_002)) std(Z_GLRK4s50_002) Q2G_50_002-Q1G_50_002 Q3G_50_002-Q2G_50_002 Q2G_50_002;...
                        h/2^5 1 mean(abs(Z_GLRK4s1_001)) std(Z_GLRK4s1_001) Q2G_1_001-Q1G_1_001 Q3G_1_001-Q2G_1_001 Q2G_1_001;...
                        h/2^5 10 mean(abs(Z_GLRK4s10_001)) std(Z_GLRK4s10_001) Q2G_10_001-Q1G_10_001 Q3G_10_001-Q2G_10_001 Q2G_10_001;...
                        h/2^5 50 mean(abs(Z_GLRK4s50_001)) std(Z_GLRK4s50_001) Q2G_50_001-Q1G_50_001 Q3G_50_001-Q2G_50_001 Q2G_50_001;...
                        h/2^6 1 mean(abs(Z_GLRK4s1_0005)) std(Z_GLRK4s1_0005) Q2G_1_0005-Q1G_1_0005 Q3G_1_0005-Q2G_1_0005 Q2G_1_0005;...
                        h/2^6 10 mean(abs(Z_GLRK4s10_0005)) std(Z_GLRK4s10_0005) Q2G_10_0005-Q1G_10_0005 Q3G_10_0005-Q2G_10_0005 Q2G_10_0005;...
                        h/2^6 50 mean(abs(Z_GLRK4s50_0005)) std(Z_GLRK4s50_0005) Q2G_50_0005-Q1G_50_0005 Q3G_50_0005-Q2G_50_0005 Q2G_50_0005;...
                        h/2^7 1 mean(abs(Z_GLRK4s1_00025)) std(Z_GLRK4s1_00025) Q2G_1_00025-Q1G_1_00025 Q3G_1_00025-Q2G_1_00025 Q2G_1_00025;...
                        h/2^7 10 mean(abs(Z_GLRK4s10_00025)) std(Z_GLRK4s10_00025) Q2G_10_00025-Q1G_10_00025 Q3G_10_00025-Q2G_10_00025 Q2G_10_00025;...
                        h/2^7 50 mean(abs(Z_GLRK4s50_00025)) std(Z_GLRK4s50_00025) Q2G_50_00025-Q1G_50_00025 Q3G_50_00025-Q2G_50_00025 Q2G_50_00025];                        

% Layer 1: Heun's                    
StatsSorted_h(:,:,1) = [h     1 NaN NaN NaN NaN NaN;...
                        h/2   1 NaN NaN NaN NaN NaN;...
                        h/2^2 1 NaN NaN NaN NaN NaN;...
                        h/2^3 1 mean(abs(Z_Heuns1_004)) std(Z_Heuns1_004) Q2H_1_004-Q1H_1_004 Q3H_1_004-Q2H_1_004 Q2H_1_004;...
                        h/2^4 1 mean(abs(Z_Heuns1_002)) std(Z_Heuns1_002) Q2H_1_002-Q1H_1_002 Q3H_1_002-Q2H_1_002 Q2H_1_002;...
                        h/2^5 1 mean(abs(Z_Heuns1_001)) std(Z_Heuns1_001) Q2H_1_001-Q1H_1_001 Q3H_1_001-Q2H_1_001 Q2H_1_001;...
                        h/2^6 1 mean(abs(Z_Heuns1_0005)) std(Z_Heuns1_0005) Q2H_1_0005-Q1H_1_0005 Q3H_1_0005-Q2H_1_0005 Q2H_1_0005;...
                        h/2^7 1 mean(abs(Z_Heuns1_00025)) std(Z_Heuns1_00025) Q2H_1_00025-Q1H_1_00025 Q3H_1_00025-Q2H_1_00025 Q2H_1_00025;...
                        h     10 NaN NaN NaN NaN NaN;...
                        h/2   10 NaN NaN NaN NaN NaN;...
                        h/2^2 10 NaN NaN NaN NaN NaN;...
                        h/2^3 10 mean(abs(Z_Heuns10_004)) std(Z_Heuns10_004) Q2H_10_004-Q1H_10_004 Q3H_10_004-Q2H_10_004 Q2H_10_004;...
                        h/2^4 10 mean(abs(Z_Heuns10_002)) std(Z_Heuns10_002) Q2H_10_002-Q1H_10_002 Q3H_10_002-Q2H_10_002 Q2H_10_002;...
                        h/2^5 10 mean(abs(Z_Heuns10_001)) std(Z_Heuns10_001) Q2H_10_001-Q1H_10_001 Q3H_10_001-Q2H_10_001 Q2H_10_001;...
                        h/2^6 10 mean(abs(Z_Heuns10_0005)) std(Z_Heuns10_0005) Q2H_10_0005-Q1H_10_0005 Q3H_10_0005-Q2H_10_0005 Q2H_10_0005;...
                        h/2^7 10 mean(abs(Z_Heuns10_00025)) std(Z_Heuns10_00025) Q2H_10_00025-Q1H_10_00025 Q3H_10_00025-Q2H_10_00025 Q2H_10_00025;...
                        h     50 NaN NaN NaN NaN NaN;...
                        h/2   50 NaN NaN NaN NaN NaN;...
                        h/2^2 50 NaN NaN NaN NaN NaN;...
                        h/2^3 50 mean(abs(Z_Heuns50_004)) std(Z_Heuns50_004) Q2H_50_004-Q1H_50_004 Q3H_50_004-Q2H_50_004 Q2H_50_004;...
                        h/2^4 50 mean(abs(Z_Heuns50_002)) std(Z_Heuns50_002) Q2H_50_002-Q1H_50_002 Q3H_50_002-Q2H_50_002 Q2H_50_002;...
                        h/2^5 50 mean(abs(Z_Heuns50_001)) std(Z_Heuns50_001) Q2H_50_001-Q1H_50_001 Q3H_50_001-Q2H_50_001 Q2H_50_001;...
                        h/2^6 50 mean(abs(Z_Heuns50_0005)) std(Z_Heuns50_0005) Q2H_50_0005-Q1H_50_0005 Q3H_50_0005-Q2H_50_0005 Q2H_50_0005;...
                        h/2^7 50 mean(abs(Z_Heuns50_00025)) std(Z_Heuns50_00025) Q2H_50_00025-Q1H_50_00025 Q3H_50_00025-Q2H_50_00025 Q2H_50_00025];

% Layer 2: RK4
StatsSorted_h(:,:,2) = [h     1 NaN NaN NaN NaN NaN;...
                        h/2   1 NaN NaN NaN NaN NaN;...
                        h/2^2 1 mean(abs(Z_RK4s1_008)) std(Z_RK4s1_008) Q2R_1_008-Q1R_1_008 Q3R_1_008-Q2R_1_008 Q2R_1_008;...
                        h/2^3 1 mean(abs(Z_RK4s1_004)) std(Z_RK4s1_004) Q2R_1_004-Q1R_1_004 Q3R_1_004-Q2R_1_004 Q2R_1_004;...
                        h/2^4 1 mean(abs(Z_RK4s1_002)) std(Z_RK4s1_002) Q2R_1_002-Q1R_1_002 Q3R_1_002-Q2R_1_002 Q2R_1_002;...
                        h/2^5 1 mean(abs(Z_RK4s1_001)) std(Z_RK4s1_001) Q2R_1_001-Q1R_1_001 Q3R_1_001-Q2R_1_001 Q2R_1_001;...
                        h/2^6 1 mean(abs(Z_RK4s1_0005)) std(Z_RK4s1_0005) Q2R_1_0005-Q1R_1_0005 Q3R_1_0005-Q2R_1_0005 Q2R_1_0005;...
                        h/2^7 1 mean(abs(Z_RK4s1_00025)) std(Z_RK4s1_00025) Q2R_1_00025-Q1R_1_00025 Q3R_1_00025-Q2R_1_00025 Q2R_1_00025;...
                        h     1 NaN NaN NaN NaN NaN;...
                        h/2   1 NaN NaN NaN NaN NaN;...
                        h/2^2 10 mean(abs(Z_RK4s10_008)) std(Z_RK4s10_008) Q2R_10_008-Q1R_10_008 Q3R_10_008-Q2R_10_008 Q2R_10_008;...
                        h/2^3 10 mean(abs(Z_RK4s10_004)) std(Z_RK4s10_004) Q2R_10_004-Q1R_10_004 Q3R_10_004-Q2R_10_004 Q2R_10_004;...
                        h/2^4 10 mean(abs(Z_RK4s10_002)) std(Z_RK4s10_002) Q2R_10_002-Q1R_10_002 Q3R_10_002-Q2R_10_002 Q2R_10_002;...
                        h/2^5 10 mean(abs(Z_RK4s10_001)) std(Z_RK4s10_001) Q2R_10_001-Q1R_10_001 Q3R_10_001-Q2R_10_001 Q2R_10_001;...
                        h/2^6 10 mean(abs(Z_RK4s10_0005)) std(Z_RK4s10_0005) Q2R_10_0005-Q1R_10_0005 Q3R_10_0005-Q2R_10_0005 Q2R_10_0005;...
                        h/2^7 10 mean(abs(Z_RK4s10_00025)) std(Z_RK4s10_00025) Q2R_10_00025-Q1R_10_00025 Q3R_10_00025-Q2R_10_00025 Q2R_10_00025;...
                        h     50 NaN NaN NaN NaN NaN;...
                        h/2   50 NaN NaN NaN NaN NaN;...
                        h/2^2 50 mean(abs(Z_RK4s50_008)) std(Z_RK4s50_008) Q2R_50_008-Q1R_50_008 Q3R_50_008-Q2R_50_008 Q2R_50_008;...
                        h/2^3 50 mean(abs(Z_RK4s50_004)) std(Z_RK4s50_004) Q2R_50_004-Q1R_50_004 Q3R_50_004-Q2R_50_004 Q2R_50_004;...
                        h/2^4 50 mean(abs(Z_RK4s50_002)) std(Z_RK4s50_002) Q2R_50_002-Q1R_50_002 Q3R_50_002-Q2R_50_002 Q2R_50_002;...
                        h/2^5 50 mean(abs(Z_RK4s50_001)) std(Z_RK4s50_001) Q2R_50_001-Q1R_50_001 Q3R_50_001-Q2R_50_001 Q2R_50_001;...
                        h/2^6 50 mean(abs(Z_RK4s50_0005)) std(Z_RK4s50_0005) Q2R_50_0005-Q1R_50_0005 Q3R_50_0005-Q2R_50_0005 Q2R_50_0005;...
                        h/2^7 50 mean(abs(Z_RK4s50_00025)) std(Z_RK4s50_00025) Q2R_50_00025-Q1R_50_00025 Q3R_50_00025-Q2R_50_00025 Q2R_50_00025];

% Layer 3: GLRK4
StatsSorted_h(:,:,3) = [h     1 mean(abs(Z_GLRK4s1_032)) std(Z_GLRK4s1_032) Q2G_1_032-Q1G_1_032 Q3G_1_032-Q2G_1_032 Q2G_1_032;...
                        h/2   1 mean(abs(Z_GLRK4s1_016)) std(Z_GLRK4s1_016) Q2G_1_016-Q1G_1_016 Q3G_1_016-Q2G_1_016 Q2G_1_016;...
                        h/2^2 1 mean(abs(Z_GLRK4s1_008)) std(Z_GLRK4s1_008) Q2G_1_008-Q1G_1_008 Q3G_1_008-Q2G_1_008 Q2G_1_008;...
                        h/2^3 1 mean(abs(Z_GLRK4s1_004)) std(Z_GLRK4s1_004) Q2G_1_004-Q1G_1_004 Q3G_1_004-Q2G_1_004 Q2G_1_004;...
                        h/2^4 1 mean(abs(Z_GLRK4s1_002)) std(Z_GLRK4s1_002) Q2G_1_002-Q1G_1_002 Q3G_1_002-Q2G_1_002 Q2G_1_002;...
                        h/2^5 1 mean(abs(Z_GLRK4s1_001)) std(Z_GLRK4s1_001) Q2G_1_001-Q1G_1_001 Q3G_1_001-Q2G_1_001 Q2G_1_001;...
                        h/2^6 1 mean(abs(Z_GLRK4s1_0005)) std(Z_GLRK4s1_0005) Q2G_1_0005-Q1G_1_0005 Q3G_1_0005-Q2G_1_0005 Q2G_1_0005;...
                        h/2^7 1 mean(abs(Z_GLRK4s1_00025)) std(Z_GLRK4s1_00025) Q2G_1_00025-Q1G_1_00025 Q3G_1_00025-Q2G_1_00025 Q2G_1_00025;...
                        h     10 mean(abs(Z_GLRK4s10_032)) std(Z_GLRK4s10_032) Q2G_10_032-Q1G_10_032 Q3G_10_032-Q2G_10_032 Q2G_10_032;...
                        h/2   10 mean(abs(Z_GLRK4s10_016)) std(Z_GLRK4s10_016) Q2G_10_016-Q1G_10_016 Q3G_10_016-Q2G_10_016 Q2G_10_016;...
                        h/2^2 10 mean(abs(Z_GLRK4s10_008)) std(Z_GLRK4s10_008) Q2G_10_008-Q1G_10_008 Q3G_10_008-Q2G_10_008 Q2G_10_008;...
                        h/2^3 10 mean(abs(Z_GLRK4s10_004)) std(Z_GLRK4s10_004) Q2G_10_004-Q1G_10_004 Q3G_10_004-Q2G_10_004 Q2G_10_004;...
                        h/2^4 10 mean(abs(Z_GLRK4s10_002)) std(Z_GLRK4s10_002) Q2G_10_002-Q1G_10_002 Q3G_10_002-Q2G_10_002 Q2G_10_002;...
                        h/2^5 10 mean(abs(Z_GLRK4s10_001)) std(Z_GLRK4s10_001) Q2G_10_001-Q1G_10_001 Q3G_10_001-Q2G_10_001 Q2G_10_001;...
                        h/2^6 10 mean(abs(Z_GLRK4s10_0005)) std(Z_GLRK4s10_0005) Q2G_10_0005-Q1G_10_0005 Q3G_10_0005-Q2G_10_0005 Q2G_10_0005;...
                        h/2^7 10 mean(abs(Z_GLRK4s10_00025)) std(Z_GLRK4s10_00025) Q2G_10_00025-Q1G_10_00025 Q3G_10_00025-Q2G_10_00025 Q2G_10_00025;...
                        h     50 mean(abs(Z_GLRK4s50_032)) std(Z_GLRK4s50_032) Q2G_50_032-Q1G_50_032 Q3G_50_032-Q2G_50_032 Q2G_50_032;...
                        h/2   50 mean(abs(Z_GLRK4s50_016)) std(Z_GLRK4s50_016) Q2G_50_016-Q1G_50_016 Q3G_50_016-Q2G_50_016 Q2G_50_016;...
                        h/2^2 50 mean(abs(Z_GLRK4s50_008)) std(Z_GLRK4s50_008) Q2G_50_008-Q1G_50_008 Q3G_50_008-Q2G_50_008 Q2G_50_008;...
                        h/2^3 50 mean(abs(Z_GLRK4s50_004)) std(Z_GLRK4s50_004) Q2G_50_004-Q1G_50_004 Q3G_50_004-Q2G_50_004 Q2G_50_004;...
                        h/2^4 50 mean(abs(Z_GLRK4s50_002)) std(Z_GLRK4s50_002) Q2G_50_002-Q1G_50_002 Q3G_50_002-Q2G_50_002 Q2G_50_002;...
                        h/2^5 50 mean(abs(Z_GLRK4s50_001)) std(Z_GLRK4s50_001) Q2G_50_001-Q1G_50_001 Q3G_50_001-Q2G_50_001 Q2G_50_001;...
                        h/2^6 50 mean(abs(Z_GLRK4s50_0005)) std(Z_GLRK4s50_0005) Q2G_50_0005-Q1G_50_0005 Q3G_50_0005-Q2G_50_0005 Q2G_50_0005;...
                        h/2^7 50 mean(abs(Z_GLRK4s50_00025)) std(Z_GLRK4s50_00025) Q2G_50_00025-Q1G_50_00025 Q3G_50_00025-Q2G_50_00025 Q2G_50_00025];

% Clear all intermediate variables
clearvars Z_Heuns1_004 Z_Heuns1_002 Z_Heuns1_001 Z_Heuns1_0005 Z_Heuns1_00025;
clearvars Z_Heuns10_004 Z_Heuns10_002 Z_Heuns10_001 Z_Heuns10_0005 Z_Heuns10_00025;
clearvars Z_Heuns50_004 Z_Heuns50_002 Z_Heuns50_001 Z_Heuns50_0005 Z_Heuns50_00025;
clearvars Z_RK4s1_004 Z_RK4s1_002 Z_RK4s1_001 Z_RK4s1_0005 Z_RK4s1_00025;
clearvars Z_RK4s10_004 Z_RK4s10_002 Z_RK4s10_001 Z_RK4s10_0005 Z_RK4s10_00025;
clearvars Z_RK4s50_004 Z_RK4s50_002 Z_RK4s50_001 Z_RK4s50_0005 Z_RK4s50_00025;
clearvars Z_RK4s1_008 Z_RK4s10_008 Z_RK4s50_008;
clearvars Z_GLRK4s1_004 Z_GLRK4s1_002 Z_GLRK4s1_001 Z_GLRK4s1_0005 Z_GLRK4s1_00025;
clearvars Z_GLRK4s10_004 Z_GLRK4s10_002 Z_GLRK4s10_001 Z_GLRK4s10_0005 Z_GLRK4s10_00025;
clearvars Z_GLRK4s50_004 Z_GLRK4s50_002 Z_GLRK4s50_001 Z_GLRK4s50_0005 Z_GLRK4s50_00025 h quant;
clearvars Z_GLRK4s1_008 Z_GLRK4s10_008 Z_GLRK4s50_008;
clearvars Z_GLRK4s1_016 Z_GLRK4s10_016 Z_GLRK4s50_016;
clearvars Z_GLRK4s1_032 Z_GLRK4s10_032 Z_GLRK4s50_032;
clearvars Q1H_1_002 Q3H_1_002 Q1H_10_002 Q3H_10_002 Q1H_50_002 Q3H_50_002;
clearvars Q2H_1_002 Q2H_10_002 Q2H_50_002 Q2H_1_001 Q2H_10_001 Q2H_50_001;
clearvars Q2H_1_0005 Q2H_10_0005 Q2H_50_0005 Q2H_1_00025 Q2H_10_00025 Q2H_50_00025;
clearvars Q1H_1_001 Q3H_1_001 Q1H_10_001 Q3H_10_001 Q1H_50_001 Q3H_50_001;
clearvars Q1H_1_0005 Q3H_1_0005 Q1H_10_0005 Q3H_10_0005 Q1H_50_0005 Q3H_50_0005;
clearvars Q1H_1_00025 Q3H_1_00025 Q1H_10_00025 Q3H_10_00025 Q1H_50_00025 Q3H_50_00025;
clearvars Q1R_1_002 Q3R_1_002 Q1R_10_002 Q3R_10_002 Q1R_50_002 Q3R_50_002;
clearvars Q2R_1_002 Q2R_10_002 Q2R_50_002 Q2R_1_001 Q2R_10_001 Q2R_50_001;
clearvars Q2R_1_0005 Q2R_10_0005 Q2R_50_0005 Q2R_1_00025 Q2R_10_00025 Q2R_50_00025;
clearvars Q1R_1_001 Q3R_1_001 Q1R_10_001 Q3R_10_001 Q1R_50_001 Q3R_50_001;
clearvars Q1R_1_0005 Q3R_1_0005 Q1R_10_0005 Q3R_10_0005 Q1R_50_0005 Q3R_50_0005;
clearvars Q1R_1_00025 Q3R_1_00025 Q1R_10_00025 Q3R_10_00025 Q1R_50_00025 Q3R_50_00025;
clearvars Q1G_1_002 Q3G_1_002 Q1G_10_002 Q3G_10_002 Q1G_50_002 Q3G_50_002;
clearvars Q2G_1_002 Q2G_10_002 Q2G_50_002 Q2G_1_001 Q2G_10_001 Q2G_50_001;
clearvars Q2G_1_0005 Q2G_10_0005 Q2G_50_0005 Q2G_1_00025 Q2G_10_00025 Q2G_50_00025;
clearvars Q1G_1_001 Q3G_1_001 Q1G_10_001 Q3G_10_001 Q1G_50_001 Q3G_50_001;
clearvars Q1G_1_0005 Q3G_1_0005 Q1G_10_0005 Q3G_10_0005 Q1G_50_0005 Q3G_50_0005;
clearvars Q1G_1_00025 Q3G_1_00025 Q1G_10_00025 Q3G_10_00025 Q1G_50_00025 Q3G_50_00025;
clearvars Q1H_1_004 Q3H_1_004 Q1H_10_004 Q3H_10_004 Q1H_50_004 Q3H_50_004;
clearvars Q1R_1_004 Q3R_1_004 Q1R_10_004 Q3R_10_004 Q1R_50_004 Q3R_50_004;
clearvars Q1G_1_004 Q3G_1_004 Q1G_10_004 Q3G_10_004 Q1G_50_004 Q3G_50_004;
clearvars Q2H_1_004 Q2H_10_004 Q2H_50_004 Q2R_1_004 Q2R_10_004 Q2R_50_004 Q2G_1_004 Q2G_10_004 Q2G_50_004;
clearvars Q2H_1_008 Q2H_10_008 Q2H_50_008 Q2R_1_008 Q2R_10_008 Q2R_50_008 Q2G_1_008 Q2G_10_008 Q2G_50_008;
clearvars Q1H_1_008 Q1H_10_008 Q1H_50_008 Q1R_1_008 Q1R_10_008 Q1R_50_008 Q1G_1_008 Q1G_10_008 Q1G_50_008;
clearvars Q3H_1_008 Q3H_10_008 Q3H_50_008 Q3R_1_008 Q3R_10_008 Q3R_50_008 Q3G_1_008 Q3G_10_008 Q3G_50_008;
clearvars Q2H_1_016 Q2H_10_016 Q2H_50_016 Q2R_1_016 Q2R_10_016 Q2R_50_016 Q2G_1_016 Q2G_10_016 Q2G_50_016;
clearvars Q1H_1_016 Q1H_10_016 Q1H_50_016 Q1R_1_016 Q1R_10_016 Q1R_50_016 Q1G_1_016 Q1G_10_016 Q1G_50_016;
clearvars Q3H_1_016 Q3H_10_016 Q3H_50_016 Q3R_1_016 Q3R_10_016 Q3R_50_016 Q3G_1_016 Q3G_10_016 Q3G_50_016;
clearvars Q2H_1_032 Q2H_10_032 Q2H_50_032 Q2R_1_032 Q2R_10_032 Q2R_50_032 Q2G_1_032 Q2G_10_032 Q2G_50_032;
clearvars Q1H_1_032 Q1H_10_032 Q1H_50_032 Q1R_1_032 Q1R_10_032 Q1R_50_032 Q1G_1_032 Q1G_10_032 Q1G_50_032;
clearvars Q3H_1_032 Q3H_10_032 Q3H_50_032 Q3R_1_032 Q3R_10_032 Q3R_50_032 Q3G_1_032 Q3G_10_032 Q3G_50_032;