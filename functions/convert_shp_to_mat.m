% convert shp to mat
clear all; close all

[polygonfile1,path] = uigetfile('*.shp','Select Polygon shp file..');
S = shaperead(fullfile(path,polygonfile1));

matfile1 = [polygonfile1(1:end-4) '.mat'];

save(matfile1,'S')
