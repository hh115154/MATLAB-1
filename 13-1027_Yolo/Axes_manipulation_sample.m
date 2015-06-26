figure 
lw = 2; 
x=0:5:10; 
plot(x,x) 
a1 = gca; 
set(a1,'box','off','tickdir','out','xticklabel',{},'yticklabel',{},... 
    'linewidth',lw,'Xtick',[0:5:10],'ytick',[0:5:10]) 
axis square 
a2 = copyobj(a1,gcf); 
set(a2,'color','none','xaxislocation','top','yaxislocation','right','xtick',[],'ytick',[])