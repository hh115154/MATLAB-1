clear all; close all
% only when debugging
cd('C:\Work\13-1027_Yolo\LT model\TUFLOW\Time_Series_plot')

path_PO = 'PO_files';
PO = dir([path_PO '\*.csv']);

path_OBS = 'OBS_data';
OBS = dir([path_OBS '\*.mat']);

%% Read Model Run length file (hardwired)
% [fn,pn] = uigetfile('*.cfg', 'Pick a configuration file ...');
% 
fidc = fopen('Model_Run_length.txt');
% 
% C_cfg = textscan(fidc,'%s','delimiter',sprintf('\n'));
Output = textscan(fidc,'%f%f%s%f%s','delimiter','\t','headerlines',1);
modelYear = Output{1};
startHr   = Output{2};
endHr     = Output{4};
startDate = Output{3};
endDate   = Output{5};
% 
fclose(fidc);
%%

% cd(path_PO)
% flt_path = pwd;
% 
% s = regexp(pwd,'\','split');
% model_year = str2double(s{end-2});

%%
% modelYear = 1997:2012;

%% plot setup
% Figure template
fig_text.source = 'TUFLOW model output: Fremont modeled and observed data';
fig_text.proj_title='Yolo Bypass Fish Passage';
fig_text.proj_number='13-1027';
fig_text.created_by = 'SB';
% fig_text.description = ['Water surface profiles ' char(8212) ' 2' char(8211) 'year'];
fig_text.description = 'Fremont Q';
fig_text.fig_number = num2str(1);


% subplot positions
plot_width = 0.054;


s = zeros(1,length(modelYear));
subplots = zeros(length(modelYear),4);
for k = 1:length(modelYear)
    % no gap between axes
    subplots(k,1:4) = [0.09+plot_width*(k-1) 0.17 plot_width 0.76];
    % use accordion for axis cuts
    % subplots(k,1:4) = [0.09+plot_width*(k-1) 0.17 plot_width-.01 0.76];
end







[hf_1,h_axes1]=cbec_fig_11x17('landscape',fig_text,subplots);

% s3 = axes('position',[0.65 0.664 .3 .247]);
% hf_1 = figure('position',[110 200 1700 750]);



%% TS: OBS data

for j = 1:length(OBS)   % read MAT files for OBS data
    load([path_OBS '\' OBS(j).name])
end

%{
variable names
freH_time, freH_data : hourly
freQ_time, freQ_data : daily
vonQ_time, vonQ_data : daily
yby_time, yby_data   : hourly
%}



%% TS: PO files (model results)
line_color = ...
    {'b','r','g','c','k','m','b','r','g','c','k','m','b','r','g','c','k','m'};

min_value_old = 0;
max_value_old = 0;

        
for j = 1:length(modelYear)
    
    
    
    %% Figure 1. FREMONT Sim & Obs
    % fpath_PO = sprintf('%d',modelYear(j));
    
    % file_find_str = sprintf('yolo*Exg*%s*.flt',item_sel);
    % D = dir([sprintf('%d/NearBypass/grids/',modelYear(j)) file_find_str]);

    
    % fname_PO = sprintf('yolo_200ft_Exg_TS6_____%d_PO.csv',modelYear(j));
    fname_PO = PO(j).name;
    fidPO = fopen(fullfile(path_PO,fname_PO));
    readfmt = ['%*s%f' repmat('%*f',1,23) '%f%*f%f%*f%*f%f'];
    PO_Model_data = textscan(fidPO,readfmt,'delimiter',',','headerlines',2);
    fclose(fidPO);
    
    TS_PO_hr = PO_Model_data{1};
    TS_PO = TS_PO_hr(TS_PO_hr>=startHr(j) & TS_PO_hr<=endHr(j));
    Data_FreWSE_w = PO_Model_data{2}(TS_PO_hr>=startHr(j) & TS_PO_hr<=endHr(j));
    Data_FreWSE_e = PO_Model_data{3}(TS_PO_hr>=startHr(j) & TS_PO_hr<=endHr(j));
    Data_FreQ = PO_Model_data{4}(TS_PO_hr>=startHr(j) & TS_PO_hr<=endHr(j));
    dTS_PO = TS_PO - TS_PO(1);   % time(hour) differences from the 1st entry
    
    % in real time (datenum)
    TS_PO_time = addtodate(datenum([1996 10 2 0 0 0]),TS_PO(1),'hour') + dTS_PO./24;
    
    % -----------------
    %% Plot OBS data
    curr_axis = h_axes1(length(modelYear)-j+1);
    plot(curr_axis,freQ_time,freQ_data,'--')
    hold(curr_axis,'on')

    plot(curr_axis,TS_PO_time,Data_FreQ,line_color{j})   % hourly data from PO.csv file (2D output)

    set(curr_axis,'xlim',[TS_PO_time(1) TS_PO_time(end)])
    % set(curr_axis,'xlim',[TS_PO_time(1) TS_PO_time(end)+15])  % extra for accordion
    if j == 1
        ylabel(curr_axis,'Flow rate (cfs)')
        
        
    else
        % set(curr_axis,'Ycolor','w')
        set(curr_axis,'yticklabel',[])
        plot(curr_axis,[TS_PO_time(1) TS_PO_time(1)],[min_value max_value],'w')
    end
    % datetick(curr_axis,'x','mmm','keeplimits')
    xlabel(curr_axis,sprintf('%d',modelYear(j)))

%     
    set(curr_axis,'xtick',[])
    set(curr_axis,'box','off')
    set(curr_axis,'ticklength',[0.001 0.01])
    
    
    %% plot accordion  - NOT GOOD
    x_accord = [0 .5  1 1.5  2 2.5 3];
    y_accord = [0 .5 -1 1   -1  .5 0];
    %plot(curr_axis,x_accord*5+TS_PO_time(end),y_accord*10^4,'k')
    
    %% double slashes
    y_tick = get(curr_axis,'ytick');
%     t1=text(curr_axis,TS_PO_time(end)-30,y_tick(1),'//','fontsize',15);
    set(gcf,'CurrentAxes',curr_axis)
    text(TS_PO_time(end)-31,0,'//','fontsize',15)
    
    min_value = min(min_value_old,min(Data_FreQ));
    max_value = max(max_value_old,max(Data_FreQ));
    
    min_value_old = min_value;
    max_value_old = max_value;
%     fprintf(1,'year %d processed\n',modelYear(j));
end

for k = 1:length(modelYear)
    curr_axis = h_axes1(length(modelYear)-k+1);
    set(curr_axis,'ylim',[min_value max_value])
    set(curr_axis,'YGrid','on')
end



print(hf_1,'-dpdf','Fremont_Q')




