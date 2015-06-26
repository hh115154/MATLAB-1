function [h_fig,h_axes]=cbec_fig_NO_text(paper_type,orientation,subplots)
%CBEC_FIG Creates a cbec figure box and returns figure & axes handles. No file path will be specified
%
%  -----------------------------------------------------------------------
%   This template produce figures WITHOUT text box and box; only figures
%   for MS WORD template - user must paste the figure manually later.
%  -----------------------------------------------------------------------
%
%   Output:
% 
%   H_FIG - handle to new figure
% 
%   H_AXES - handle(s) to axes in figure

%   S. Baek - 4/22/12, 5/1/14

% As necessary, set default inputs
switch nargin
    case 0
        paper_type = 'Letter';
        orientation='portrait'; subplots=[];
    case 1
        orientation='portrait'; subplots=[];
    case 2
        subplots=[];
end


switch orientation
    case 'portrait'
        
        switch paper_type
            case 'Legal'
                PaperH = 14.5;
                PaperW = 10;
                fig_on_screen = [10 100 800 1200];
            case 'Letter'
                PaperH = 9;
                PaperW = 7;
                fig_on_screen = [10 100 600 800];
        end
    case 'landscape'
        switch paper_type
            case 'Legal'
                PaperW = 15.5;
                PaperH = 9;
                fig_on_screen = [10 100 1200 800];
            case 'Letter'
                PaperW = 10;
                PaperH = 6;
                fig_on_screen = [10 100 800 600];
        end
        
%         PaperW = 15.5;
%         PaperH = 9;
        %         fig_position = [20 400 800 620];
        %         fig_position = [20 50 1000 775];
end

bot_margin = 0.5;
top_margin = 0.25;
rht_margin = 0.25;
lft_margin = 0.5;

% fig_position = [lft_margin bot_margin PaperW-lft_margin-rht_margin PaperH-top_margin-bot_margin];
fig_position = [0 0 PaperW PaperH];
paper_position = [.5 0 PaperW PaperH]; % controls paper margin


% paramters
% logo_file='cbec_logo_small.jpg';
% x_vert_bar=0.5; % x location of vertical bar dividing main caption box
% x_vert_offset = 0.05;

% max_line_len=60;
% line_height=0.015;
% line_width = 0.5;
% font_name = 'Calibri';
font_name = 'Helvetica';

% Check fig_text input structure
% fig_text=check_fig_text(fig_text);

% Save existing default PaperOrientation and set to factory default
% current_PaperOrient=get(0,'DefaultFigurePaperOrientation');
% set(0,'DefaultFigurePaperOrientation',get(0,'FactoryFigurePaperOrientation'))

% Create figure
h_fig = figure('Color','w','position',fig_on_screen);   % this is size in screen
set(h_fig,'PaperUnits','inches','PaperSize',[PaperW PaperH], ...
    'PaperPosition',fig_position);%, ...
    %'PaperOrientation',orientation);
% orient(h_fig,orientation)

% Create primary axes
axes1 = axes('Parent',h_fig,...
    'Tag','FigureBox',...
    'Visible','off','Position',[0 0 1 1],'units','normalized');

% axes1 = axes('Parent',h_fig,'Visible','off','units','normalized', ...
%          'Position',[lft_ax bot_ax ax_width0 ax_height0]);

% axes1 = axes('Parent',h_fig,...
%     'Tag','FigureBox',...
%     'Visible','off','units','inches','Position',[0 0 PaperW PaperH]);



















if size(subplots,2)==4 % specified subplot positions
    h_axes=[];
    for s=1:size(subplots,1)
        h_axes=[axes('position',subplots(s,:)); h_axes];
    end
else % default to single axes
    %     h_axes=axes('Parent',h_fig,'Tag','PlotAxes1','Position',[0.15 0.27 0.75 0.63]);
    % h_axes=axes('Parent',h_fig,'Tag','PlotAxes1','Position', ...
    %   [XData1(1)+0.06 YData1(1)+0.15 0.8 0.55],'FontName',font_name,'FontSize',11);
    h_axes=axes('Parent',h_fig,'Tag','PlotAxes1','Position', ...
        [0.05 0.08 0.92 0.89],'FontName',font_name,'FontSize',11);
end

figure(h_fig)

if nargout==0, clear h_fig h_axes, end

% Reset default figure PaperOrientation to existing
% set(0,'DefaultFigurePaperOrientation',current_PaperOrient)

return

