clear all; close all
% Read Wetted Area csv
% 3/26/14, sb

%% Root folder
cd('C:\Work\13-1027_Yolo\LT model\TUFLOW\post_process\Ag Econ');
model_year = 1997:2012;

% preallocate memory for cell array
Data{length(model_year)} = [];

hf_1 = figure('Position',[500 40 800 1000]);
orient(hf_1,'portrait')
h1 = subplot(3,1,1);
h2 = subplot(3,1,2);
h3 = subplot(3,1,3);

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
%             plot(h3,date_plot,WetArea{end},line_color{ii},'linewidth',line_thick(ii))
            plot(h3,date_plot,WetArea{end},line_color{ii},'linewidth',1)
            hold(h3,'on')
        case 2
            plot(h2,date_plot,WetArea{end},line_color{ii},'linewidth',1)
            hold(h2,'on')
        case 1
            plot(h1,date_plot,WetArea{end},line_color{ii},'linewidth',1)
            hold(h1,'on')
    end
    hold on
    
    clear fid WetArea
    
    
    
end

y_limit = get(h3,'ylim');
x_limit = get(h3,'xlim');

set(h1,'ylim',y_limit);
set(h2,'ylim',y_limit);
set(h1,'xlim',x_limit);
set(h2,'xlim',x_limit);

legend(h3,num2str(model_year(line_thick == 3)','%d'))
legend(h2,num2str(model_year(line_thick == 2)','%d'))
legend(h1,num2str(model_year(line_thick == 1)','%d'))


datetick(h3,'x','mmm','keeplimits')
datetick(h2,'x','mmm','keeplimits')
% set(h2,'xticklabel',[])
datetick(h1,'x','mmm','keeplimits')
% set(h1,'xticklabel',[])

ylabel(h3,'Area (acres)')
ylabel(h2,'Area (acres)')
ylabel(h1,'Area (acres)')

title(h3,'Wet years')
title(h2,'Normal years')
title(h1,'Dry years')

grid(h3,'on')
grid(h2,'on')
grid(h1,'on')
export_fig('test2','-pdf','-nocrop','-transparent','-append',hf_1)