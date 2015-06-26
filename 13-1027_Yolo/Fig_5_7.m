clear all; close all;
% Figure 5.7
cd('C:\Work\13-1027_Yolo\DOC\Ch 5 figures')

%% read data
fid = fopen('Figure5_7_data.txt');
D = textscan(fid,'%f%*s%f%f','headerlines',1);
fclose(fid);

%% read thalweg
fidt = fopen('thalweg.txt');
T = textscan(fidt,'%f%f','headerlines',1);
fclose(fidt);


%% label
label_name = {'Ag Crossing 1';'Ag Crossing 2';'Ag Crossing 3';'KLRC';'I-5';'Swanston Weir';'Willow Sl';'I-80';'Putah Ck';'Lisbon Weir'};
label_st   = [6720 9351 12808 19200 31602 67112 70851 72600 94200 108200];

%  figure out fictitious y-location for label's x-coordinate
DD = [D{2} D{3}];
maxd = max(DD,[],2);  % select higher between two so that call out line can be start from it

label_y = interp1([6.651e3; 9.939e3; D{1}],[20; 17.16; maxd],label_st); % two values added because label_st precedes first data point: D{1}(1)

%% plotting

orientation = 'landscape';  % 'landscape'/'portrait'
figure_type = 'Letter';    % 'Letter'/'Legal'
font_name = 'Helvetica';
font_size = 9;

[hf_1,h_axes]=cbec_fig_NO_text(figure_type,orientation);


h1 = plot(h_axes,T{1},T{2},'k');
hold(h_axes)
h2 = plot(h_axes,D{1},D{2},'r.');  % measured
h3 = plot(h_axes,D{1},D{3});  % modeled
grid(h_axes)

l1 = legend(h_axes,[h2 h3 h1],'Measured','Modeled','Thalweg');
ylabel('Stage (ft, NAVD88)','fontname',font_name,'fontsize',font_size)
xlabel('Station from north end of Tule Pond (ft)','fontname',font_name,'fontsize',font_size)

leg_pos = get(l1,'position');
leg_pos_out = get(l1,'Outerposition');

%% R2/RMSE

R2 = regstats(D{2},D{3},'linear','rsquare');
RMSE = sqrt(nanmean((D{2}-D{3}).^2));

% % patch_xs = [leg_pos(1) leg_pos(1) leg_pos(1)+leg_pos(3) leg_pos(1)+leg_pos(3)];
% % patch_ys = [leg_pos(2)-leg_pos(4) leg_pos(2)-leg_pos(4)+leg_pos(4)/2 leg_pos(2)-leg_pos(4)+leg_pos(4)/2 leg_pos(2)-leg_pos(4)];
% 
% patch_xs = [94700 94700 109250 109250];
% patch_ys = [18 21 21 18];
% 
 text_axes1 = {sprintf('R^2 = %.3f',R2.rsquare); ...
     sprintf('RMSE = %.3f',RMSE)};
% % text(20.3,13,text_axes1,'VerticalAlignment','top','fontsize',font_size)
% t_x = patch_xs(1) + 900;
% t_y = patch_ys(2)-0.1;
% 
% C = [0 0 0 0];
% patch(patch_xs,patch_ys,C,'facecolor','w')
% text(t_x,t_y,text_axes1,'VerticalAlignment','top','fontsize',font_size,'fontname',font_name)

fix = 0.039;
h2 = axes('position',[leg_pos(1)+fix leg_pos(2)-0.05 leg_pos(3)-fix leg_pos(4)-.04],'units','normalized','ActivePositionProperty','position');
% h2 = axes('OuterPosition',[leg_pos_out(1) leg_pos_out(2)-0.1 leg_pos_out(3) leg_pos_out(4)],'units','normalized');

set(h2,'box','on')
set(h2,'xtick',[])
set(h2,'ytick',[])
t_x = 0.1;
t_y = 1-.1;
text(t_x,t_y,text_axes1,'VerticalAlignment','top','fontsize',font_size,'fontname',font_name, ...
    'horizontalalignment','left','verticalalignment','top')

set(gcf,'currentAxes',h_axes)
%% labeling
label_st_y = [7.5 6 6 2.5 0 -2.2 3 -8 -9]; % this is approximation by eyes

vline_offset = 0.5;
vline_end = vline_offset+ 1;
vtext_offset = vline_end + 0.3;
for j = 1:length(label_st)
    
    
    
    
    % line([label_st(j) label_st(j)],[label_y(j)+vline_offset label_y(j)+vline_end],'color',[0.5 0.5 0.5])
    line([label_st(j) label_st(j)],[label_y(j)+vline_offset label_y(j)+vline_end],'color',[0 0 0])
    text(label_st(j),label_y(j)+vtext_offset,label_name{j},'rotation',90,'HorizontalAlignment','left', ...
        'BackgroundColor',[1 1 1],'EdgeColor','w','Margin',0.01,'FontName',font_name,'FontSize',font_size)

    
    
    
    
    
    
    
    
    
    
    
%     text(label_st(i),label_st_y(i),label_name{i},'rotation',-90,'HorizontalAlignment','right', ...
%         'BackgroundColor',[1 1 1],'EdgeColor','w','Margin',0.01, ...
%         'FontName',font_name,'FontSize',font_size)

end

set(h_axes,'xlim',[0 110000])
set(h_axes,'ylim',[-10 30])
set(h_axes,'fontname',font_name,'fontsize',font_size)
%% change X-axis number with non-scientific
numtick = get(h_axes,'xtick')';
strtick = cell(length(numtick),1);

for jj = 1:length(strtick)
    strtick{jj} = commaint(numtick(jj));
end

set(h_axes,'xticklabel',strtick)
clear strtick numtick

print_name = sprintf('Fig_5-7_r300_test_%s_%s',figure_type,orientation);
print(hf_1,'-djpeg','-r300',print_name)
