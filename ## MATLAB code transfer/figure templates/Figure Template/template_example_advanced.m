function template_example_advanced
%  feather river extract profiles from max WSE dfs2
% .mat files were saved in [Extract_Profile_line_CSV.m]

% 7/16/2013, sjb
% 3/17/2014, sjb rev.

close all
tic

%% load profile extract 
cur_path = pwd;
D = dir('*.mat');

for i = 1:length(D)
    eval(sprintf('%s = load(D(i).name);',D(i).name(1:end-4)))
end

%% Plotting
mile2km = 1.60934;
mile2meter = mile2km*1000;
meter2feet = 3937/1200;
fig_size = [100 100 1400 800];
figure_name_pdf = 'Feather_Final_PP';
font_name = 'Helvetica';
font_size = 11; % point

Len = Fea_Q2_PostBre_EX_HD_Max_WSE_25.Length;

%% bathy
bathy_path = [cur_path '\bathy'];
bathy_name_pre = 'Bathy_V2_EX_Shang_update_SBaek_10_PRE_BREACH_rev1_UPDATE.mat';
bathy_name_post = 'Bathy_V2_EX_Shang_update_SBaek_10_POST_BREACH_rev1_UPDATE.mat';
bathy_name_max = 'Bathy_V2_EX_Shang_update_SBaek_10_MAX_BREACH.mat';

Bathy_pre = load(fullfile(bathy_path,bathy_name_pre));
Bathy_post = load(fullfile(bathy_path,bathy_name_post));
Bathy_max = load(fullfile(bathy_path,bathy_name_max));

Bathy_pre.vq = Bathy_pre.vq.*meter2feet;
Bathy_post.vq = Bathy_post.vq.*meter2feet;
Bathy_max.vq = Bathy_max.vq.*meter2feet;

% bathy patch! - remove bumps around RM = 9.25
x1 = 7288; x2 = 7524;
y1 = Bathy_pre.vq(x1); y2 = Bathy_pre.vq(x2);
bathy_patch = linspace(y1,y2,x2-x1+1);

Bathy_pre.vq(x1:x2) = bathy_patch;
Bathy_post.vq(x1:x2) = bathy_patch;
Bathy_max.vq(x1:x2) = bathy_patch;


%% ------------------  Q2 
fig_text.source = 'elevation callouts reference sill or terrace elevations of proposed features';
fig_text.proj_title='Lower Feather River Corridor Management Plan';
fig_text.proj_number='11-1009';
fig_text.created_by = 'SB';
fig_text.description = ['Water surface profiles ' char(8212) ' 2' char(8211) 'year'];
fig_text.fig_number = num2str(19);


[hf_1,h_axes1]=cbec_fig_11x17('landscape',fig_text);
% hf_1 = wl_handle;

% hf_1 = figure;
% set(hf_1,'position',fig_size);

% existing

% remove outliers
Q2_PreBre_EX_HD_Max_WSE = remove_outlier(Q2_PreBre_EX_HD_Max_WSE);
Fea_Q2_PostBre_EX_HD_Max_WSE_25 = remove_outlier(Fea_Q2_PostBre_EX_HD_Max_WSE_25);
Q2_MaxBre_EX_HD_Max_WSE_25 = remove_outlier(Q2_MaxBre_EX_HD_Max_WSE_25);
Q2_PreBre_FUT_HD_Max_WSE_25 = remove_outlier(Q2_PreBre_FUT_HD_Max_WSE_25);
Fea_Q2_PostBre_FUT_HD_Max_WSE_25 = remove_outlier(Fea_Q2_PostBre_FUT_HD_Max_WSE_25);

% bathy
l(3) = plot(h_axes1,Len,Bathy_max.vq,'color','g');
hold on
l(2) = plot(h_axes1,Len,Bathy_post.vq,'color','r');
l(1) = plot(h_axes1,Len,Bathy_pre.vq,'color','k');

% WSP
l(6) = plot(h_axes1,Len,Q2_MaxBre_EX_HD_Max_WSE_25.vq,'g');
l(5) = plot(h_axes1,Len,Fea_Q2_PostBre_EX_HD_Max_WSE_25.vq,'r');
l(4) = plot(h_axes1,Len,Q2_PreBre_EX_HD_Max_WSE.vq,'k');

% future
l(8) = plot(h_axes1,Len,Fea_Q2_PostBre_FUT_HD_Max_WSE_25.vq,'--','color',[255 165 0]./255);  % orange dash
l(7) = plot(h_axes1,Len,Q2_PreBre_FUT_HD_Max_WSE_25.vq,'--','color',[0.5 0.5 0.5]);  % grey dash

% legend('Q2 Exist max','Q2 Exist post','Q2 Exist pre','Q2 Future post','Q2 Future pre','location','northwest')
legend_item = {'Starting Bed Pre-Breach ';'Starting Bed Post Breach ';'Starting Bed Max Breach '; ...
    'WSP Existing Pre-Breach ';'WSP Existing Post Breach ';'WSP Existing Max Breach '; ...
    'WSP Future Pre-Breach ';'WSP Future Post Breach ';'WSP Future Max Breach '};
legend(l,legend_item(1:length(l)),'location','northwest')
xlabel('River Miles','FontName',font_name,'FontSize',font_size)
ylabel('Elevation (ft, NAVD88)','FontName',font_name,'FontSize',11)
% title('Q2')

ylimit_low = 0;
% set(gca,'ylim',[ylimit_low 15]*meter2feet);
set(h_axes1,'ylim',[0 80]);
set(h_axes1,'xlim',[7 29])
set(h_axes1,'XTick',[7 10 15 20 25 29])

% RM callouts
RM_names = {'Sutter Bypass Confluence','Nelson Slough Lowered Floodplain','Hwy 99','Bear River Confluence', ...
    'Lake of the Woods Terrace','Lake of the Woods Swale','O''Conner Lakes Swale','Constructed Messick Lake Swale', ...
    'Feather River Setback Diversion Swale','Shanghai Rapids', ...
    'Old Feather River / Eliza Bend','Yuba River Confluence','Hwy 20 / 5th St'};
RM_num = [7.5 8.2 9.25 12.1 14.3 16.35 17.85 18.75 22.5 24 24.85 27 28.1];
% RM_num = [7.5 8.2 9.25 12.1 16.35 17.85 18.75 22.5 24.22 24.85 27 28.1];
[Len_unique, ia, ic] = unique(Len);   % remove duplicate RMs.
RM_wse = interp1(Len_unique,Q2_PreBre_EX_HD_Max_WSE.vq(ia),RM_num);

% Elevation marks
Elev_marks = {'23.5 ft','36.1 ft','35.1 ft','37.5 ft','22 ft','36.8 ft','43.1 ft'};
Elev_z  = [23.5 36.1 35.1 37.5 22 36.8 43.1];
Elev_RM_ind = [2 5 6 7 8 9 11];
Elev_RM = RM_num(Elev_RM_ind);

% for j = 1:length(RM_num)
%     
%     if j<0
%         line([RM_num(j) RM_num(j)],[RM_wse(j)+0.6 RM_wse(j)+1],'color',[0.5 0.5 0.5])
%         text(RM_num(j),RM_wse(j)+1.2,RM_names{j},'rotation',-90,'HorizontalAlignment','right', ...
%             'BackgroundColor',[1 1 1],'EdgeColor','w','Margin',0.01)
%     else
%         line([RM_num(j) RM_num(j)],[RM_wse(j)-0.45 RM_wse(j)-1],'color',[0.5 0.5 0.5])
%         text(RM_num(j),RM_wse(j)-1.2,RM_names{j},'rotation',-90,'HorizontalAlignment','left', ...
%             'BackgroundColor',[1 1 1],'EdgeColor','w','Margin',0.01)
%     end
% end
% text(18,39,'Water Surface Profiles (WSP)','HorizontalAlignment','center','rotation',0)
% text(18,3,'Starting Bed Profiles','HorizontalAlignment','center')

for j = 1:length(RM_num)
    
    if j>0
        if j == 9
            RM_wse(j) = RM_wse(j);
        end
        if j == 5 || j == 6 || j == 7 || j == 11
%             RM_wse(j) = Elev_z(find(Elev_RM_ind==j));
            vline_len = Elev_z(find(Elev_RM_ind==j)) - RM_wse(j);
            vline_offset = 0.6;
            vline_end = vline_offset+vline_len+0.6;
            vtext_offset = vline_end + 0.2;
        else
            vline_offset = 0.6;
            vline_end = vline_offset+0.4;
            vtext_offset = vline_end + 0.2;
        end
        line([RM_num(j) RM_num(j)],[RM_wse(j)+vline_offset RM_wse(j)+vline_end],'color',[0.5 0.5 0.5])
        text(RM_num(j),RM_wse(j)+vtext_offset,RM_names{j},'rotation',-90,'HorizontalAlignment','right', ...
            'BackgroundColor',[1 1 1],'EdgeColor','w','Margin',0.01,'FontName',font_name,'FontSize',11)
    else
            
        line([RM_num(j) RM_num(j)],[RM_wse(j)-0.45 RM_wse(j)-1],'color',[0.5 0.5 0.5])
        text(RM_num(j),RM_wse(j)-1.2,RM_names{j},'rotation',-90,'HorizontalAlignment','left', ...
            'BackgroundColor',[1 1 1],'EdgeColor','w','Margin',0.01,'FontName',font_name,'FontSize',11)
    end
end
text(18,32,'Water Surface Profiles (WSP)','HorizontalAlignment','center','rotation',0, ...
    'FontName',font_name,'FontSize',11)
text(20,19,'Starting Bed Profiles','HorizontalAlignment','center', ...
    'BackgroundColor',[1 1 1],'EdgeColor','w','Margin',0.01,'FontName',font_name,'FontSize',11)

% Elevation Marks
plot(h_axes1,Elev_RM,Elev_z,'s','MarkerSize',10,'MarkerEdgeColor','w','linewidth',2,'MarkerFaceColor','w')
plot(h_axes1,Elev_RM,Elev_z,'x','MarkerSize',10,'color','r','linewidth',2)

for k = 1:length(Elev_z)
    if k == length(Elev_z)
        vertical_align = 'bottom';
    else
        vertical_align = 'middle';
    end
    text(Elev_RM(k)+0.15,Elev_z(k),Elev_marks{k},'HorizontalAlignment','left','BackgroundColor',[1 1 1], ...
        'VerticalAlignment',vertical_align,'Color',[1 0 0],'EdgeColor','w','Margin',0.01, ...
        'FontName',font_name,'FontSize',11)
end

grid(gca,'on')

print(hf_1,'-dpdf','Q2')
% export_fig(figure_name_pdf,'-pdf','-nocrop','-transparent','-append',hf_1)

clear l fig_text
%% ------------------ Q10
fig_text.source = 'elevation callouts reference sill or terrace elevations of proposed features';
fig_text.proj_title='Lower Feather River Corridor Management Plan';
fig_text.proj_number='11-1009';
fig_text.created_by = 'SB';
fig_text.description = ['Water surface profiles ' char(8212) ' 10' char(8211) 'year'];
fig_text.fig_number = num2str(20);


[hf_2,h_axes2]=cbec_fig_11x17('landscape',fig_text);

% remove outliers
Q10_PreBre_EX_HD_Max_WSE = remove_outlier(Q10_PreBre_EX_HD_Max_WSE);
Fea_Q10_PostBre_EX_HD_Max_WSE_25 = remove_outlier(Fea_Q10_PostBre_EX_HD_Max_WSE_25);
Fea_Q10_MaxBre_EX_HD_Max_WSE_25_V2 = remove_outlier(Fea_Q10_MaxBre_EX_HD_Max_WSE_25_V2);
Fea_Q10_PreBre_FUT_HD_Max_WSE_25 = remove_outlier(Fea_Q10_PreBre_FUT_HD_Max_WSE_25);

% hf_2 = figure;
% set(hf_2,'position',fig_size);

% bathy
l(3) = plot(h_axes2,Len,Bathy_max.vq,'color','g');
hold on
l(2) = plot(h_axes2,Len,Bathy_post.vq,'color','r');
l(1) = plot(h_axes2,Len,Bathy_pre.vq,'color','k');


l(6) = plot(h_axes2,Len,Fea_Q10_MaxBre_EX_HD_Max_WSE_25_V2.vq,'g');
l(5) = plot(h_axes2,Len,Fea_Q10_PostBre_EX_HD_Max_WSE_25.vq,'r');
l(4) = plot(h_axes2,Len,Q10_PreBre_EX_HD_Max_WSE.vq,'k');

% future
l(7) = plot(h_axes2,Len,Fea_Q10_PreBre_FUT_HD_Max_WSE_25.vq,'--','color',[0.5 0.5 0.5]);  % grey dash

legend(l,legend_item(1:length(l)),'location','northwest')

xlabel('River Miles','FontName',font_name,'FontSize',11)
ylabel('Elevation (ft, NAVD88)','FontName',font_name,'FontSize',11)
% title('Q10')

set(gca,'ylim',[0 80]);
set(gca,'xlim',[7 29])
set(gca,'XTick',[7 10 15 20 25 29])
% RM callouts
% RM_names = {'Sutter Bypass confluence','Nelson Slough','Bear confluence', ...
%     'Lake of the Woods Swale','Conner Lakes Swale','Messick Lake', ...
%     'setback swale diversion','Shanghai rapid, crest', ...
%     'Old Feather River // Eliza Bend','Yuba confluence'};
% RM_num = [7.5 8.2 12.1 16.35 17.85 18.75 22.5 24 24.85 27];
% RM_wse = interp1(Len,Fea_Q10_PreBre_FUT_HD_Max_WSE_25.vq,RM_num);

[Len_unique, ia, ic] = unique(Len);   % remove duplicate RMs.
RM_wse = interp1(Len_unique,Fea_Q10_PreBre_FUT_HD_Max_WSE_25.vq(ia),RM_num);

RM_wse(isnan(RM_wse)) = RM_wse(find(isnan(RM_wse))-1)+3;

for j = 1:length(RM_num)
    
    if j>0
        line([RM_num(j) RM_num(j)],[RM_wse(j)+0.6 RM_wse(j)+1],'color',[0.5 0.5 0.5])
        h_text(j) = text(RM_num(j),RM_wse(j)+1.2,RM_names{j},'rotation',-90,'HorizontalAlignment','right', ...
            'BackgroundColor',[1 1 1],'EdgeColor','w','Margin',0.01,'FontName',font_name,'FontSize',11);
    else
        line([RM_num(j) RM_num(j)],[RM_wse(j)-0.45 RM_wse(j)-1],'color',[0.5 0.5 0.5])
        text(RM_num(j),RM_wse(j)-1.2,RM_names{j},'rotation',-90,'HorizontalAlignment','left', ...
            'BackgroundColor',[1 1 1],'EdgeColor','w','Margin',0.01,'FontName',font_name,'FontSize',11)
    end
end
% % Nelson Slough text fix
% set(h_text(2),'String','Slough Lowered Floodplain')
% text(RM_num(2)+0.25,61.03,'Nelson','rotation',-90,'FontSize',11,'BackgroundColor',[1 1 1],'EdgeColor','w','Margin',0.01,'FontName',font_name)
% % Feather River text fix
% set(h_text(9),'String','River Setback Diversion Swale')
% text(RM_num(9)+0.25,74.9,'Feather','rotation',-90,'FontSize',11,'BackgroundColor',[1 1 1],'EdgeColor','w','Margin',0.01,'FontName',font_name)

text(18,45,'Water Surface Profiles (WSP)','HorizontalAlignment','center','rotation',0,'FontName',font_name,'FontSize',11)
text(20,19,'Starting Bed Profiles','HorizontalAlignment','center', ...
    'BackgroundColor',[1 1 1],'EdgeColor','w','Margin',0.01,'FontName',font_name,'FontSize',11)
% Elevation Marks
plot(h_axes2,Elev_RM,Elev_z,'s','MarkerSize',10,'MarkerEdgeColor','w','linewidth',2,'MarkerFaceColor','w')
plot(h_axes2,Elev_RM,Elev_z,'x','MarkerSize',10,'color','r','linewidth',2)
for k = 1:length(Elev_z)
    if k == length(Elev_z)
        vertical_align = 'middle';
    else
        vertical_align = 'middle';
    end
    text(Elev_RM(k)+0.15,Elev_z(k),Elev_marks{k},'HorizontalAlignment','left','BackgroundColor',[1 1 1], ...
        'VerticalAlignment',vertical_align,'Color',[1 0 0],'EdgeColor','w','Margin',0.01,'FontName',font_name,'FontSize',11)
end
grid(gca,'on')


print(hf_2,'-dpdf','Q10')

% export_fig(figure_name_pdf,'-pdf','-nocrop','-transparent','-append',hf_2)
clear l fig_text h_text
%% ------------------ Q100
fig_text.source = 'elevation callouts reference sill or terrace elevations of proposed features';
fig_text.proj_title='Lower Feather River Corridor Management Plan';
fig_text.proj_number='11-1009';
fig_text.created_by = 'SB';
fig_text.description = ['Water surface profiles ' char(8212) ' 100' char(8211) 'year'];
fig_text.fig_number = num2str(21);


[hf_3,h_axes3]=cbec_fig_11x17('landscape',fig_text);

% remove outliers
Fea_Q100_PreBre_EX_HD_Max_WSE_25 = remove_outlier(Fea_Q100_PreBre_EX_HD_Max_WSE_25);
Q100_PostBre_EX_HD_Max_WSE_25 = remove_outlier(Q100_PostBre_EX_HD_Max_WSE_25);
Q100_MaxBre_EX_HD_Max_WSE_25 = remove_outlier(Q100_MaxBre_EX_HD_Max_WSE_25);
Fea_Q100_PreBre_FUT_HD_Max_WSE_25 = remove_outlier(Fea_Q100_PreBre_FUT_HD_Max_WSE_25);

% hf_3 = figure;
% set(hf_3,'position',fig_size);

% bathy
l(3) = plot(h_axes3,Len,Bathy_max.vq,'color','g');
hold on
l(2) = plot(h_axes3,Len,Bathy_post.vq,'color','r');
l(1) = plot(h_axes3,Len,Bathy_pre.vq,'color','k');

% WSP
l(6) = plot(h_axes3,Len,Q100_MaxBre_EX_HD_Max_WSE_25.vq,'g');
l(5) = plot(h_axes3,Len,Q100_PostBre_EX_HD_Max_WSE_25.vq,'r');
l(4) = plot(h_axes3,Len,Fea_Q100_PreBre_EX_HD_Max_WSE_25.vq,'k');

% future
l(7) = plot(h_axes3,Len,Fea_Q100_PreBre_FUT_HD_Max_WSE_25.vq,'--','color',[0.5 0.5 0.5]);  % grey dash

legend(l,legend_item(1:length(l)),'location','northwest')

xlabel('River Miles','FontName',font_name,'FontSize',11)
ylabel('Elevation (ft, NAVD88)','FontName',font_name,'FontSize',11)
% title('Q100')
set(gca,'ylim',[0 80]);
set(gca,'xlim',[7 29])
set(gca,'XTick',[7 10 15 20 25 29])
% RM callouts
% RM_names = {'Sutter Bypass confluence','Nelson Slough','Bear confluence', ...
%     'Lake of the Woods Swale','Conner Lakes Swale','Messick Lake', ...
%     'setback swale diversion','Shanghai rapid, crest', ...
%     'Old Feather River // Eliza Bend','Yuba confluence'};
% RM_num = [7.5 8.2 12.1 16.35 17.85 18.75 22.5 24 24.85 27];
% RM_wse = interp1(Len,Fea_Q100_PreBre_FUT_HD_Max_WSE_25.vq,RM_num);
[Len_unique, ia, ic] = unique(Len);   % remove duplicate RMs.
RM_wse = interp1(Len_unique,Fea_Q100_PreBre_FUT_HD_Max_WSE_25.vq(ia),RM_num);

for j = 1:length(RM_num)
    
    if j<0
        line([RM_num(j) RM_num(j)],[RM_wse(j)+0.6 RM_wse(j)+1],'color',[0.5 0.5 0.5])
        text(RM_num(j),RM_wse(j)+1.2,RM_names{j},'rotation',-90,'HorizontalAlignment','right', ...
            'BackgroundColor',[1 1 1],'EdgeColor','w','Margin',0.01,'FontName',font_name,'FontSize',11)
    else
        line([RM_num(j) RM_num(j)],[RM_wse(j)-0.45 RM_wse(j)-1],'color',[0.5 0.5 0.5])
        h_text(j) = text(RM_num(j),RM_wse(j)-1.2,RM_names{j},'rotation',-90,'HorizontalAlignment','left', ...
            'BackgroundColor',[1 1 1],'EdgeColor','w','Margin',0.01,'FontName',font_name,'FontSize',11);
    end
end


% Nelson Slough text fix
set(h_text(2),'String','Slough Lowered Floodplain')
text(RM_num(2)+0.25,RM_wse(2)-1.2,'Nelson','rotation',-90,'FontSize',11)

% Woods Terrace text fix
set(h_text(5),'String','Lake of the Woods')
text(RM_num(5)-0.25,RM_wse(5)-10,'Terrace','rotation',-90,'FontSize',11)

% Feather River text fix
set(h_text(9),'String','River Setback Diversion Swale')
text(RM_num(9)+0.25,RM_wse(9)-1.2,'Feather','rotation',-90,'FontSize',11)



text(18,65,'Water Surface Profiles (WSP)','HorizontalAlignment','center','rotation',0,'FontName',font_name,'FontSize',11)
text(20,19,'Starting Bed Profiles','HorizontalAlignment','center', ...
    'BackgroundColor',[1 1 1],'EdgeColor','w','Margin',0.01,'FontName',font_name,'FontSize',11)
% Elevation Marks
plot(h_axes3,Elev_RM,Elev_z,'s','MarkerSize',10,'MarkerEdgeColor','w','linewidth',2,'MarkerFaceColor','w')
plot(h_axes3,Elev_RM,Elev_z,'x','MarkerSize',10,'color','r','linewidth',2)
for k = 1:length(Elev_z)
    if k == length(Elev_z)
        vertical_align = 'middle';
    else
        vertical_align = 'middle';
    end
    text(Elev_RM(k)+0.15,Elev_z(k),Elev_marks{k},'HorizontalAlignment','left','BackgroundColor',[1 1 1], ...
        'VerticalAlignment',vertical_align,'Color',[1 0 0],'EdgeColor','w','Margin',0.01,'FontName',font_name,'FontSize',11)
end
grid(gca,'on')

print(hf_3,'-dpdf','Q100')

% export_fig(figure_name_pdf,'-pdf','-nocrop','-transparent','-append',hf_3)
clear l fig_text
%% ------------------ FAF
fig_text.source = 'elevation callouts reference sill or terrace elevations of proposed features';
fig_text.proj_title='Lower Feather River Corridor Management Plan';
fig_text.proj_number='11-1009';
fig_text.created_by = 'SB';
fig_text.description = ['Water surface profiles ' char(8212) ' FAF'];
fig_text.fig_number = num2str(18);


[hf_4,h_axes4]=cbec_fig_11x17('landscape',fig_text);

% remove outliers
Fea_FAF_Max_Bre_EX_HD_Max_WSE = remove_outlier(Fea_FAF_Max_Bre_EX_HD_Max_WSE,15);
Fea_FAF_PostBre_EX_HD_Max_WSE_v2 = remove_outlier(Fea_FAF_PostBre_EX_HD_Max_WSE_v2,15);
Fea_FAF_PreBre_EX_HD_Max_WSE_v2 = remove_outlier(Fea_FAF_PreBre_EX_HD_Max_WSE_v2,15);
Fea_FAF_PreBre_FUT_HD_Max_WSE_V2 = remove_outlier(Fea_FAF_PreBre_FUT_HD_Max_WSE_V2,15);
% 
% hf_4 = figure;
% set(hf_4,'position',fig_size);

% bathy
l(3) = plot(h_axes4,Len,Bathy_max.vq,'color','g');
hold on
l(2) = plot(h_axes4,Len,Bathy_post.vq,'color','r');
l(1) = plot(h_axes4,Len,Bathy_pre.vq,'color','k');

% WSP
l(6) = plot(h_axes4,Len,Fea_FAF_Max_Bre_EX_HD_Max_WSE.vq,'g');
l(5) = plot(h_axes4,Len,Fea_FAF_PostBre_EX_HD_Max_WSE_v2.vq,'r');
l(4) = plot(h_axes4,Len,Fea_FAF_PreBre_EX_HD_Max_WSE_v2.vq,'k');

% future
l(7) = plot(h_axes4,Len,Fea_FAF_PreBre_FUT_HD_Max_WSE_V2.vq,'--','color',[0.5 0.5 0.5]);  % grey dash


legend(l,legend_item(1:length(l)),'location','northwest')

xlabel('River Miles','FontName',font_name,'FontSize',11)
ylabel('Elevation (ft, NAVD88)','FontName',font_name,'FontSize',11)
% title('FAF')
set(gca,'ylim',[0 80]);
set(gca,'xlim',[7 29])
set(gca,'XTick',[7 10 15 20 25 29])
% RM callouts
RM_num = [7.5 8.2 9.25 12.1 14.3 16.35 17.85 18.75 22.5 24.1 24.85 27 28.1];
% RM_wse = interp1(Len,Fea_FAF_PreBre_EX_HD_Max_WSE_v2.vq,RM_num);
[Len_unique, ia, ic] = unique(Len);   % remove duplicate RMs.
RM_wse = interp1(Len_unique,Fea_FAF_PreBre_EX_HD_Max_WSE_v2.vq(ia),RM_num);


RM_wse(isnan(RM_wse)) = RM_wse(find(isnan(RM_wse))-1)+0.5;

for j = 1:length(RM_num)
    
    if j>0
        if j == 9
            RM_wse(j) = RM_wse(j);
        end
        if j == 2 || j == 5 || j == 6 || j== 7 || j == 9 || j == 11
            %             RM_wse(j) = Elev_z(find(Elev_RM_ind==j));
            vline_len = Elev_z(find(Elev_RM_ind==j)) - RM_wse(j);
            vline_offset = 0.6;
            vline_end = vline_offset+vline_len+0.6;
            vtext_offset = vline_end + 0.2;
        else
            vline_offset = 0.6;
            vline_end = vline_offset+0.4;
            vtext_offset = vline_end + 0.2;
        end
        line([RM_num(j) RM_num(j)],[RM_wse(j)+vline_offset RM_wse(j)+vline_end],'color',[0.5 0.5 0.5])
        text(RM_num(j),RM_wse(j)+vtext_offset,RM_names{j},'rotation',-90,'HorizontalAlignment','right', ...
            'BackgroundColor',[1 1 1],'EdgeColor','w','Margin',0.01,'FontName',font_name,'FontSize',11)
    else
            
        line([RM_num(j) RM_num(j)],[RM_wse(j)-0.45 RM_wse(j)-1],'color',[0.5 0.5 0.5])
        text(RM_num(j),RM_wse(j)-1.2,RM_names{j},'rotation',-90,'HorizontalAlignment','left', ...
            'BackgroundColor',[1 1 1],'EdgeColor','w','Margin',0.01,'FontName',font_name,'FontSize',11)
    end
end
text(18,27,'Water Surface Profiles (WSP)','HorizontalAlignment','center','rotation',0,'FontName',font_name,'FontSize',11)
text(20,19,'Starting Bed Profiles','HorizontalAlignment','center', ...
    'BackgroundColor',[1 1 1],'EdgeColor','w','Margin',0.01,'FontName',font_name,'FontSize',11)
% Elevation Marks
plot(h_axes4,Elev_RM,Elev_z,'s','MarkerSize',10,'MarkerEdgeColor','w','linewidth',2,'MarkerFaceColor','w')
plot(h_axes4,Elev_RM,Elev_z,'x','MarkerSize',10,'color','r','linewidth',2)
for k = 1:length(Elev_z)
    if k == 1
        vertical_align = 'cap';
    else
        vertical_align = 'middle';
    end
    text(Elev_RM(k)+0.15,Elev_z(k),Elev_marks{k},'HorizontalAlignment','left','BackgroundColor',[1 1 1], ...
        'VerticalAlignment',vertical_align,'Color',[1 0 0],'EdgeColor','w','Margin',0.01,'FontName',font_name,'FontSize',11)
end
grid(gca,'on')

% plot(Length,vq)
print(hf_4,'-dpdf','FAF')

% export_fig(figure_name_pdf,'-pdf','-nocrop','-transparent','-append',hf_4)
toc

function var = remove_outlier(varargin)

varn = varargin{1};
if length(varargin) >1
    cut_off = varargin{2};
else
    cut_off = 15;
end
mile2km = 1.60934;
mile2meter = mile2km*1000;
meter2feet = 3937/1200;

varn.vq = varn.vq*meter2feet;
ind1 = find(abs(diff(varn.vq))>0.05);
ind2 = find(varn.Length<cut_off);
ind = intersect(ind1,ind2);
varn.vq(ind+1) = NaN;

if length(varargin) > 1
    ind3 = find(varn.Length>22.6);
    ind4 = find(varn.vq < 31.5);
    ind_v2 = intersect(ind3,ind4);
    
    varn.vq(ind_v2) = NaN;
    
end






var = varn;

% function RM_callouts(gcf)
