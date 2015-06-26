function shp_All_to_MIKE_arc_2012_OneByOne(q)

[data_file,data_path,FilterIndex] = uigetfile('*.shp','Select the csv data file');

% data_path = pwd;
S = shaperead(fullfile(data_path,data_file));
xy_file = sprintf('%s_arc_%d.xyz',data_file(1:end-4),q);

fid = fopen(fullfile(data_path,xy_file),'wt');

% for q = 1:length(S)
    
    
    xx = [zeros(length(S(q).X),1)+1 zeros(length(S(q).X),1) zeros(length(S(q).X),1)];
    xx(end-1,1) = 0;
    

    fprintf(fid,'%.3f %.3f %d %d %d\n', ...
        [S(q).X(1:end-1)' S(q).Y(1:end-1)' xx(1:end-1,:)]');
% end

fclose(fid);
