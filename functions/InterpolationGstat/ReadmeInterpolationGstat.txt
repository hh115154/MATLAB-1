% INTERPOLATIONGSTAT 
%
%This routine is a simple matlab interface to gstat to enable easy
% ordinary kriging or inverse distance interpolation. It does not and is
% not intended to take advantage of all the capabilities of gstat
%
% How to set up an inverse distance interpolation.
% - your sample points and their locations should be vectors of the same
% length.
% - The radius is the search distance for the interpolation to find
% neighbours. If you are unsure, a good starting point is the max distance
% between adjacent locations.
% - Do not choose meaningless resolutions. e.g is your locations are ~1km
% apart, a resolution of 10m is unneccessary. 
% - set 'uselog' to 1 if your sample data has a skew>1 (use 'skewness' and
% 'hist')
%
% Kriging interpolation.
% The above points are also valid for kriging. 
% Kriging also requires a variogram model to calculate its weights. A
% variogram model is a function that has been fitted to an experimental
% variogram of the data. Use SampleVarioGstat.m to calculate the
% experimental variogram. Use variogramfit by wolfgang Schwanghart to find the variogram model.
%
