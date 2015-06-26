function Load_FLT_animation_Alt1(cfg)
close all
tic
% convert FLT to xyz for plotting

%{
- cfg file saved in 
  (M10) E:\Work\Projects\13-1027_Yolo_Bypass_Fish_Passage\MATLAB\cfg_Alts


%}
%% Read configuration file
% [fn,pn] = uigetfile('*.cfg', 'Pick a configuration file ...');

% fidc = fopen(fullfile(pn,fn));
fidc = fopen(cfg);

C_cfg = textscan(fidc,'%s','delimiter',sprintf('\n'));

alt_type = C_cfg{1}{2};
path_FLTalt = C_cfg{1}{4};
path_FLTexi = C_cfg{1}{6};
item_sel   = C_cfg{1}{8};
image_name = C_cfg{1}{10};
fpath_WT   = C_cfg{1}{12};
fpath_OBS  = C_cfg{1}{14};
fpath_Area = C_cfg{1}{16};
% fn_shp       = C_cfg{1}{10};
% item_shp     = str2double(C_cfg{1}{12});

fclose(fidc);

%%

% -------------- 1999
% cd('\\Cbecm11\e\Work\Projects\13-1027_YBM\LT Model\TUFLOW\results\1999\NearBypass\grids')
% -------------- 2008
% cd('E:\Work\Projects\13-1027_Yolo_Bypass_Fish_Passage\LT Model\TUFLOW\results\2008\NearBypass\grids')
% cd(path_FLTexi)
% path_FLTexi = pwd;

% s = regexp(pwd,'\','split');
s = regexp(path_FLTalt,'\','split');
model_year = str2double(s{end-2});

fprintf(1,'\nAVI started: WY%d %s\n',model_year,alt_type)


%% USER selection
% ------------------ what to plot
% item_sel = 'h';
% item_sel = 'd';
% item_sel = 'V';

file_find_str_exi = sprintf('yolo*Exg*%s*.flt',item_sel);
% file_find_str_alt = sprintf('yolo*FreSm*%s*.flt',item_sel);
file_find_str_alt = sprintf('yolo*%s*%s*.flt',alt_type,item_sel);

D_exi = dir([path_FLTexi '\' file_find_str_exi]);
D_alt = dir([path_FLTalt '\' file_find_str_alt]);


switch item_sel
    case 'h'
        item_name = 'WSE'; item_number = 1;
    case 'd'
        item_name = 'Depth'; item_number = 2;
    case 'V'
        item_name = 'Vel'; item_number = 3;
end

%% Time series range for each water year
prev_time = 0;

TS_start_ex = str2double(D_exi(1).name(end-9:end-4));
TS_end_ex = str2double(D_exi(end-1).name(end-9:end-4));

TS_start_alt = str2double(D_alt(1).name(end-9:end-4));
TS_end_alt = str2double(D_alt(end-1).name(end-9:end-4));

TS_start = max(TS_start_ex,TS_start_alt);
TS_end = min(TS_end_ex,TS_end_alt);

nFrames = length(D_exi)-1;   % exclude FLT with max values
% Preallocate movie structure.
mov(1:nFrames) = struct('cdata', [],...
    'colormap', []);
% folder check for movie
root_folder = pwd;
cd(path_FLTexi)

ani_folder = '..\..\..\Animation_Alt';
if isempty(dir(ani_folder))
   mkdir(ani_folder); 
end
cd(ani_folder)
ani_folder_loc = pwd;
cd(root_folder)
   
% vidObj = VideoWriter(fullfile(ani_folder_loc,sprintf('yolo_FreSm01_Exg_%s_%d.avi',item_name,model_year)));
vidObj = VideoWriter(fullfile(ani_folder_loc,sprintf('yolo_%s_Exg_%s_%d_rev.avi',alt_type,item_name,model_year)));
vidObj.Quality = 100;
vidObj.FrameRate = 4;
open(vidObj);

% hf_1 = figure('Position',[500 10 1300 1004]);
hf_1 = figure('Position',[500 50 1200 927]);
%% load image
% image_name = 'C:\Work\13-1028_Liberty_Island_LM\Liberty_Island_Bing_Map_600dpi.jpg';
% image_name = 'E:\Work\Projects\13-1027_Yolo_Bypass_Fish_Passage\LT Model\TUFLOW\results\aerial\1D_Bypass3.jpg';
%     image_name = 'C:\Work\13-1027_Yolo\LT model\TUFLOW\results\NearBypass\1D_Bypass3.jpg';
img = imread(image_name);
%
% image([601080 631950],[4249950 4221240],img)


%% colormap (external)
load('YoloColormapsBlue','mycmap')

%% TS: OBS data
% fpath_OBS = 
OBS = dir([fpath_OBS '\*.mat']);

for j = 1:length(OBS)   % read MAT files for OBS data
    load([fpath_OBS '\' OBS(j).name])
end

%{
variable names
freH_time, freH_data : hourly
freQ_time, freQ_data : daily
vonQ_time, vonQ_data : daily
yby_time, yby_data   : hourly
%}



%% TS: Figure 3 & 5 (Fremont Q and WSEs)
% root_folder = pwd;
cd(path_FLTexi)

% fpath_PO = sprintf('\\CBECM11\e\Work\Projects\13-1027_YBM\LT Model\TUFLOW\results\%d',model_year);
% fpath_PO = sprintf('E:\\Work\\Projects\\13-1027_Yolo_Bypass_Fish_Passage\\LT Model\\TUFLOW\\results\\%d',model_year);
fpath_PO = '..\..';
fname_PO = sprintf('yolo_200ft_Exg_TS6_____%d_PO.csv',model_year);

fidPO = fopen(fullfile(fpath_PO,fname_PO));
readfmt = ['%*s%f' repmat('%*f',1,23) '%f%*f%f%*f%*f%f'];
PO_Model_data = textscan(fidPO,readfmt,'delimiter',',','headerlines',2);
fclose(fidPO);

TS_PO_hr = PO_Model_data{1};
TS_PO = TS_PO_hr(TS_PO_hr>=TS_start & TS_PO_hr<=TS_end);

Data_FreWSE_w = PO_Model_data{2}(TS_PO_hr>=TS_start & TS_PO_hr<=TS_end);
Data_FreWSE_e = PO_Model_data{3}(TS_PO_hr>=TS_start & TS_PO_hr<=TS_end);
Data_FreQ = PO_Model_data{4}(TS_PO_hr>=TS_start & TS_PO_hr<=TS_end);

dTS_PO = TS_PO - TS_PO(1);   % time(hour) differences from the 1st entry

% in real time (datenum)
TS_PO_time = addtodate(datenum([1996 10 2 0 0 0]),TS_PO(1),'hour') + dTS_PO./24;


%% TS: Figure 3: Fre-Sim Alternative
cd(path_FLTalt)
fpath_PO_FreSim_alt = '..\..';
fname_PO_FreSim_alt = sprintf('yolo_200ft_%s01_TS6_____%d_PO.csv',alt_type,model_year);

fidPO_FreSim_alt = fopen(fullfile(fpath_PO_FreSim_alt,fname_PO_FreSim_alt));
readfmt = ['%*s%f' repmat('%*f',1,23) '%f%*f%f%*f%*f%f'];
PO_Model_data_ALT = textscan(fidPO_FreSim_alt,readfmt,'delimiter',',','headerlines',2);
fclose(fidPO_FreSim_alt);

Data_FreQ_alt = PO_Model_data_ALT{4}(TS_PO_hr>=TS_start & TS_PO_hr<=TS_end);


%% TS: Figure 4
% -- westside trib inflows time series
% fpath_WT = '\\CBECM11\e\Work\Projects\13-1027_YBM\LT Model\TUFLOW\bc dbase\years';
fname_WT = sprintf('%d_hourly.csv',model_year);
fidwt = fopen(fullfile(fpath_WT,fname_WT));
trib_data = textscan(fidwt,'%f%*f%f%f%*f%*f%*f%*f%*f%*f%f%*f%*f%f%*f%*f%*f%*f%f%*f%*f%*f%*f', ...
    'delimiter',',','headerlines',1);
fclose(fidwt);

TS_trib = trib_data{1};
TS_ind = find(TS_trib>=TS_start & TS_trib<=TS_end);
TS_trib = TS_trib(TS_ind);
% Data_trib = trib_data{2}(TS_trib>=TS_start & TS_trib<=TS_end);

dTS_trib = TS_trib - TS_trib(1);
TS_trib_time = addtodate(datenum([1996 10 2 0 0 0]),TS_trib(1),'hour') + dTS_trib./24;

%% TS: Figure 3 & 5
% -- Q at Verona (Fig. 3) + WSE @ Fremont, YBY, LIS, LIY (Fig. 5)

% fpath_1D = sprintf('\\\\CBECM11\\e\\Work\\Projects\\13-1027_YBM\\LT Model\\TUFLOW\\results\\%d\\csv',model_year);
% fpath_1D = sprintf('E:\\Work\\Projects\\13-1027_Yolo_Bypass_Fish_Passage\\LT Model\\TUFLOW\\results\\%d\\csv',model_year);
fpath_1D = '..\..\csv';
fname_1D_Q = sprintf('yolo_200ft_%s01_TS6_____%d_1d_Q.csv',alt_type,model_year);
fname_1D_h = sprintf('yolo_200ft_%s01_TS6_____%d_1d_H.csv',alt_type,model_year);

fname_1D_Gate = sprintf('yolo_200ft_%s01_TS6_____%d_1d_O.csv',alt_type,model_year);

% Q at Verona
fid1D_Q = fopen(fullfile(fpath_1D,fname_1D_Q));
readfmtq = ['%*f%*s' repmat('%*f',1,555) '%f%*[^\n]' ];

% Data: Verona Q
VON_Q_1D = textscan(fid1D_Q,readfmtq,'delimiter',',','headerlines',1);
fclose(fid1D_Q);

% WSE @ YBY, LIS, LIY
fid1D_h = fopen(fullfile(fpath_1D,fname_1D_h));
readfmth = ['%*f%*s' repmat('%*f',1,828) '%f' repmat('%*f',1,168) '%f%*f%*f%*f%f%*[^\n]' ];

% Data: LIY stage - YBY stage - LIS stage
h_1D = textscan(fid1D_h,readfmth,'delimiter',',','headerlines',1);
fclose(fid1D_h);

% Gate Sim flows
fid_GQ = fopen(fullfile(fpath_1D,fname_1D_Gate));
switch alt_type
    % second column is forced to use %*s because some O files have 
    % ******** instead of hour stamps; clearly TUFLOW bug
    case 'FreSm'
        readfmtGQ = ['%*f%*s%*s%*f%*f%*f' '%f' '%*s%*f%*f%*f%*f' '%f' ...
            '%*s%*f%*f%*f' '%f' '%*[^\n]' ];
    case 'SacW'
        % readfmtGQ = '%*f%*s%*s%*f%*f%*f%f%*[^\n]';
        readfmtGQ = ['%*f%*s%*s%*f%*f%*f%*f%*s%*f%*f%*f' '%f' ...
            '%*s%*f%*f%*f%*f%f' repmat('%*s%*f%*f%*f%f',1,4)];
otherwise
        readfmtGQ = ['%*f%*s%*s%*f%*f%*f' '%f' '%*s%*f' ...
            repmat('%*f%*f%*f%f%*s',1,5) '%*[^\n]' ];

end
            
            

GateQ = textscan(fid_GQ,readfmtGQ,'delimiter',',','headerlines',1);
Gate_totalQ = sum(cell2mat(GateQ),2);

fclose(fid_GQ);

%% TS: Area time series

AD = dir(fullfile(fpath_Area,'*.csv'));

% AreaAcre{1,length(AD)} = [];
for k = 1:length(AD)
    if ~isempty(strfind(AD(k).name,'Exg.'))  % existing condition
        [TS_Ex, Area_Ex] = Read_AREA_csv(fullfile(fpath_Area,AD(k).name));
    elseif ~isempty(strfind(AD(k).name,sprintf('%s01.',alt_type))) 
        [TS_0430, Area_0430] = Read_AREA_csv(fullfile(fpath_Area,AD(k).name));
    elseif ~isempty(strfind(AD(k).name,sprintf('%s01_Feb15.',alt_type)))  
        [TS_0215, Area_0215] = Read_AREA_csv(fullfile(fpath_Area,AD(k).name));
    elseif ~isempty(strfind(AD(k).name,sprintf('%s01_Mar1.',alt_type)))  
        [TS_0301, Area_0301] = Read_AREA_csv(fullfile(fpath_Area,AD(k).name));
    elseif ~isempty(strfind(AD(k).name,sprintf('%s01_Mar15.',alt_type))) 
        [TS_0315, Area_0315] = Read_AREA_csv(fullfile(fpath_Area,AD(k).name));
    elseif ~isempty(strfind(AD(k).name,sprintf('%s01_Apr1.',alt_type)))  
        [TS_0401, Area_0401] = Read_AREA_csv(fullfile(fpath_Area,AD(k).name));
    else
        continue
    end
end
    
    

%% 
for i = 1:length(D_alt)
    %  for i = 1:5
    
    if ~isempty(findstr(D_alt(i).name,'Max'))
        continue
    end
    
    % eval(sprintf('%s = load(D(i).name);',D(i).name(1:end-4)))
    
    filen_exi = D_exi(i).name;
    
    filen_alt = D_alt(i).name;
    hdrn = sprintf('%s.hdr',filen_alt(1:end-4));
    %if i == 243
    %    fprintf(1,'check \n')
    %end
    hour_passed = str2double(filen_alt(end-9:end-4));
    cur_date = addtodate(datenum([1996 10 2 0 0 0]),hour_passed,'hour');
    
    % plot item
    switch filen_alt(end-11)
        case 'd'
            item_name = 'Depth';
        case 'h'
            item_name = 'WSE';
        case 'V'
            item_name = 'Velocity';
    end
    
    % filen = 'yolo_200ft_Exg_TS6_____2008_NearBypass_d_102216.flt';
    % hdrn  = 'yolo_200ft_Exg_TS6_____2008_NearBypass_d_102216.hdr';
    
    fid = fopen(fullfile(path_FLTalt,hdrn));
    
    % open output file
    %     fidw = fopen(sprintf('%s.xyz',filen(1:end-4)),'wt');
    %% read header
    S = textscan(fid,'%*s %f',6);
    ncols = S{1}(1);
    nrows = S{1}(2);
    xcor = S{1}(3);
    ycor = S{1}(4);
    dxy = S{1}(5);
    NoData = S{1}(6);
    
    fclose(fid);
    % %% unit
    % elevation_unit = 'meter';
    
    %% read raster data
    
    GRID_exi = readmtx(fullfile(path_FLTexi,filen_exi),nrows,ncols,'float32',[1 nrows],[1 ncols],'ieee-le');
    GRID_alt = readmtx(fullfile(path_FLTalt,filen_alt),nrows,ncols,'float32',[1 nrows],[1 ncols],'ieee-le');
    
    %{
xmini = 1;
xmaxi = round((xmax-xcor)/dxy);

ymini = round((ymin-ycor)/dxy);
ymidi = round((ymid-ycor)/dxy);
ymaxi = round((ymax-ycor)/dxy);

GRID_N = GRID(ymidi:ymaxi,xmini:xmaxi);
GRID_S = GRID(ymini:ymidi,xmini:xmaxi);
    %}
    %% non-loop script
    
    % Alt condition
    GRID_alt(GRID_alt==NoData) = NaN;
    [ii,jj,v] = find(~isnan(GRID_alt));
    
    xcoord = xcor + jj.*dxy - dxy/2;
    ycoord = (ycor + nrows*dxy) - ii*dxy + dxy/2;
    zcoord_alt = GRID_alt(~isnan(GRID_alt));
    
    %  existing condition
    
    % ----------------------------------------  test reducing data size by 4
    grid_int = 1;
    GRID_exi = GRID_exi(1:grid_int:end,1:grid_int:end);
    
    GRID_exi(GRID_exi==NoData) = NaN;
    [ii_exi,jj_exi,v_exi] = find(~isnan(GRID_exi));
    
    xcoord_exi = xcor + jj_exi.*dxy*grid_int - dxy/2;
    ycoord_exi = (ycor + nrows*dxy) - ii_exi*dxy*grid_int + dxy/2;
    % zcoord_exi = GRID_exi(~isnan(GRID_exi));
    
    
    %% boundary (hardwired)
    xmin = min(xcoord);
    xmax = 2.04755958e6;
    
    ymin = 1.391499203e7;
    ymax = 1.409063861e7;
    % ymid = 1.399924803e7;
    ymid = (ymax+ymin)/2;
    
    xcoordN = xcoord(xcoord>xmin & xcoord<xmax & ycoord>ymid & ycoord<ymax);
    ycoordN = ycoord(xcoord>xmin & xcoord<xmax & ycoord>ymid & ycoord<ymax);
    zcoordN = zcoord_alt(xcoord>xmin & xcoord<xmax & ycoord>ymid & ycoord<ymax);

    xcoordS = xcoord(xcoord>xmin & xcoord<xmax & ycoord>ymin & ycoord<ymid);
    ycoordS = ycoord(xcoord>xmin & xcoord<xmax & ycoord>ymin & ycoord<ymid);
    zcoordS = zcoord_alt(xcoord>xmin & xcoord<xmax & ycoord>ymin & ycoord<ymid);

    xcoordN_exi = xcoord_exi(xcoord_exi>xmin & xcoord_exi<xmax & ycoord_exi>ymid & ycoord_exi<ymax);
    ycoordN_exi = ycoord_exi(xcoord_exi>xmin & xcoord_exi<xmax & ycoord_exi>ymid & ycoord_exi<ymax);

    xcoordS_exi = xcoord_exi(xcoord_exi>xmin & xcoord_exi<xmax & ycoord_exi>ymin & ycoord_exi<ymid);
    ycoordS_exi = ycoord_exi(xcoord_exi>xmin & xcoord_exi<xmax & ycoord_exi>ymin & ycoord_exi<ymid);

    %{
% loop script
for n = nrows:-1:1
    
    
    %     C = textscan(fid,ffmt,1);
    temp = GRID(n,:);
    %     temp = cell2mat(C);
    
    id = find(temp~=NoData);
    if isempty(id)
        continue
    end
    xcoord = id.*dxy - dxy/2 + xcor;
    ycoord = zeros(1,length(xcoord)) + dxy*n - dxy/2 + ycor;
    zcoord = temp(id);
    
    switch elevation_unit
        case 'feet'
            zcoord = zcoord.*1200/3937;
        case 'meter'
            %            zcoord = zcoord;
    end
    
    fprintf(fidw,'%.1f %.1f %.2f\n',[xcoord' ycoord' zcoord']');
    clear temp
    
    if mod(n,10) ==0
        if ~isempty(id)
            display(sprintf('%3.2f %% Done - %d points extracted',(nrows-n)/nrows*100,length(id)))
        else
            display(sprintf('%3.2f %% Done',(nrows-n)/nrows*100))
        end
    end
    
end

fclose('all');

%% read xyz
fidx = fopen(sprintf('%s.xyz',filen(1:end-4)));
xyz_ = textscan(fidx,'%f%f%f');
xyz = cell2mat(xyz_);
x = xyz(:,1); y = xyz(:,2); z = xyz(:,3);

figure('Position',[200 50 300 950])
scatter(x,y,5,z,'s','filled')
fclose(fidx);
    %}
    
    %% North region
    cell_size = 2;
    %   ------------------ NORTH
    %     s1 = subplot(3,3,[1 4 7]);
    if i == 1
        
        s1 = axes('position',[0.1 0.11 .21 .8]);
        %         image([1795815.49709008  2266061.54453419],[14137059.14882920 13844931.08527370],img)
        hold on
    end
    set(gcf,'CurrentAxes',s1)
    image([1795815.49709008  2266061.54453419],[14137059.14882920 13844931.08527370],img)
    hold on
    set(s1,'ydir','normal')
    set(s1,'xlim',[xmin xmax])
    set(s1,'ylim',[ymid ymax])
    
    % scatter(s1,xcoordN,ycoordN,cell_size,zcoordN,'s','filled')
    
    %% scatter alternative
    
    cdivs = length(mycmap);
    color_Max = 30;
    
%     [~, edges] = hist(zcoordN,cdivs-1);
%     [~, edges] = hist(zcoordN(zcoordN<=color_Max),cdivs-1);
%     edges = [-Inf edges Inf]; % to include all points
    edges = [-Inf linspace(0,30,cdivs-1) Inf];
    [~, bink] = histc(zcoordN,edges);
    if item_number == 1
        cmap = jet;
    else
        cmap = mycmap;
    end
        
    for ii=1:cdivs
        idx = bink==ii;
        plot(s1,xcoordN(idx),ycoordN(idx),'.','MarkerSize',4.5,'Color',cmap(ii,:));
    end
    colormap(cmap);    
    clear edges idx bink
    caxis(s1,[0 30])
    
    
    %% Existing condition grey x dots
    
    dot_size = 1;
    plot(s1,xcoordN_exi,ycoordN_exi,'.','MarkerSize',dot_size,'Color',[0.7 0.7 0.7])
    
    % ---------------- USE patch for transparency
%     set(gcf,'CurrentAxes',s1)
%     patchx = dxy/10;
%     patchy = patchx;
%     for m = 1:length(xcoordN_exi)
%         p = patch([xcoordN_exi(m)+patchx xcoordN_exi(m)+patchx xcoordN_exi(m)-patchx xcoordN_exi(m)-patchx], ...
%             [ycoordN_exi(m)-patchy ycoordN_exi(m)+patchy ycoordN_exi(m)+patchy ycoordN_exi(m)-patchy], ...
%             [0.7 0.7 0.7]);
%         set(p,'FaceAlpha',0.5,'EdgeColor','none');
%     
%         
%     end
    
    
    
    
    
    %%
    set(s1,'xtick',[])
    set(s1,'ytick',[])
    %%   ------------------ SOUTH
    if i == 1
        s2 = axes('position',[0.35 0.11 .21 .8]);
        %         image([1795815.49709008  2266061.54453419],[14137059.14882920 13844931.08527370],img)
        hold on
    end
    set(gcf,'CurrentAxes',s2)
    image([1795815.49709008  2266061.54453419],[14137059.14882920 13844931.08527370],img)
    hold on
    
    set(s2,'ydir','normal')
    set(s2,'xlim',[xmin xmax])
    set(s2,'ylim',[ymin ymid])
    % scatter(s2,xcoordS,ycoordS,cell_size,zcoordS,'s','filled')
 %% scatter alternative

%      [~, edges] = hist(zcoordS(zcoordS<=color_Max),cdivs-1);
%      edges = [-Inf edges Inf]; % to include all points
     edges = [-Inf linspace(0,30,cdivs-1) Inf];

     [~, bink] = histc(zcoordS,edges);

%     figure;
%     hold on;
    if item_number == 1
        cmap = jet;
    else
        cmap = mycmap;
    end
    for ii=1:cdivs
        idx = bink==ii;
        plot(s2,xcoordS(idx),ycoordS(idx),'.','MarkerSize',4.5,'Color',cmap(ii,:));
    end
    clear edges idx bink cdivs
%     caxis(s2,[0 30])
    
    clear edges idx bink cdivs
    
    %% Existing condition grey x dots
    
    plot(s2,xcoordS_exi,ycoordS_exi,'.','MarkerSize',dot_size,'Color',[0.7 0.7 0.7])

%     % ---------------- USE patch for transparency
% %     set(gcf,'CurrentAxes',s2)
%     for m = 1:length(xcoordS_exi)
%         p = patch([xcoordS_exi(m)+patchx xcoordS_exi(m)+patchx xcoordS_exi(m)-patchx xcoordS_exi(m)-patchx], ...
%             [ycoordS_exi(m)-patchy ycoordS_exi(m)+patchy ycoordS_exi(m)+patchy ycoordS_exi(m)-patchy], ...
%             [0.7 0.7 0.7]);
%         set(p,'FaceAlpha',0.5,'EdgeColor','none');
%     
%         
%     end
    

%% legend for existing grey dots

x_legend = [2.01141455e6 2.02330163e6];
y_legend = [1.40015528e7  1.39973804e7];    

p1 = patch([x_legend(1) x_legend(2) x_legend(2) x_legend(1)], ...
    [y_legend(1) y_legend(1) y_legend(2) y_legend(2)],'w');
set(p1,'edgecolor','none')

x_grey = [2.0129349e6 2.0151465e6];
y_grey = [1.40003452e7 1.3998588e7];

p2 = patch([x_grey(1) x_grey(2) x_grey(2) x_grey(1)], ...
    [y_grey(1) y_grey(1) y_grey(2) y_grey(2)],[.7 .7 .7]);
set(p2,'edgecolor','none')

text(2.0158376e6, 1.39995768e7,'Existing')
    

%%
    set(s2,'xtick',[])
    set(s2,'ytick',[])
    
%%   
    set(s1,'nextplot','replacechildren');
    set(s2,'nextplot','replacechildren');
    xlabel(sprintf('%s: %s',item_name,datestr(cur_date,'mmm dd, yyyy HH:MM')))
    
    cbar_axes = colorbar('north','peer',s1);
    set(cbar_axes,'position',[0.1 0.93 0.46 0.01]);
    cbar_xlim = get(cbar_axes,'xlim');
    set(cbar_axes,'xtick',linspace(cbar_xlim(1),cbar_xlim(2),7))
    set(cbar_axes,'xticklabel',0:5:color_Max)
    title(cbar_axes,sprintf('%s (ft)',item_name),'fontsize',8);
    set(cbar_axes,'fontsize',8);
    
    %% Time series: Figure 3
    if i == 1
        s3 = axes('position',[0.65 0.664 .3 .247]);
        
        % plot(s3,freQ_time,freQ_data,'--')
        % hold(s3,'on')
        plot(s3,TS_PO_time,Data_FreQ_alt)
        % plot(s3,TS_PO_time,Data_FreQ)   % hourly data from PO.csv file (2D output)
        hold(s3,'on')
        %plot(s3,vonQ_time,vonQ_data,'r--')
        plot(s3,TS_PO_time(1:6:end),VON_Q_1D{1},'r')  % 6 hour data from 1D output
        plot(s3,TS_PO_time(1:6:end),Gate_totalQ,'g')
        
        
        set(s3,'xlim',[TS_PO_time(1) TS_PO_time(end)])
        set(s3,'fontsize',8)
        % axis(s3,'tight')
        % leg_s3 = legend(s3,'FRE-Obs','FRE-Sim','VON-Obs','VON-Sim');
        leg_s3 = legend(s3,'FRE-Sim','VON-Sim','Gate-Sim','location','northwest');
        % leg_s3 = legend(s3,'FRE-Sim','VON-Sim','location','northwest');
        datetick(s3,'x','mmm','keeplimits')
        set(s3,'xticklabel',[]);
        title(s3,'Flow Time Series')
        ylabel(s3,'Flow (cfs)')

    end
    
    
    %     set(s3,'xticklabel',[]);
    y_lim = get(s3,'ylim');
    
    set(gcf,'CurrentAxes',s3)
    % line([hour_passed hour_passed],[y_lim(1) y_lim(2)],'color','k')
    l3 = line([cur_date cur_date],[y_lim(1) y_lim(2)],'color','k');
    
    
    %     set(s3,'nextplot','replacechildren');
    
    %
    %% Time series: Figure 4
    if i == 1
        s4 = axes('position',[0.65 0.387 .3 .247]);
        
        plot(s4,TS_trib_time,trib_data{2}(TS_ind))
        hold(s4,'on')
        plot(s4,TS_trib_time,trib_data{3}(TS_ind),'r')
        plot(s4,TS_trib_time,trib_data{4}(TS_ind),'g')
        plot(s4,TS_trib_time,trib_data{5}(TS_ind),'c')
        plot(s4,TS_trib_time,trib_data{6}(TS_ind),'k')
        
        set(s4,'xlim',[TS_trib_time(1) TS_trib_time(end)])
        set(s4,'fontsize',8)

        % axis(s4,'tight')
        leg_s4 = legend(s4,'CC Out','CC Spill','KLRC', ...
            'Putah','Willow','location','northwest');
        title(s4,'Westside Tributary Inflows')
        datetick(s4,'x','mmm','keeplimits')
        set(s4,'xticklabel',[]);
        ylabel(s4,'Flow (cfs)')
    end
    y_lim = get(s4,'ylim');
    % line added for the current time indicator
    set(gcf,'CurrentAxes',s4)
    l4 = line([cur_date cur_date],[y_lim(1) y_lim(2)],'color','k');
    %     set(s4,'nextplot','replacechildren');
    %% c
    if i == 1
        s5 = axes('position',[0.65 0.11 .3 .247]);
        hold on
        % plot title
        
        plot(s5,TS_Ex,Area_Ex,'k','linewidth',2)
        hold(s5,'on')
        plot(s5,TS_0215,Area_0215,'r')
        plot(s5,TS_0301,Area_0301,'color',[255 165 79]./255)
        plot(s5,TS_0315,Area_0315,'g')
        plot(s5,TS_0401,Area_0401,'b','linewidth',2)
        plot(s5,TS_0430,Area_0430,'color',[255 0 127]./255)

% Original color code - Chad Ballard 4/22/14        
%        plot(s5,TS_0315,Area_0315,'y')
%        plot(s5,TS_0401,Area_0401,'g','linewidth',2)
%        plot(s5,TS_0430,Area_0430,'b','linewidth',2)

        set(s5,'xlim',[TS_trib_time(1) TS_trib_time(end)])

        % set(s5,'xlim',[TS_Ex(1) TS_Ex(end)])
        set(s5,'fontsize',8)
        
        leg_s5 = ...
            legend(s5,'Existing','Close 2/15','Close 3/1','Close 3/15', ...
            'Close 4/1','Close 4/30','location','northwest');
        title(s5,'Wetted Area Time Series')
        datetick(s5,'x','mmm','keeplimits')
        xlabel(s5,sprintf('WY %d',model_year))
        ylabel(s5,'Wetted Area (acres)')
        
        
%         
%         plot(s5,freH_time,freH_data,'--')
%         hold(s5,'on')
%         plot(s5,TS_PO_time,Data_FreWSE_w)
%         % plot(s5,TS_PO_time,Data_FreWSE_e,'r')
%         plot(s5,yby_time,yby_data,'r--')
%         plot(s5,TS_PO_time(1:6:end),h_1D{2},'r')
%         plot(s5,TS_PO_time(1:6:end),h_1D{1},'g')
%         plot(s5,TS_PO_time(1:6:end),h_1D{3},'k')
%         
%         set(s5,'xlim',[TS_PO_time(1) TS_PO_time(end)])
%         set(s5,'fontsize',8)
        
        % axis(s5,'tight')
        % leg_s5 = legend(s5,'FRE-Sim(W)','FRE-Sim(E)','YBY-Sim','LIS-Sim','LIY-Sim');
%         leg_s5 = legend(s5,'FRE-Obs','FRE-Sim','YBY-Obs','YBY-Sim','LIY-Sim','LIS-Sim');
%         title(s5,'Stage Time Series')
%         datetick(s5,'x','mmm','keeplimits')
%         xlabel(s5,sprintf('WY %d',model_year))
%         ylabel(s5,'ft')
    end
    %     set(s5,'xticklabel',[]);
    y_lim = get(s5,'ylim');
    
    set(gcf,'CurrentAxes',s5)
    % line([hour_passed hour_passed],[y_lim(1) y_lim(2)],'color','k')
    l5 = line([cur_date cur_date],[y_lim(1) y_lim(2)],'color','k');
    
    %     set(s5,'nextplot','replacechildren');
    
    %% Write VIDEO
    writeVideo(vidObj,getframe(hf_1));
    
    % remove colorbar for the next one
    delete(cbar_axes);
    %     delete(leg_s4);
    delete(l3);
    delete(l4);
    delete(l5);
    timecheck = toc;
    
    fprintf(1,'Fig %d:Elapsed time = %.1f sec, total = %.1f min\n',i,timecheck-prev_time,timecheck/60)
    prev_time = timecheck;
end
cd(root_folder)
fprintf(1,'\nTotal time = %.1f min\n',timecheck/60)
fprintf(1,'FILE created: WY%d %s\n\n\n',model_year,alt_type)

% export_fig('sample_fig','-pdf','-nocrop','-transparent','-append',hf_1)
% print(hf_1,'-dpdf','sample2')

% Create AVI file.
% movie2avi(mov, 'mySample.avi', 'compression', 'none','fps',1);
close(vidObj);
close all

    function [date_plot, AreaAcre] = Read_AREA_csv(fname_A)
        fid = fopen(fname_A);
        WetArea = textscan(fid,'%f%s%f%f%f','delimiter',',','headerlines',1);
        % AreaData = WetArea;
        fclose(fid);
        
        date_number = datenum(WetArea{2});
        
        date_diff = date_number - date_number(1); % each year's increment of date
        % if ii == 1
            Oct2_WY = datenum(WetArea{2}(1));
        % end
        
        date_plot = Oct2_WY + date_diff;
        
        AreaAcre = WetArea{end};
    