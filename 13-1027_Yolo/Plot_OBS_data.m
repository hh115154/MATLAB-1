clear all; close all
cd('C:\Work\13-1027_Yolo\LT model\TUFLOW\OBS data')

D = dir('*.mat');

for i = 1:length(D)
    load(D(i).name)
end

subplot(2,2,1)
plot(freH_time,freH_data)
datetick('x','yyyy')
grid

subplot(2,2,2)
plot(freQ_time,freQ_data)
datetick('x','yyyy')
grid

subplot(2,2,3)
plot(vonQ_time,vonQ_data)
datetick('x','yyyy')
grid

subplot(2,2,4)
plot(yby_time,yby_data)
datetick('x','yyyy')
grid