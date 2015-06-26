function Load_FLT_animation(cfg)
close all
tic
% convert FLT to xyz for plotting

%% Read configuration file
% [fn,pn] = uigetfile('*.cfg', 'Pick a configuration file ...');

% fidc = fopen(fullfile(pn,fn));
fidc = fopen(cfg);

C_cfg = textscan(fidc,'%s','delimiter',sprintf('\n'));

path_FLT   = C_cfg{1}{2};
item_sel   = C_cfg{1}{4};
image_name = C_cfg{1}{6};
fpath_WT   = C_cfg{1}{8};
fpath_OBS  = C_cfg{1}{10};

% fn_shp       = C_cfg{1}{10};
% item_shp     = str2double(C_cfg{1}{12});

fclose(fidc);

%%

% -------------- 1999
% cd('\\Cbecm11\e\Work\Projects\13-1027_YBM\LT Model\TUFLOW\results\1999\NearBypass\grids')
% -------------- 2008
% cd('E:\Work\Projects\13-1027_Yolo_Bypass_Fish_Passage\LT Model\TUFLOW\results\2008\NearBypass\grids')
cd(path_FLT)
flt_path = pwd;

s = regexp(pwd,'\','split');
model_year = str2double(s{end-2});

%% USER selection
% ------------------ what to plot
% item_sel = 'h';
% item_sel = 'd';
% item_sel = 'V';

file_find_str = sprintf('yolo*Exg*%s*.flt',item_sel);
D = dir(file_find_str);

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

TS_start = str2double(D(1).name(end-9:end-4));
TS_end = str2double(D(end-1).name(end-9:end-4));


nFrames = length(D)-1;   % exclude FLT with max values
% Preallocate movie structure.
mov(1:nFrames) = struct('cdata', [],...
    'colormap', []);
% folder check for movie

if isempty(dir('..\..\avi'))
   mkdir('..\..\avi'); 
end

   
vidObj = VideoWriter(fullfile('..\..\avi\',sprintf('yolo_Exg_%s_%d.avi',item_name,model_year)));
vidObj.Quality = 100;
vidObj.FrameRate = 4;
open(vidObj);

hf_1 = figure('Position',[500 40 1300 900]);
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
fname_1D_Q = sprintf('yolo_200ft_Exg_TS6_____%d_1d_Q.csv',model_year);
fname_1D_h = sprintf('yolo_200ft_Exg_TS6_____%d_1d_H.csv',model_year);


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

%% 
for i = 1:length(D)
    %  for i = 1:5
    
    if ~isempty(findstr(D(i).name,'Max'))
        continue
    end
    
    % eval(sprintf('%s = load(D(i).name);',D(i).name(1:end-4)))
    
    filen = D(i).name;
    hdrn = sprintf('%s.hdr',filen(1:end-4));
    
    
    hour_passed = str2double(filen(end-9:end-4));
    cur_date = addtodate(datenum([1996 10 2 0 0 0]),hour_passed,'hour');
    
    % plot item
    switch filen(end-11)
        case 'd'
            item_name = 'Depth';
        case 'h'
            item_name = 'WSE';
        case 'V'
            item_name = 'Velocity';
    end
    
    % filen = 'yolo_200ft_Exg_TS6_____2008_NearBypass_d_102216.flt';
    % hdrn  = 'yolo_200ft_Exg_TS6_____2008_NearBypass_d_102216.hdr';
    
    fid = fopen(fullfile(flt_path,hdrn));
    
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
    
    GRID = readmtx(fullfile(flt_path,filen),nrows,ncols,'float32',[1 nrows],[1 ncols],'ieee-le');
    
    
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
    GRID(GRID==NoData) = NaN;
    [ii,jj,v] = find(~isnan(GRID));
    
    xcoord = xcor + jj.*dxy - dxy/2;
    ycoord = (ycor + nrows*dxy) - ii*dxy + dxy/2;
    zcoord = GRID(~isnan(GRID));
    
    %% boundary (hardwired)
    xmin = min(xcoord);
    xmax = 2.04755958e6;
    
    ymin = 1.391499203e7;
    ymax = 1.409063861e7;
    % ymid = 1.399924803e7;
    ymid = (ymax+ymin)/2;
    
    xcoordN = xcoord(xcoord>xmin & xcoord<xmax & ycoord>ymid & ycoord<ymax);
    ycoordN = ycoord(xcoord>xmin & xcoord<xmax & ycoord>ymid & ycoord<ymax);
    zcoordN = zcoord(xcoord>xmin & xcoord<xmax & ycoord>ymid & ycoord<ymax);
    
    xcoordS = xcoord(xcoord>xmin & xcoord<xmax & ycoord>ymin & ycoord<ymid);
    ycoordS = ycoord(xcoord>xmin & xcoord<xmax & ycoord>ymin & ycoord<ymid);
    zcoordS = zcoord(xcoord>xmin & xcoord<xmax & ycoord>ymin & ycoord<ymid);
    
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
    
    %
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
        
        plot(s3,freQ_time,freQ_data,'--')
        hold(s3,'on')
        plot(s3,TS_PO_time,Data_FreQ)   % hourly data from PO.csv file (2D output)
        plot(s3,vonQ_time,vonQ_data,'r--')
        plot(s3,TS_PO_time(1:6:end),VON_Q_1D{1},'r')  % 6 hour data from 1D output
        
        set(s3,'xlim',[TS_PO_time(1) TS_PO_time(end)])
        set(s3,'fontsize',8)
        % axis(s3,'tight')
        leg_s3 = legend(s3,'FRE-Obs','FRE-Sim','VON-Obs','VON-Sim');
        datetick(s3,'x','mmm','keeplimits')
        set(s3,'xticklabel',[]);
        title(s3,'Flow Time Series')
        ylabel(s3,'cfs')

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
            'Putah','Willow');
        title(s4,'Westside Tributary Inflows')
        datetick(s4,'x','mmm','keeplimits')
        set(s4,'xticklabel',[]);
        ylabel(s4,'cfs')
    end
    y_lim = get(s4,'ylim');
    % line added for the current time indicator
    set(gcf,'CurrentAxes',s4)
    l4 = line([cur_date cur_date],[y_lim(1) y_lim(2)],'color','k');
    %     set(s4,'nextplot','replacechildren');
    %% Time series: Figure 5
    if i == 1
        s5 = axes('position',[0.65 0.11 .3 .247]);
        hold on
        % plot title
        plot(s5,freH_time,freH_data,'--')
        hold(s5,'on')
        plot(s5,TS_PO_time,Data_FreWSE_w)
        % plot(s5,TS_PO_time,Data_FreWSE_e,'r')
        plot(s5,yby_time,yby_data,'r--')
        plot(s5,TS_PO_time(1:6:end),h_1D{2},'r')
        plot(s5,TS_PO_time(1:6:end),h_1D{1},'g')
        plot(s5,TS_PO_time(1:6:end),h_1D{3},'k')
        
        set(s5,'xlim',[TS_PO_time(1) TS_PO_time(end)])
        set(s5,'fontsize',8)
        
        % axis(s5,'tight')
        % leg_s5 = legend(s5,'FRE-Sim(W)','FRE-Sim(E)','YBY-Sim','LIS-Sim','LIY-Sim');
        leg_s5 = legend(s5,'FRE-Obs','FRE-Sim','YBY-Obs','YBY-Sim','LIY-Sim','LIS-Sim');
        title(s5,'Stage Time Series')
        datetick(s5,'x','mmm','keeplimits')
        xlabel(s5,sprintf('WY %d',model_year))
        ylabel(s5,'ft')
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

fprintf(1,'\nTotal time = %.1f min\n',timecheck/60)

% export_fig('sample_fig','-pdf','-nocrop','-transparent','-append',hf_1)
% print(hf_1,'-dpdf','sample2')

% Create AVI file.
% movie2avi(mov, 'mySample.avi', 'compression', 'none','fps',1);
close(vidObj);
close all

