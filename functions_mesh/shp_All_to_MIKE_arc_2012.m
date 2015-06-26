clear all; close all;

[data_file,data_path,FilterIndex] = uigetfile('*.shp','Select the shp polygon file');

S = shaperead(fullfile(data_path,data_file));
xy_file = sprintf('%s_arc.xyz',data_file(1:end-4));

fid = fopen(fullfile(data_path,xy_file),'wt');

for q = 1:length(S)
    
    
    xx = [zeros(length(S(q).X),1)+1 zeros(length(S(q).X),1) zeros(length(S(q).X),1)];
    xx(end-1,1) = 0;
    

    fprintf(fid,'%.3f %.3f %d %d %d\n', ...
        [S(q).X(1:end-1)' S(q).Y(1:end-1)' xx(1:end-1,:)]');
end

fclose(fid);
