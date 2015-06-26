function template_Yolo_example_simple
%  feather river extract profiles from max WSE dfs2
% .mat files were saved in [Extract_Profile_line_CSV.m]

% 7/16/2013, sjb
% 3/17/2014, sjb rev.
% 5/7/2014, sjb rev. 2
close all
tic

%
%
%
%
%
%
%       Following section is to prepare data for plotting
%
%
%
%
%
%

%% load profile extract 
cur_path = pwd;
D = dir('*.mat');

for i = 1:length(D)
    eval(sprintf('%s = load(D(i).name);',D(i).name(1:end-4)))
end


mile2km = 1.60934;
mile2meter = mile2km*1000;
meter2feet = 3937/1200;
fig_size = [100 100 1400 800];
figure_name_pdf = 'Feather_Final_PP';
font_name = 'Helvetica';
font_size = 11; % point

Len = Fea_Q2_PostBre_EX_HD_Max_WSE_25.Length;

% bathy
bathy_path = [cur_path '\bathy'];
bathy_name_pre = 'Bathy_V2_EX_Shang_update_SBaek_10_PRE_BREACH_rev1_UPDATE.mat';

Bathy_pre = load(fullfile(bathy_path,bathy_name_pre));

Bathy_pre.vq = Bathy_pre.vq.*meter2feet;

% bathy patch! - remove bumps around RM = 9.25
x1 = 7288; x2 = 7524;
y1 = Bathy_pre.vq(x1); y2 = Bathy_pre.vq(x2);
bathy_patch = linspace(y1,y2,x2-x1+1);

Bathy_pre.vq(x1:x2) = bathy_patch;





%%  TEMPLATE figure box texts and etc.
%
%
%
%
fig_text.source = 'elevation callouts reference sill or terrace elevations of proposed features';
fig_text.proj_title='Lower Feather River Corridor Management Plan';
fig_text.proj_number='11-1009';
fig_text.created_by = 'SB';
fig_text.description = ['Water surface profiles ' char(8212) ' 2' char(8211) 'year'];
fig_text.fig_number = num2str(19);


% -------------------------------------------------- choose size and orientation
[hf_1,h_axes1]=template_Yolo_fig_11x17('landscape',fig_text);
% [hf_1,h_axes1]=template_Yolo_fig_11x17('portrait',fig_text);
% [hf_1,h_axes1]=template_Yolo_fig_Letter('landscape',fig_text);
% [hf_1,h_axes1]=template_Yolo_fig_Letter('portrait',fig_text);



%
%
%
%
%          now the figure has axis handle [h_axes1]. All plots will need to
%          use this handle; use exmaple script as follows.
%
%
%
%



%% remove outliers
Q2_PreBre_EX_HD_Max_WSE = remove_outlier(Q2_PreBre_EX_HD_Max_WSE);


l(1) = plot(h_axes1,Len,Bathy_pre.vq,'color','k');
hold on
l(2) = plot(h_axes1,Len,Q2_PreBre_EX_HD_Max_WSE.vq,'k');

legend_item = {'Starting Bed Pre-Breach '; 'WSP Existing Pre-Breach ';'WSP Existing Post Breach '};
legend(l,legend_item(1:length(l)),'location','northwest')
xlabel('River Miles','FontName',font_name,'FontSize',font_size)
ylabel('Elevation (ft, NAVD88)','FontName',font_name,'FontSize',11)

set(h_axes1,'ylim',[0 80]);
set(h_axes1,'xlim',[7 29])
set(h_axes1,'XTick',[7 10 15 20 25 29])

% RM callouts

text(18,32,'Water Surface Profiles (WSP)','HorizontalAlignment','center','rotation',0, ...
    'FontName',font_name,'FontSize',11)
text(20,19,'Starting Bed Profiles','HorizontalAlignment','center', ...
    'BackgroundColor',[1 1 1],'EdgeColor','w','Margin',0.01,'FontName',font_name,'FontSize',11)

grid(gca,'on')

print(hf_1,'-dpdf','Template_example_simpler')

clear l fig_text
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