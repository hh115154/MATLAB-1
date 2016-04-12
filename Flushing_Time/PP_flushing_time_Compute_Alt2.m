% Estimate Flushing time using Curve Fitting toolbox
% sjb/cbec
% 5/24/2010

% sjb/otak
% 2/4/2016

clear all
close all

% move to the folder with .mat files produced from [PP_Alt1_flushing_time.m]
% The mat files contain time series of tracer concentration for each region
%  - The lengths of time series are different because the tracer kick-off times are all
%    different per each scenario
%  - 
cd('C:\Work\Projects\09-1029_Lower_Yolo_Concepts\Task_2.3_Modeling\Alt1\output_tracers');

%% Load all .mat files/ and compare lengths
AD12 = load('AD_1440.mat');
AD16 = load('AD_1920.mat');
AD20 = load('AD_2400.mat');
AD24 = load('AD_2880.mat');
AD28 = load('AD_3360.mat');
AD32 = load('AD_3840.mat');
AD36 = load('AD_4320.mat');

AD_num = length(AD36.AvgC);
tseries = 0:3600:3600*(AD_num-1);  % data extracted hourly

%% construct data structure
% [diff. start time] x [number of time series]
% i.e. 7 x 205


for i = 1:5  % loop for network number
    for j = 1:7  % loop for different AD start time
        eval(sprintf('Alt1_AD.N%d(%d,:) = AD%d.AvgC(%d,1:AD_num);',i,j,12+(j-1)*4,i))
    end
end

%% estimate Flushing Time

Alt1_N1_mean = mean(Alt1_AD.N1);
Alt1_N2_mean = mean(Alt1_AD.N2);
Alt1_N3_mean = mean(Alt1_AD.N3);
Alt1_N4_mean = mean(Alt1_AD.N4);
Alt1_N5_mean = mean(Alt1_AD.N5);


[estimates1, model1] = fitcurvedemo(tseries/3600/24,Alt1_N1_mean);
[estimates2, model2] = fitcurvedemo(tseries/3600/24,Alt1_N2_mean);
[estimates3, model3] = fitcurvedemo(tseries/3600/24,Alt1_N3_mean);
[estimates4, model4] = fitcurvedemo(tseries/3600/24,Alt1_N4_mean);
[estimates5, model5] = fitcurvedemo(tseries/3600/24,Alt1_N5_mean);


%% error bar plot

% siz = size(Alt1_AD.N1);
for i = 1:size(Alt1_AD.N1,1)
    for k = 1:5
        eval(sprintf('Conc_diff.N%d(i,:)= Alt1_AD.N%d(i,:)./Alt1_AD.N%d(i,1) - Alt1_N%d_mean;',k,k,k,k))
    end
%     Conc_diff (i,:)= Conc_sce1(i,:) - Conc_mean;
%     Conc_diff1(i,:)= Alt1_AD.N1(i,:)./Alt1_AD.N1(i,1) - Alt1_N1_mean;
%     Conc_diff2(i,:)= Alt1_AD.N2(i,:)./Alt1_AD.N2(i,1) - Alt1_N2_mean;
%     Conc_diff3(i,:)= Alt1_AD.N3(i,:)./Alt1_AD.N3(i,1) - Alt1_N3_mean;
%     Conc_diff4(i,:)= Alt1_AD.N4(i,:)./Alt1_AD.N4(i,1) - Alt1_N4_mean;
%     Conc_diff5(i,:)= Alt1_AD.N5(i,:)./Alt1_AD.N5(i,1) - Alt1_N5_mean;
end

for k = 1:5
    eval(sprintf('min_Conc.N%d = min(Conc_diff.N%d);',k,k))
    eval(sprintf('max_Conc.N%d = max(Conc_diff.N%d);',k,k))
end

%% Plot
figure(1)
errorbar(tseries(1:3:end)./24./3600,Alt1_N1_mean(1:3:end),min_Conc.N1(1:3:end),max_Conc.N1(1:3:end))

hold
plot(tseries./24./3600,Alt1_N1_mean,'linewidth',3)
datetick('x',7)
axis tight
plot(tseries/24/3600,estimates1(1).*exp(-estimates1(2).*tseries/24/3600),'r--')
title({'Alt 1: Network 1';sprintf('Flushing time: %.2f days',1/estimates1(2))})
grid
xlabel('days')
ylabel('tracer concentration')
%
figure(2)
errorbar(tseries(1:3:end)./24./3600,Alt1_N2_mean(1:3:end),min_Conc.N2(1:3:end),max_Conc.N2(1:3:end))

hold
plot(tseries./24./3600,Alt1_N2_mean,'linewidth',3)
datetick('x',7)
axis tight
plot(tseries/24/3600,estimates2(1).*exp(-estimates2(2).*tseries/24/3600),'r--')
title({'Alt 1: Network 2';sprintf('Flushing time: %.2f days',1/estimates2(2))})
grid
xlabel('days')
ylabel('tracer concentration')

%
figure(3)
errorbar(tseries(1:3:end)./24./3600,Alt1_N3_mean(1:3:end),min_Conc.N3(1:3:end),max_Conc.N3(1:3:end))

hold
plot(tseries./24./3600,Alt1_N3_mean,'linewidth',3)
datetick('x',7)
axis tight
plot(tseries/24/3600,estimates3(1).*exp(-estimates3(2).*tseries/24/3600),'r--')
title({'Alt 1: Network 3';sprintf('Flushing time: %.2f days',1/estimates3(2))})
grid
xlabel('days')
ylabel('tracer concentration')

%
figure(4)
errorbar(tseries(1:3:end)./24./3600,Alt1_N4_mean(1:3:end),min_Conc.N4(1:3:end),max_Conc.N4(1:3:end))

hold
plot(tseries./24./3600,Alt1_N4_mean,'linewidth',3)
datetick('x',7)
axis tight
plot(tseries/24/3600,estimates4(1).*exp(-estimates4(2).*tseries/24/3600),'r--')
title({'Alt 1: Network 4';sprintf('Flushing time: %.2f days',1/estimates4(2))})
grid
xlabel('days')
ylabel('tracer concentration')

%
figure(5)
errorbar(tseries(1:3:end)./24./3600,Alt1_N5_mean(1:3:end),min_Conc.N5(1:3:end),max_Conc.N5(1:3:end))

hold
plot(tseries./24./3600,Alt1_N5_mean,'linewidth',3)
datetick('x',7)
axis tight
plot(tseries/24/3600,estimates5(1).*exp(-estimates5(2).*tseries/24/3600),'r--')
title({'Alt 1: Network 5';sprintf('Flushing time: %.2f days',1/estimates5(2))})
grid
xlabel('days')
ylabel('tracer concentration')
