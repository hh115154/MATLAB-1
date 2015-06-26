function [h_fig,h_axes]=cbec_fig_v2(orientation,fig_text,subplots)
% PWA_FIG Creates a PWA figure box and returns figure & axes handles
%
% [H_FIG,H_AXES]=PWA_FIG(ORIENTATION,FIG_TEXT,SUBPLOTS)
%  
%  (default values in {} 
% 
% Input: (all are optional)
% ORIENTATION - {'landscape'} | 'portrait' | 'tall' | 'rotated' 
%               as per MatLab's orient.m
%
% FIG_TEXT - structure of figure's text with following fields:
%            source {''}, fig_number {'X'}, proj_title' {'Project Title'},
%            description {'Consise figure description'}, and proj_number {'XXXX.X'}
% 
% SUBPLOTS - {single axes}
%            M x 4 matrix where rows are [left bottom width height] position vector
%            for the new axes in the figure's normalized units
%
% Output:
% 
% H_FIG - handle to new figure
% 
% H_AXES - handle(s) to axes in figure

% M. Brennan - 23Mar07

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
        fig_position = [200 50 800 1000];
    case 'landscape'
        fig_position = [200 400 800 620];
end

% paramters
logo_file='cbec_logo_tiny.jpg';
x_vert_bar=0.5; % x location of vertical bar dividing main caption box
max_line_len=60;
line_height=0.015;

% Check fig_text input structure
fig_text=check_fig_text(fig_text);

% Save existing default PaperOrientation and set to factory default
% current_PaperOrient=get(0,'DefaultFigurePaperOrientation');
% set(0,'DefaultFigurePaperOrientation',get(0,'FactoryFigurePaperOrientation'))

% Create figure
h_fig = figure('Tag','PWA figure',...
    'PaperType','usletter','PaperUnits','inches','position',fig_position);

orient(h_fig,orientation)

% Create primary axes
axes1 = axes('Parent',h_fig,...
    'Tag','FigureBox',...
    'Visible','off','Position',[0 0 1 1],'units','normalized');

% Create border
XData1=[0.05 0.95 0.95 0.05 0.05]; YData1=[0.05 0.05 0.95 0.95 0.05];
line(XData1,YData1,'Parent',axes1,'Tag','Border','LineWidth',1.5,'Color','k');

% Create figure caption boxes
XData2=[0.05 0.95]; YData2=[0.2 0.2];
line(XData2,YData2,'Parent',axes1,'Tag','Border','LineWidth',1.5,'Color','k');

XData3=[x_vert_bar x_vert_bar]; YData3=[0.05 0.2];
line(XData3,YData3,'Parent',axes1,'Tag','Border','LineWidth',1.5,'Color','k');

XData4=[x_vert_bar 0.95]; YData4=[0.1 0.1];
line(XData4,YData4,'Parent',axes1,'Tag','Border','LineWidth',1.5,'Color','k');

XData5=[x_vert_bar 0.95]; YData5=[0.15 0.15];
line(XData5,YData5,'Parent',axes1,'Tag','Border','LineWidth',1.5,'Color','k');

XData6=[0.8 0.8]; YData6=[0.05 0.1];
line(XData6,YData6,'Parent',axes1,'Tag','Border','LineWidth',1.5,'Color','k');

% Create source text
h_text=text('Parent',axes1,'Tag','SourceText','Units','normalized',...
    'Position',[0.07 0.18],...
    'String',{['\itSource:\rm  ' fig_text.source]},...
    'HorizontalAlignment','left',...
    'FontName','times','FontSize',10);

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
    set(h_text,'String','\itSource:\rm ')
    drawnow % workaround for text extent bug

    % find extent to start writing additional lines
    text_ext=get(h_text,'extent');
    text_start=text_ext(1)+text_ext(3);

    h_figbox=findobj(gcf,'Tag','FigureBox');

    for nl=1:line_cnt
        text('Parent',h_figbox,'Tag',['SourceTextLine' num2str(nl)],...
            'Units','normalized',...
            'Position',[text_start 0.18-(nl-1)*line_height],...
            'String',{line_text{nl}},...
            'HorizontalAlignment','left',...
            'FontName','times','FontSize',8);
    end
end

% Create figure number text
text('Parent',axes1,'Tag','FigureNumber','Units','normalized',...
    'Position',[0.93 0.185],...
    'String',{['\fontsize{9}Figure \fontsize{14} ' fig_text.fig_number]},...
    'FontAngle','italic',...
    'HorizontalAlignment','right',...
    'FontName','times');

% Create project title
text('Parent',axes1,'Tag','ProjectTitle','Units','normalized',...
    'Position',[0.93 0.165],...
    'String',{fig_text.proj_title},...
    'FontAngle','italic',...
    'HorizontalAlignment','right',...
    'FontName','times','FontSize',10);

% Create figure description
fontsize=12;
while 1
    clear h_text
    h_text=text('Parent',axes1,'Tag','FigureDescription','Units','normalized',...
        'Position',[0.93 0.13],...
        'String',{fig_text.description},...
        'HorizontalAlignment','right',...
        'FontName','times','FontSize',fontsize);
    drawnow % workaround for text extent bug

    extent=get(h_text,'Extent');
    if extent(1)>=(x_vert_bar+0.02), break, end

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
    'Position',[(x_vert_bar+0.02) 0.07],...
    'String',{['PWA Ref# ' fig_text.proj_number]},...
    'HorizontalAlignment','left',...
    'FontName','times','FontSize',8);

% Insert PWA logo
if exist(logo_file)
    logo=imread(logo_file,'jpeg');
    x_lim=[0.82 0.93]; dx=(x_lim(2)-x_lim(1))/(size(logo,2)-1);
    x_data=x_lim(1):dx:x_lim(2);
    y_lim=[0.06 0.09]; dy=(y_lim(2)-y_lim(1))/(size(logo,1)-1);
    y_data=y_lim(1):dy:y_lim(2);
    image('Parent',axes1,'CData',flipdim(logo,1),'XData',x_data,'YData',y_data);
else
    warning(['Cannot find PWA logo file: ' logo_file])
end

% Add mfile's path at bottom of figure
mfile_stack=dbstack('-completenames');
text('Parent',axes1,'Tag','FilePath','Units','normalized',...
    'Position',[0.07 0.03],...
    'String',{mfile_stack(end).file},...
    'FontName','times','Fontsize',8,'Interpreter','none')

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
    h_axes=axes('Parent',h_fig,'Tag','PlotAxes1','Position',[0.15 0.27 0.75 0.63]);
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
    'fig_number','X';...
    'proj_title','Project Title';...
    'description','Consise figure description';
    'proj_number','XXXX.X'};

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