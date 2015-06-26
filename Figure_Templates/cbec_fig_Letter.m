function [h_fig,h_axes]=cbec_fig_Letter(orientation,fig_text,subplots)
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
    case 'tall'
        fig_position = [20 50 800 1000];
    case 'landscape'
%         fig_position = [20 400 800 620];
%         fig_position = [20 50 1000 775];
        PaperW = 11;
        PaperH = 8.5;
        fig_position = [0.1 0.5 PaperW PaperH];
        
        paper_position = [0 0 PaperW PaperH]; % controls paper margin
end

% paramters
logo_file='cbec_logo_small.jpg';
x_vert_bar=0.5; % x location of vertical bar dividing main caption box
x_vert_offset = 0.05;

max_line_len=60;
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
h_fig = figure('Tag','cbec figure',...
    'Color','w', ...
    'PaperType','usletter', ...
    'PaperUnits','inches', ...
    'PaperPosition',paper_position, ...
    'Units','inches','Position',fig_position, ...
    'PaperOrientation',orientation);
% orient(h_fig,orientation)

% Create primary axes
% axes1 = axes('Parent',h_fig,...
%     'Tag','FigureBox',...
%     'Visible','off','Position',[0 0 1 1],'units','normalized');
axes1 = axes('Parent',h_fig,...
    'Tag','FigureBox',...
    'Visible','off','units','inches','Position',[0 0 PaperW PaperH]);

% % Create border
% XData1=[0.05 0.95 0.95 0.05 0.05]; YData1=[0.05 0.05 0.95 0.95 0.05];
% line(XData1,YData1,'Parent',axes1,'Tag','Border','LineWidth',line_width,'Color','k');

% XData1=[0.0455 0.9545 0.9545 0.0455 0.0455]; YData1=[0.1029 0.1029 0.8824 0.8824 0.1029];  % inches
% line(XData1,YData1,'Parent',axes1,'Tag','Border','LineWidth',line_width,'Color','k');

Yoffset = 0.04;  % final adjustment
XData1=[0.5 PaperW-0.5 PaperW-0.5 0.5 0.5]./PaperW; YData1=[7/8-Yoffset 7/8-Yoffset PaperH-1 PaperH-1 7/8-Yoffset]./PaperH;  % inches
line(XData1,YData1,'Parent',axes1,'Tag','Border','LineWidth',line_width,'Color','k');
set(axes1,'ylim',[0 1]);
set(axes1,'xlim',[0 1]);

% Create figure caption boxes
XData2=[0.5 PaperW-0.5]./PaperW; YData2=[0.65+7/8-Yoffset 0.65+7/8-Yoffset]./PaperH;
line(XData2,YData2,'Parent',axes1,'Tag','Border','LineWidth',line_width,'Color','k');

XLogoLeft=[0.5+4.43 0.5+4.43]./PaperW; YLogo =[7/8-Yoffset 7/8-Yoffset+0.65]./PaperH;
line(XLogoLeft,YLogo,'Parent',axes1,'Tag','Border','LineWidth',line_width,'Color','k');

XLogoRight=[0.5+4.43+1.25 0.5+4.43+1.25]./PaperW; 
line(XLogoRight,YLogo,'Parent',axes1,'Tag','Border','LineWidth',line_width,'Color','k');

XData4=[0.5+4.43+1.25 PaperW-0.5]./PaperW; YData4=[7/8-Yoffset+0.24 7/8-Yoffset+0.24]./PaperH;
line(XData4,YData4,'Parent',axes1,'Tag','Border','LineWidth',line_width,'Color','k');

% XData5=[x_vert_bar+x_vert_offset 0.95]; YData5=[0.15 0.15];
% line(XData5,YData5,'Parent',axes1,'Tag','Border','LineWidth',line_width,'Color','k');

XData6=[0.5+4.43+1.25+1.52 0.5+4.43+1.25+1.52]./PaperW; YData6 = [7/8-Yoffset 7/8-Yoffset+0.24]./PaperH;   % vertical lower right
line(XData6,YData6,'Parent',axes1,'Tag','Border','LineWidth',line_width,'Color','k');

XData7=[PaperW-0.5-1.44 PaperW-0.5-1.44]./PaperW;    % vertical lower right
line(XData7,YData6,'Parent',axes1,'Tag','Border','LineWidth',line_width,'Color','k');

% Create source text
if isempty(fig_text.source)
    source_text = [];
else
    source_text = ['Notes:  ' fig_text.source];
    
end
h_text=text('Parent',axes1,'Tag','SourceText','Units','normalized',...
    'Position',[0.05 0.166],...
    'String',{source_text},...
    'HorizontalAlignment','left',...
    'FontName',font_name,'FontSize',9);

% this_text=['\itSource:\rm  ' fig_text.source];
this_text=fig_text.source;
if length(this_text)>max_line_len     % break text into shorter lines
    remain=this_text;
    line_cnt=0;
    while length(remain)>max_line_len
        line_cnt=line_cnt+1;
        ind_space=strfind(remain,' ');
        ind_break=find(ind_space<=max_line_len,1,'last');
        line_text{line_cnt}=remain(1:(ind_space(ind_break)-1));
        remain=strtrim(remain(ind_space(ind_break):end));
    end
    if ~isempty(remain)
        line_cnt=line_cnt+1;
        line_text{line_cnt}=remain;
    end

    % write Source label to figure
    set(h_text,'String','Note: ')
    drawnow % workaround for text extent bug

    % find extent to start writing additional lines
    text_ext=get(h_text,'extent');
    text_start=text_ext(1)+text_ext(3);

    h_figbox=findobj(gcf,'Tag','FigureBox');

    for nl=1:line_cnt
        text('Parent',h_figbox,'Tag',['SourceTextLine' num2str(nl)],...
            'Units','normalized',...
            'Position',[text_start 0.166-(nl-1)*line_height],...
            'String',{line_text{nl}},...
            'HorizontalAlignment','left',...
            'FontName',font_name,'FontSize',9);
    end
end

% Create figure number text
text('Parent',axes1,'Tag','FigureNumber','Units','normalized',...
    'Position',[0.9484 0.115],...
    'String',{['Figure ' fig_text.fig_number]},...
    'HorizontalAlignment','right',...
    'FontName',font_name,'FontWeight','bold','FontSize',14);

% Create project title
text('Parent',axes1,'Tag','ProjectTitle','Units','normalized',...
    'Position',[0.9484 0.1661],...
    'String',{fig_text.proj_title},...
    'FontAngle','italic',...
    'HorizontalAlignment','right',...
    'FontName',font_name,'FontSize',10);

% Create figure description
fontsize=14;
while 1
    clear h_text
    h_text=text('Parent',axes1,'Tag','FigureDescription','Units','normalized',...
        'Position',[0.9484 0.144],...
        'String',{fig_text.description},...
        'HorizontalAlignment','right',...
        'FontName',font_name,'FontWeight','bold','FontSize',fontsize);
    drawnow % workaround for text extent bug

    extent=get(h_text,'Extent');
    if extent(1)>=(x_vert_bar+x_vert_offset+0.02), break, end

    if fontsize==8
        warning(['Figure description font size at minimum of 8.  ' ...
            'Try changing X_VERT_BAR'])
        break
    end
        
    delete(h_text)
    fontsize=fontsize-1;
end

% disp('start proj num')

% Create project number
text('Parent',axes1,'Tag','ProjectNumber','Units','normalized',...
    'Position',[0.633 0.113],...
    'String',{['Project No. ' fig_text.proj_number]},...
    'HorizontalAlignment','center',...
    'FontName',font_name,'FontSize',9);

% Create creator initial
text('Parent',axes1,'Tag','ProjectNumber','Units','normalized',...
    'Position',[0.7647 0.113],...
    'String',{['Created By: ' fig_text.created_by]},...
    'HorizontalAlignment','center',...
    'FontName',font_name,'FontSize',9);

% Insert PWA logo
if exist(logo_file)
    logo=imread(logo_file,'jpeg');
%     x_lim=[x_vert_bar-x_vert_offset+.005 x_vert_bar+x_vert_offset-.005]; dx=(x_lim(2)-x_lim(1))/(size(logo,2)-1);
%     x_data=x_lim(1):dx:x_lim(2);
%     y_lim=[0.06 0.13]; dy=(y_lim(2)-y_lim(1))/(size(logo,1)-1);
%     y_data=y_lim(1):dy:y_lim(2);
%     
    x_lim = [XLogoLeft(1)+0.005 XLogoRight(1)-0.005];
    dx=(x_lim(2)-x_lim(1))/(size(logo,2)-1);
    x_data=x_lim(1):dx:x_lim(2);
    
    y_lim = [YLogo(1)+0.005 YLogo(2)-0.005];
    dy = (y_lim(2)-y_lim(1))/(size(logo,1)-1);
    y_data=y_lim(1):dy:y_lim(2);
    
    image('Parent',axes1,'CData',flipdim(logo,1),'XData',x_data,'YData',y_data);
else
    warning(['Cannot find cbec logo file: ' logo_file])
end

% Add mfile's path at bottom of figure
mfile_stack=dbstack('-completenames');
% text('Parent',axes1,'Tag','FilePath','Units','normalized',...
%     'Position',[0.07 0.03],...
%     'String',{mfile_stack(end).file},...
%     'FontName','times','Fontsize',8,'Interpreter','none')

% Create plotting axes
% if length(subplots)==2 % specified subplot matrix
%     cnt_subplot=0;
%     h_axes=[];
%     for r=1:subplots(1)
%         for c=1:subplots(2)
%             cnt_subplot=cnt_subplot+1;
%             h_axes=[subplot(r,c,cnt_subplot); h_axes];
%         end
%     end
if size(subplots,2)==4 % specified subplot positions
    h_axes=[];
    for s=1:size(subplots,1)
        h_axes=[axes('position',subplots(s,:)); h_axes];
    end
else % default to single axes
    %     h_axes=axes('Parent',h_fig,'Tag','PlotAxes1','Position',[0.15 0.27 0.75 0.63]);
    h_axes=axes('Parent',h_fig,'Tag','PlotAxes1','Position', ...
        [XData1(1)+0.06 YData1(1)+0.15 0.8 0.55],'FontName',font_name,'FontSize',11);
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