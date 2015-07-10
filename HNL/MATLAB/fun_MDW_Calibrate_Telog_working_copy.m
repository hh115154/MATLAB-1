close all; clear all
cd('/Users/sjbaek/WORK/AECOM/HNL_project/DATA')

load sample_gap_remove
FM = FM';
tsEqu = tsEqu';
% plot(tsEqu,FM,'.-',tsRaw,FMraw,'r.-')
% set(gca,'xlim',[734381 734383])

tsZoom = tsEqu(tsEqu>734381 & tsEqu<734383);
FMZoom = FM(tsEqu>734381 & tsEqu<734383);

figure(1)
plot(tsZoom,FMZoom,'.-',tsRaw,FMraw,'r.-')
set(gca,'xlim',[734381 734383])

%% Raw

tsRawZoom = tsRaw(tsRaw>734381 & tsRaw<734383);
FMrawZoom = FMraw(tsRaw>734381 & tsRaw<734383);
figure(2)
plot(tsZoom,FMZoom,'.-',tsRawZoom,FMrawZoom,'r.-')


%% identify NaN from original
F = FMrawZoom;
T = tsRawZoom;
%{ 

Pattern:
1)  time series + NaN
2)  No time series

%}

indNaN = find(isnan(F));



