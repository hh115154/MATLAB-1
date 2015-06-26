clear all; close all;
% Figure 5.11
cd('C:\Work\13-1027_Yolo\DOC\Ch 5 figures')

orientation = 'portrait';  % 'landscape'/'portrait'
figure_type = 'Letter';    % 'Letter'/'Legal'


%% read data
fid = fopen('Figure5_11_data.csv');
D = textscan(fid,'%s%f%f%f','headerlines',1,'delimiter',',');
fclose(fid);

ts = datenum(D{1});

%% setup axis

bot_ax = 0.05;
top_ax = 0.03;
%     rht_ax = 0.03;
rht_ax = 0.05;
%     lft_ax = 0.07;
lft_ax = 0.12;
ax_width0 = 1-lft_ax-rht_ax;
ax_height0 = 1-top_ax-bot_ax;


sub_gap = 0.05;
ax_height1 = (ax_height0-sub_gap)/2;
ax_width1  = ax_width0;

ax_height2 = ax_height1;
ax_width2  = ax_width0;

subplots = zeros(2,4);
subplots(1,1:4) = [lft_ax bot_ax+ax_height2+sub_gap ax_width1 ax_height1];
subplots(2,1:4) = [lft_ax bot_ax ax_width1 ax_height1];

[hf_1,h_axes1]=cbec_fig_NO_text(figure_type,orientation,subplots);


%% Plotting
font_size = 9;

% top panel --------------------------------------------------------------

h2 = plot(h_axes1(2),ts,D{3},'r');
hold(h_axes1(2),'on')
h1 = plot(h_axes1(2),ts,D{2});
h3 = plot(h_axes1(2),ts,D{4},'g');

y_lim_top = get(h_axes1(2),'ylim');
set(h_axes1(2),'ylim',[0 y_lim_top(2)])

legend(h_axes1(2),[h1,h2,h3],'FRE Obs','Modified','FRE Est = YBY-(KLRC+CCSB)')
grid(h_axes1(2),'on')
set(h_axes1(2),'fontsize',font_size)

ylabel(h_axes1(2),'Flow (cfs)','fontsize',font_size)

% x_lim = [datenum([2011 4 2]) datenum([2011 4 12])];
% set(h_axes1(2),'xlim',x_lim)
% x_tick_new = datenum
datetick(h_axes1(2),'x','mm/dd/yyyy','keepticks')


% change Y-axis number with non-scientific

numtick = get(h_axes1(2),'ytick')';
strtick = cell(length(numtick),1);

for jj = 1:length(strtick)
    strtick{jj} = commaint(numtick(jj));
end

set(h_axes1(2),'yticklabel',strtick)
clear strtick numtick

% bottom panel --------------------------------------------------------------

h2 = plot(h_axes1(1),ts,D{3},'r');
hold(h_axes1(1),'on')
h1 = plot(h_axes1(1),ts,D{2});
h3 = plot(h_axes1(1),ts,D{4},'g');


legend(h_axes1(1),[h1,h2,h3],'FRE Obs','Modified','FRE Est = YBY-(KLRC+CCSB)')

set(h_axes1(1),'fontsize',font_size)

 
x_lim = [datenum([2011 4 2]) datenum([2011 4 12])];
set(h_axes1(1),'xlim',x_lim)

y_lim_top = get(h_axes1(1),'ylim');
set(h_axes1(1),'ylim',[0 y_lim_top(2)])
grid(h_axes1(1),'on')
set(h_axes1(2),'fontsize',font_size)

ylabel(h_axes1(1),'Flow (cfs)','fontsize',font_size)

set(h_axes1(1),'xtick',x_lim(1):2:x_lim(2))
datetick(h_axes1(1),'x','mm/dd/yyyy','keepticks')

% change Y-axis number with non-scientific

numtick = get(h_axes1(1),'ytick')';
strtick = cell(length(numtick),1);

for jj = 1:length(strtick)
    strtick{jj} = commaint(numtick(jj));
end

set(h_axes1(1),'yticklabel',strtick)
clear strtick numtick

%% printing

print_name = sprintf('Fig_5-11_r300_test_%s_%s',figure_type,orientation);
print(hf_1,'-djpeg','-r300',print_name)
