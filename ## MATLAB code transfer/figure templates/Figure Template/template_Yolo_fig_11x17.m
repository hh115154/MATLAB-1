function [h_fig,h_axes]=template_Yolo_fig_11x17(orientation,fig_text,subplots)
%CBEC_FIG Creates a PWA figure box and returns figure & axes handles. No file path will be specified
%
%   [H_FIG,H_AXES]=CBEC_FIG_NOPATH(ORIENTATION,FIG_TEXT,SUBPLOTS)
%  
%   (default values in {}) 
% 
%   Input: (all are optional)
%   ORIENTATION - {'landscape'} | 'portrait' | 'tall' | 'rotated' 
%               as per MatLab's orient.m
%
%   FIG_TEXT - structure of figure's text with following fields:
%            source {''}, fig_number {'X'}, proj_title' {'Project Title'},
%            description {'Consise figure description'}, and proj_number {'XXXX.X'}
% 
%   SUBPLOTS - {single axes}
%            M x 4 matrix where rows are [left bottom width height] position vector
%            for the new axes in the figure's normalized units
%
%   Output:
% 
%   H_FIG - handle to new figure
% 
%   H_AXES - handle(s) to axes in figure

%   S. Baek - 4/22/12
%   S. Baek - 7/18/13

% As necessary, set default inputs
switch nargin
    case 0
        orientation='landscape'; fig_text=[]; subplots=[];
    case 1
        fig_text=[]; subplots=[];
    case 2
        subplots=[];
end


switch orientation
    case 'portrait'
        PaperW = 14.5;
        PaperH = 10;
        
        fig_position = [0 1 PaperH PaperW];
        paper_position = [0 0 PaperH PaperW]; % controls paper margin
    case 'landscape'
        PaperW = 15.5;
        PaperH = 9;
        %         fig_position = [20 400 800 620];
        %         fig_position = [20 50 1000 775];
        fig_position = [0 1 PaperW PaperH];
        
        paper_position = [0 0 PaperW PaperH]; % controls paper margin
end

% paramters
logo_file='cbec_logo_small.jpg';
x_vert_bar=0.5; % x location of vertical bar dividing main caption box
x_vert_offset = 0.05;

max_line_len=180;
line_height=0.015;
line_width = 0.5;
% font_name = 'Calibri';
font_name = 'Helvetica';

% Check fig_text input structure
fig_text=check_fig_text(fig_text);

% Save existing default PaperOrientation and set to factory default
% current_PaperOrient=get(0,'DefaultFigurePaperOrientation');
% set(0,'DefaultFigurePaperOrientation',get(0,'FactoryFigurePaperOrientation'))

% Create figure
% h_fig = figure('Tag','cbec figure',...
%     'Color','w', ...
%     'PaperType','usletter', ...
%     'PaperUnits','inches', ...
%     'PaperPosition',paper_position, ...
%     'Units','inches','Position',fig_position, ...
%     'PaperOrientation',orientation);

h_fig = figure('Tag','cbec figure',...
    'Color','w', ...
    'Units','inches','Position',fig_position, ...
    'PaperOrientation',orientation);

% orient(h_fig,orientation)

% Create primary axes
% axes1 = axes('Parent',h_fig,...
%     'Tag','FigureBox',...
%     'Visible','off','Position',[0 0 1 1],'units','normalized');

% axes1 = axes('Parent',h_fig,...
%     'Tag','FigureBox',...
%     'Visible','off','units','inches','Position',[0 0 PaperW PaperH]);
axes1 = axes('Parent',h_fig,...
    'Tag','FigureBox',...
    'Visible','off','units','normalized','Position',[0 0 1 1]);

% % Create border
% XData1=[0.05 0.95 0.95 0.05 0.05]; YData1=[0.05 0.05 0.95 0.95 0.05];
% line(XData1,YData1,'Parent',axes1,'Tag','Border','LineWidth',line_width,'Color','k');

% XData1=[0.0455 0.9545 0.9545 0.0455 0.0455]; YData1=[0.1029 0.1029 0.8824 0.8824 0.1029];  % inches
% line(XData1,YData1,'Parent',axes1,'Tag','Border','LineWidth',line_width,'Color','k');

Yoffset = 0.03;  % final adjustment
xmarginL = 1; xmarginR = 0.5;
ymarginB = 0.85; ymarginT = 0.5;
TextMargin = 0.002;
TextMarginx = 0.008;
% Outer border
FigBox_XData1=[xmarginL PaperW-xmarginR PaperW-xmarginR xmarginL xmarginL]./PaperW; 
FigBox_YData1=[ymarginB-Yoffset ymarginB-Yoffset PaperH-ymarginT PaperH-ymarginT ymarginB-Yoffset]./PaperH;  % inches
% line(FigBox_XData1,FigBox_YData1,'Parent',axes1,'Tag','Border','LineWidth',line_width,'Color','k');
set(axes1,'ylim',[0 1]);
set(axes1,'xlim',[0 1]);


if size(subplots,2)==4 % specified subplot positions
    h_axes=[];
    for s=1:size(subplots,1)
        h_axes=[axes('position',subplots(s,:)); h_axes];
    end
else % default to single axes
    %     h_axes=axes('Parent',h_fig,'Tag','PlotAxes1','Position',[0.15 0.27 0.75 0.63]);
%     h_axes=axes('Parent',h_fig,'Tag','PlotAxes1','Position', ...
%         [XData1(1)+0.06 YData1(1)+0.15 0.83 0.7]);
%     axes_width = 0.89;
%     axes_height = 0.85;
%     axes_marginE = 0.04;
%     axes_marginS = 0.12;

    axes_width = 0.89;
    axes_height = 0.85;
    axes_marginE = 0.04;
    axes_marginS = 0.06;
    
    
    h_axes=axes('Parent',h_fig,'Tag','PlotAxes1','Position', ...
        [FigBox_XData1(1)+axes_marginE FigBox_YData1(1)+axes_marginS axes_width-axes_marginE axes_height-axes_marginS], ...
        'FontName',font_name,'FontSize',11);
end

figure(h_fig)

if nargout==0, clear h_fig h_axes, end

% Reset default figure PaperOrientation to existing
% set(0,'DefaultFigurePaperOrientation',current_PaperOrient)

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fig_text=check_fig_text(fig_text)

fig_text_fields={
    'source','';
    'fig_number','X-X';...
    'proj_title','Project Title';...
    'description','Figure Title';
    'proj_number','0X-1XXX';
    'created_by','XXX'};

for f=1:length(fig_text_fields)
    if ~isfield(fig_text,fig_text_fields{f,1})
        eval(['fig_text.' fig_text_fields{f,1} '=fig_text_fields{f,2};'])
    end
end

if ~ischar(fig_text.fig_number)
    fig_text.fig_number=num2str(fig_text.fig_number);
end

if ~ischar(fig_text.proj_number)
    fig_text.proj_number=num2str(fig_text.proj_number);
end

return