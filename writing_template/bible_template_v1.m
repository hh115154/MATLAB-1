% template for writing
% 
% v1: Seungjin Baek 3/10/2015
clear all; close all

orientation = 'portrait';
PaperH = 11;
PaperW = 8.5;
fig_position = [0.1 0.5 PaperW PaperH];

paper_position = [0 0 PaperW PaperH];

hf_1 = figure('Tag','cbec figure',...
    'Color','w', ...
    'PaperType','usletter', ...
    'PaperUnits','inches', ...
    'PaperPosition',paper_position, ...
    'Units','inches','Position',fig_position, ...
    'PaperOrientation',orientation);

axes1 = axes('Parent',hf_1,...
    'Tag','FigureBox',...
    'Visible','off','units','inches','Position',[0 0 PaperW PaperH]);

%% Lines
line_width1 = 0.1;
line_width_v = [2 2 .1 .1];

Lmargin = 0.5; Rmargin = Lmargin;
Tmargin = 0.75; Bmargin = 0.75;
dx = 0.25;

% Horizontal lines

box_height = (PaperH-Tmargin)-(Bmargin);
dy = box_height/30;
linesHeight = 0;
j = 1;

num_Lines = 35;
Pos_Y_line = zeros(35,1);
while box_height-linesHeight >= dy

    Lx = [Lmargin PaperW-Rmargin]./PaperW;
    Ly = [Bmargin+dy*j Bmargin+dy*j]./PaperH;
    linesHeight = dy*j;
    Pos_Y_line(j) = Ly(1)*PaperH;
    
    j = j+1;
    %line(Lx,Ly,'Parent',axes1,'LineWidth',2.5,'Color','k')
    
end


% Some grey areas
Pos_Y_line = Pos_Y_line(Pos_Y_line ~=0);

p_greyTOP = patch([1 1 7.5 7.5]./PaperW, ...
    [PaperH-Tmargin Pos_Y_line(end) Pos_Y_line(end) PaperH-Tmargin]./PaperH,[.7 .7 .7]);
set(p_greyTOP,'edgecolor','none')

p_greyLeft = patch([Lmargin+dx Lmargin+dx Lmargin+dx*2 Lmargin+dx*2]./PaperW, ...
    [PaperH-Tmargin-dy Pos_Y_line(1)-dy Pos_Y_line(1)-dy PaperH-Tmargin-dy]./PaperH,[.7 .7 .7]);
set(p_greyLeft,'edgecolor','none')

p_greyRight = patch([PaperW-Rmargin-dx*2 PaperW-Rmargin-dx*2 PaperW-Rmargin-dx PaperW-Rmargin-dx]./PaperW, ...
    [PaperH-Tmargin-dy Pos_Y_line(1)-dy Pos_Y_line(1)-dy PaperH-Tmargin-dy]./PaperH,[.7 .7 .7]);
set(p_greyRight,'edgecolor','none')


% Outer box

XData1=[Lmargin PaperW-Rmargin PaperW-Rmargin Lmargin Lmargin]./PaperW; 
YData1=[Bmargin Bmargin PaperH-Tmargin PaperH-Tmargin Bmargin]./PaperH;  % inches

line(XData1,YData1,'Parent',axes1,'Tag','Border','LineWidth',line_width1,'Color','k');
set(axes1,'ylim',[0 1]);
set(axes1,'xlim',[0 1]);

% Vertical lines LEFT
for i = 1:4
    Vx1 = [Lmargin + dx*i Lmargin + dx*i]./PaperW;
    Vy1 = [Bmargin PaperH-Tmargin]./PaperH;
    line(Vx1,Vy1,'Parent',axes1,'LineWidth',line_width_v(i),'Color','k')
    clear Vx1 Vy1
end

% Vertical lines Right
dx = 0.25;
for i = 1:2
    Vx2 = [PaperW-Lmargin-dx*i  PaperW-Lmargin-dx*i]./PaperW;
    Vy2 = [Bmargin PaperH-Tmargin]./PaperH;
    line(Vx2,Vy2,'Parent',axes1,'LineWidth',line_width_v(i),'Color','k')
    clear Vx2 Vy2
end

% Horizontal lines

box_height = (PaperH-Tmargin)-(Bmargin);
dy = box_height/30;
linesHeight = 0;
j = 1;

% num_Lines = 35;
Pos_Y_line = zeros(35,1);
while box_height-linesHeight >= dy

    Lx = [Lmargin PaperW-Rmargin]./PaperW;
    Ly = [Bmargin+dy*j Bmargin+dy*j]./PaperH;
    linesHeight = dy*j;
    Pos_Y_line(j) = Ly(1)*PaperH;
    
    j = j+1;
    line(Lx,Ly,'Parent',axes1,'LineWidth',2.5,'Color','k')
    
end

%% Some texts

text(0.5,dy*1.5/PaperH,sprintf('version: %s',datestr(now,'mm-dd-yyyy HH:MM')),'horizontalalignment','center')

%% print the page
print(hf_1,'-dpdf','-r300','test_1')
