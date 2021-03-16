%
% The code in this file was used to produce the plots shown in Figure ___.
%

%% Stat vs step size, T = 1, quartiles

h = [0.04 0.02 0.01 0.005 0.0025];

HeunsMeds = StatsSorted_h(1:5,7,1);
HeunsQLow = StatsSorted_h(1:5,5,1);
HeunsQHigh = StatsSorted_h(1:5,6,1);

RK4Meds = StatsSorted_h(1:5,7,2);
RK4QLow = StatsSorted_h(1:5,5,2);
RK4QHigh = StatsSorted_h(1:5,6,2);

GLRKMeds = StatsSorted_h(1:5,7,3);
GLRKQLow = StatsSorted_h(1:5,5,3);
GLRKQHigh = StatsSorted_h(1:5,6,3);

errorbar(h, HeunsMeds, HeunsQLow, HeunsQHigh, 'o', 'CapSize', 28, 'LineWidth', 7, 'Color', [0.5 0.9 01])
hold on
errorbar(h, RK4Meds, RK4QLow, RK4QHigh, 'o', 'CapSize', 19, 'LineWidth', 5, 'Color', [0 0.6 0.8])
errorbar(h, GLRKMeds, GLRKQLow, GLRKQHigh, 'o', 'CapSize', 14, 'LineWidth', 2, 'Color', [0 0 0.4])
grid on
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
ylabel("%Error Quartiles")
xlabel("Step Size")
xlim([0.0018 0.05])
ylim([1 16])
xticks([0.0025 0.005 0.01 0.02 0.04])
title("% Err Stats vs Step Size, T \approx 1")
lgd = legend("Heun's","RK4","GLRK4",'Location','best');
set(findall(gcf,'-property','FontSize'),'FontSize',14)
lgd.FontSize = 12;
hold off
clearvars HeunsMeds HeunsQLow HeunsQHigh RK4Meds RK4QLow RK4QHigh GLRKMeds GLRKQLow GLRKQHigh lgd h;

%% Stat vs step size, T = 10, quartiles

h = [0.04 0.02 0.01 0.005 0.0025];

HeunsMeds = StatsSorted_h(6:10,7,1);
HeunsQLow = StatsSorted_h(6:10,5,1);
HeunsQHigh = StatsSorted_h(6:10,6,1);

RK4Meds = StatsSorted_h(6:10,7,2);
RK4QLow = StatsSorted_h(6:10,5,2);
RK4QHigh = StatsSorted_h(6:10,6,2);

GLRKMeds = StatsSorted_h(6:10,7,3);
GLRKQLow = StatsSorted_h(6:10,5,3);
GLRKQHigh = StatsSorted_h(6:10,6,3);

errorbar(h, HeunsMeds, HeunsQLow, HeunsQHigh, 'o', 'CapSize', 28, 'LineWidth', 7, 'Color', [0.5 0.9 01])
hold on
errorbar(h, RK4Meds, RK4QLow, RK4QHigh, 'o', 'CapSize', 19, 'LineWidth', 5, 'Color', [0 0.6 0.8])
errorbar(h, GLRKMeds, GLRKQLow, GLRKQHigh, 'o', 'CapSize', 14, 'LineWidth', 2, 'Color', [0 0 0.4])

grid on
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
ylabel("%Error Quartiles")
xlabel("Step Size")
xlim([0.0018 0.05])
ylim([0.1 16])
xticks([0.0025 0.005 0.01 0.02 0.04])
title("% Err Stats vs Step Size, T \approx 10")
lgd = legend("Heun's","RK4","GLRK4",'Location','southeast');
set(findall(gcf,'-property','FontSize'),'FontSize',14)
lgd.FontSize = 12;
hold off
clearvars HeunsMeds HeunsQLow HeunsQHigh RK4Meds RK4QLow RK4QHigh GLRKMeds GLRKQLow GLRKQHigh lgd h;

%% Stat vs step size, T = 50, quartiles

h = [0.04 0.02 0.01 0.005 0.0025];

HeunsMeds = StatsSorted_h(11:15,7,1);
HeunsQLow = StatsSorted_h(11:15,5,1);
HeunsQHigh = StatsSorted_h(11:15,6,1);

RK4Meds = StatsSorted_h(11:15,7,2);
RK4QLow = StatsSorted_h(11:15,5,2);
RK4QHigh = StatsSorted_h(11:15,6,2);

GLRKMeds = StatsSorted_h(11:15,7,3);
GLRKQLow = StatsSorted_h(11:15,5,3);
GLRKQHigh = StatsSorted_h(11:15,6,3);

errorbar(h, HeunsMeds, HeunsQLow, HeunsQHigh, 'o', 'CapSize', 28, 'LineWidth', 7, 'Color', [0.5 0.9 01])
hold on
errorbar(h, RK4Meds, RK4QLow, RK4QHigh, 'o', 'CapSize', 19, 'LineWidth', 5, 'Color', [0 0.6 0.8])
errorbar(h, GLRKMeds, GLRKQLow, GLRKQHigh, 'o', 'CapSize', 14, 'LineWidth', 2, 'Color', [0 0 0.4])
grid on
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
ylabel("%Error Quartiles")
xlabel("Step Size")
xlim([0.0018 0.05])
ylim([0.04 10])
xticks([0.0025 0.005 0.01 0.02 0.04])
title("% Err Stats vs Step Size, T \approx 50")
lgd = legend("Heun's","RK4","GLRK4",'Location','northwest');
set(findall(gcf,'-property','FontSize'),'FontSize',14)
lgd.FontSize = 12;
hold off
clearvars HeunsMeds HeunsQLow HeunsQHigh RK4Meds RK4QLow RK4QHigh GLRKMeds GLRKQLow GLRKQHigh lgd h;

%% Stat vs Period, h = 0.04, Quartiles

T = [1 10 50];

% HeunsMeds = StatsSorted_T(1:3,7,1);
% HeunsQLow = StatsSorted_T(1:3,5,1);
% HeunsQHigh = StatsSorted_T(1:3,6,1);

RK4Meds = StatsSorted_T(1:3,7,2);
RK4QLow = StatsSorted_T(1:3,5,2);
RK4QHigh = StatsSorted_T(1:3,6,2);

GLRKMeds = StatsSorted_T(1:3,7,3);
GLRKQLow = StatsSorted_T(1:3,5,3);
GLRKQHigh = StatsSorted_T(1:3,6,3);

% errorbar(T, HeunsMeds, HeunsQLow, HeunsQHigh, 'o', 'CapSize', 28, 'LineWidth', 7, 'Color', [0.5 0.9 01])
errorbar(T, RK4Meds, RK4QLow, RK4QHigh, 'o', 'CapSize', 19, 'LineWidth', 5, 'Color', [0 0.6 0.8])
hold on
errorbar(T, GLRKMeds, GLRKQLow, GLRKQHigh, 'o', 'CapSize', 14, 'LineWidth', 2, 'Color', [0 0 0.4])
grid on
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
ylabel("%Error Quartiles")
xlabel("Time-Average Period")
xlim([0.5 100])
ylim([0.04 20])
xticks([1 10 50])
title("% Err Stats vs Time-Average Period, h = 0.04")
lgd = legend("RK4","GLRK4","location","southwest");
set(findall(gcf,'-property','FontSize'),'FontSize',14)
lgd.FontSize = 12;
hold off
clearvars HeunsMeds HeunsQLow HeunsQHigh RK4Meds RK4QLow RK4QHigh GLRKMeds GLRKQLow GLRKQHigh lgd T;

%% Stat vs Period, h = 0.02, Quartiles

T = [1 10 50];

HeunsMeds = StatsSorted_T(4:6,7,1);
HeunsQLow = StatsSorted_T(4:6,5,1);
HeunsQHigh = StatsSorted_T(4:6,6,1);

RK4Meds = StatsSorted_T(4:6,7,2);
RK4QLow = StatsSorted_T(4:6,5,2);
RK4QHigh = StatsSorted_T(4:6,6,2);

GLRKMeds = StatsSorted_T(4:6,7,3);
GLRKQLow = StatsSorted_T(4:6,5,3);
GLRKQHigh = StatsSorted_T(4:6,6,3);

errorbar(T, HeunsMeds, HeunsQLow, HeunsQHigh, 'o', 'CapSize', 28, 'LineWidth', 7, 'Color', [0.5 0.9 01])
hold on
errorbar(T, RK4Meds, RK4QLow, RK4QHigh, 'o', 'CapSize', 19, 'LineWidth', 5, 'Color', [0 0.6 0.8])
errorbar(T, GLRKMeds, GLRKQLow, GLRKQHigh, 'o', 'CapSize', 14, 'LineWidth', 2, 'Color', [0 0 0.4])
grid on
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
ylabel("%Error Quartiles")
xlabel("Time-Average Period")
xlim([0.5 100])
ylim([0.04 20])
xticks([1 10 50])
title("% Err Stats vs Time-Average Period, h = 0.02")
lgd = legend("Heun's","RK4","GLRK4","location","southwest");
set(findall(gcf,'-property','FontSize'),'FontSize',14)
lgd.FontSize = 12;
hold off
clearvars HeunsMeds HeunsQLow HeunsQHigh RK4Meds RK4QLow RK4QHigh GLRKMeds GLRKQLow GLRKQHigh lgd T;

%% Stat vs Period, h = 0.01, Quartiles

T = [1 10 50];

HeunsMeds = StatsSorted_T(7:9,7,1);
HeunsQLow = StatsSorted_T(7:9,5,1);
HeunsQHigh = StatsSorted_T(7:9,6,1);

RK4Meds = StatsSorted_T(7:9,7,2);
RK4QLow = StatsSorted_T(7:9,5,2);
RK4QHigh = StatsSorted_T(7:9,6,2);

GLRKMeds = StatsSorted_T(7:9,7,3);
GLRKQLow = StatsSorted_T(7:9,5,3);
GLRKQHigh = StatsSorted_T(7:9,6,3);

errorbar(T, HeunsMeds, HeunsQLow, HeunsQHigh, 'o', 'CapSize', 28, 'LineWidth', 7, 'Color', [0.5 0.9 01])
hold on
errorbar(T, RK4Meds, RK4QLow, RK4QHigh, 'o', 'CapSize', 19, 'LineWidth', 5, 'Color', [0 0.6 0.8])
errorbar(T, GLRKMeds, GLRKQLow, GLRKQHigh, 'o', 'CapSize', 14, 'LineWidth', 2, 'Color', [0 0 0.4])
grid on
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
ylabel("%Error Quartiles")
xlabel("Time-Average Period")
xlim([0.5 100])
ylim([0.04 20])
xticks([1 10 50])
title("% Err Stats vs Time-Average Period, h = 0.01")
lgd = legend("Heun's","RK4","GLRK4");
set(findall(gcf,'-property','FontSize'),'FontSize',14)
lgd.FontSize = 12;
hold off
clearvars HeunsMeds HeunsQLow HeunsQHigh RK4Meds RK4QLow RK4QHigh GLRKMeds GLRKQLow GLRKQHigh lgd T;

%% Stat vs Period, h = 0.005, Quartiles

T = [1 10 50];

HeunsMeds = StatsSorted_T(10:12,7,1);
HeunsQLow = StatsSorted_T(10:12,5,1);
HeunsQHigh = StatsSorted_T(10:12,6,1);

RK4Meds = StatsSorted_T(10:12,7,2);
RK4QLow = StatsSorted_T(10:12,5,2);
RK4QHigh = StatsSorted_T(10:12,6,2);

GLRKMeds = StatsSorted_T(10:12,7,3);
GLRKQLow = StatsSorted_T(10:12,5,3);
GLRKQHigh = StatsSorted_T(10:12,6,3);

errorbar(T, HeunsMeds, HeunsQLow, HeunsQHigh, 'o', 'CapSize', 28, 'LineWidth', 7, 'Color', [0.5 0.9 01])
hold on
errorbar(T, RK4Meds, RK4QLow, RK4QHigh, 'o', 'CapSize', 19, 'LineWidth', 5, 'Color', [0 0.6 0.8])
errorbar(T, GLRKMeds, GLRKQLow, GLRKQHigh, 'o', 'CapSize', 14, 'LineWidth', 2, 'Color', [0 0 0.4])
grid on
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
ylabel("%Error Quartiles")
xlabel("Time-Average Period")
xlim([0.5 100])
ylim([0.04 20])
xticks([1 10 50])
title("% Err Stats vs Time-Average Period, h = 0.005")
lgd = legend("Heun's","RK4","GLRK4");
set(findall(gcf,'-property','FontSize'),'FontSize',14)
lgd.FontSize = 12;
hold off
clearvars HeunsMeds HeunsQLow HeunsQHigh RK4Meds RK4QLow RK4QHigh GLRKMeds GLRKQLow GLRKQHigh lgd T;

%% Stat vs Period, h = 0.0025, Quartiles

T = [1 10 50];

HeunsMeds = StatsSorted_T(13:15,7,1);
HeunsQLow = StatsSorted_T(13:15,5,1);
HeunsQHigh = StatsSorted_T(13:15,6,1);

RK4Meds = StatsSorted_T(13:15,7,2);
RK4QLow = StatsSorted_T(13:15,5,2);
RK4QHigh = StatsSorted_T(13:15,6,2);

GLRKMeds = StatsSorted_T(13:15,7,3);
GLRKQLow = StatsSorted_T(13:15,5,3);
GLRKQHigh = StatsSorted_T(13:15,6,3);

errorbar(T, HeunsMeds, HeunsQLow, HeunsQHigh, 'o', 'CapSize', 28, 'LineWidth', 7, 'Color', [0.5 0.9 01])
hold on
errorbar(T, RK4Meds, RK4QLow, RK4QHigh, 'o', 'CapSize', 19, 'LineWidth', 5, 'Color', [0 0.6 0.8])
errorbar(T, GLRKMeds, GLRKQLow, GLRKQHigh, 'o', 'CapSize', 14, 'LineWidth', 2, 'Color', [0 0 0.4])
grid on
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
ylabel("%Error Quartiles")
xlabel("Time-Average Period")
xlim([0.5 100])
ylim([0.04 20])
xticks([1 10 50])
title("% Err Stats vs Time-Average Period, h = 0.0025")
lgd = legend("Heun's","RK4","GLRK4");
set(findall(gcf,'-property','FontSize'),'FontSize',14)
lgd.FontSize = 12;
hold off
clearvars HeunsMeds HeunsQLow HeunsQHigh RK4Meds RK4QLow RK4QHigh GLRKMeds GLRKQLow GLRKQHigh lgd T;