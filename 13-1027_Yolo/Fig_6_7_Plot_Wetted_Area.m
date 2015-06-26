clear all; close all
% Read Wetted Area csv
% 3/26/14, sb

%% Root folder
cd('C:\Work\13-1027_Yolo\LT model\TUFLOW\post_process\Ag Econ');
model_year = 1997:2012;

% preallocate memory for cell array
Data{length(model_year)} = [];



%% -------------------- template without text box (for MS WORD template paste)
bot_ax = 0.05;
top_ax = 0.03;
%     rht_ax = 0.03;
rht_ax = 0.05;
%     lft_ax = 0.07;
lft_ax = 0.12;
ax_width0 = 1-lft_ax-rht_ax;
ax_height0 = 1-top_ax-bot_ax;


sub_gap = 0.05;
ax_height1 = (ax_height0-sub_gap*2)/3;
ax_width_axes1(1)  = ax_width0;

ax_height2 = ax_height1;
ax_width_axes1(2)  = ax_width0;

subplots = zeros(2,4);
subplots(3,1:4) = [lft_ax bot_ax+ax_height1*2+sub_gap*2 ax_width_axes1(1) ax_height1];
subplots(2,1:4) = [lft_ax bot_ax+ax_height1+sub_gap ax_width_axes1(1) ax_height1];
subplots(1,1:4) = [lft_ax bot_ax ax_width_axes1(1) ax_height1];



orientation = 'portrait';  % 'landscape'/'portrait'
figure_type = 'Letter';    % 'Letter'/'Legal'


[hf_1,h_axes1]=cbec_fig_NO_text(figure_type,orientation,subplots);


%%
% plot - curve color

% line_color = {'b','r','g','c','m','k','b--','r--','g--','c--','m--','k--','b:','r:','g:','c:'};
line_color = {'b','r','g','b','b','r','r','g','c','c','g','c','k','k','k','m'};

% line width
thick_l = 3;
med_l = 2;
thin_l = 1;

line_thick = [thick_l thick_l thick_l med_l thin_l thin_l med_l med_l med_l thick_l thin_l thin_l thin_l med_l thick_l med_l];
for ii = 1:length(model_year)
    filename = sprintf('%d\\Results\\WetAreaTabulation_yolo_200ft_Exg_TS6_____%d_{NearBypass}_Exg.csv', ...
        model_year(ii),model_year(ii));
    fid = fopen(filename);
    WetArea = textscan(fid,'%f%s%f%f%f','delimiter',',','headerlines',1);
    Data{ii} = WetArea;
    fclose(fid);
    
    %% plotting
    
    x_hour = WetArea{1};
    date_number = datenum(WetArea{2});
    
    date_diff = date_number - date_number(1); % each year's increment of date
    if ii == 1
        Oct2_1996 = datenum(WetArea{2}(1));
    end
    
    date_plot = Oct2_1996 + date_diff;
    switch line_thick(ii)
        case 3
%             plot(h_axes1(3),date_plot,WetArea{end},line_color{ii},'linewidth',line_thick(ii))
            plot(h_axes1(3),date_plot,WetArea{end},line_color{ii},'linewidth',1)
            hold(h_axes1(3),'on')
        case 2
            plot(h_axes1(2),date_plot,WetArea{end},line_color{ii},'linewidth',1)
            hold(h_axes1(2),'on')
        case 1
            plot(h_axes1(1),date_plot,WetArea{end},line_color{ii},'linewidth',1)
            hold(h_axes1(1),'on')
    end
    % hold on
    
    clear fid WetArea
    
    
    
end

y_limit = get(h_axes1(3),'ylim');
x_limit = get(h_axes1(3),'xlim');
new_x_lim = [datenum([str2double(datestr(x_limit(2),'yyyy'))-1 10 1]) datenum([str2double(datestr(x_limit(2),'yyyy')) 7 1])];

set(h_axes1(1),'ylim',y_limit);
set(h_axes1(2),'ylim',y_limit);
set(h_axes1(1),'xlim',new_x_lim);
set(h_axes1(2),'xlim',new_x_lim);
set(h_axes1(3),'xlim',new_x_lim);

for k = 1:3
    legend(h_axes1(k),num2str(model_year(line_thick == k)','%d'))
    datetick(h_axes1(k),'x','mmm','keeplimits')
    ylabel(h_axes1(k),'Area (acres)')
    grid(h_axes1(k),'on')
    
       
    curr_axis = h_axes1(k);

    %% change Y-axis number with non-scientific    
    numtick = get(curr_axis,'ytick')';
    strtick = cell(length(numtick),1);
    
    for kk = 1:length(strtick)
        strtick{kk} = commaint(numtick(kk));
    end
    
    set(curr_axis,'yticklabel',strtick)
    
    clear strtick numtick
%     %% change X-axis number with non-scientific    
%     numtick = get(curr_axis,'xtick')';
%     strtick = cell(length(numtick),1);
%     
%     for jj = 1:length(strtick)
%         strtick{jj} = commaint(numtick(jj));
%     end
%     
%     set(curr_axis,'xticklabel',strtick)
%     clear strtick numtick
    set(curr_axis,'fontsize',8)

end

title(h_axes1(3),'Wet years')
title(h_axes1(2),'Normal years')
title(h_axes1(1),'Dry years')



print(hf_1,'-dpng','Fig_6-7_wetted_area')

% export_fig('test2','-pdf','-nocrop','-transparent','-append',hf_1)