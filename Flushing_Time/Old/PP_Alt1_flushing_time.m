% Post Processing
% Estimate flushing time for Alt1 simulation
% Start from Network 1

clear all
close all
tic
%% read configuration file
fic = fopen('PP_Alt1_flushing_time.cfg'); fgetl(fic);

shp_path = fgetl(fic); fgetl(fic);
shp_name = fgetl(fic); fgetl(fic);
NWK_num = str2double(fgetl(fic)); fgetl(fic);  % Network area

dfsu_path = fgetl(fic); fgetl(fic);
% dfsu_name = fgetl(fic); fgetl(fic);
% IC_start_no_use = str2double(fgetl(fic)); fgetl(fic);

% sort out dfsu only
cd(dfsu_path)
F = dir('*.dfsu');
for i = 1:length(F)
    idic = regexp(F(i).name,'[0-9]');
    dt = str2double(F(i).name(idic));
    tr_time(i) = dt./120;  % translate to dfsu time steps (120: hardwired)
end
mesh_path = fgetl(fic); fgetl(fic);
mesh_name = fgetl(fic); fgetl(fic);
tracer_path =  fgetl(fic);

fclose(fic); % done reading configuration file

line_color= {'.-','r.-','g.-','c.-','m.-'};
%% FOR loop sequence: Files (seven) - Network (five) - time series (240)
for j = 1:length(F)   % loop through different starting times
% j = 4; % for the 1st file
% ii = 1;   % Network 1
dfsu = dfsManager(fullfile(dfsu_path,F(j).name));
get(dfsu,'NumtimeSteps')
[x,y,z] = readElmts(dfsu); % z = bathy elevation
tracer_size = (get(dfsu,'NumtimeSteps')-1) - tr_time(j) + 1; % total size of tracer time series
AvgC = zeros(5,tracer_size);
for ii = 1:5     % loop through Networks 1~5
    
    % read shp file
    S = shaperead(fullfile(shp_path,shp_name));
    in = inpolygon(x,y,S(ii).X(1:end-1),S(ii).Y(1:end-1));
    
    % compute wet cells
    kk = 1;   % time series index
    for k = tr_time(j):get(dfsu,'NumtimeSteps')-1   % loop through time steps
        %     k = 13;
        % CALCULATE TRACER CONCENTRATION
        tracer = dfsu(ii,k);  % load all cells (ii: network, k: time step)
        delete_value = tracer(find(abs(tracer)<1e-34,1));
        
        wet_ind = find(tracer ~= delete_value); % index for wet cells
        wet_ind_inside = inpolygon(x(wet_ind),y(wet_ind),S(ii).X(1:end-1),S(ii).Y(1:end-1));
        
        % ----------------------  !!!!
        TR = tracer(wet_ind(wet_ind_inside)); % wet cells only INSIDE network polygon!
        % ----------------------  !!!!
        
        
        % Need to calculate area for each cell to compute area*concentration
        
        % CALCULATE AREA OF CELL
        tn = readElmtNodeConnectivity(dfsu);
        [xe,ye,~] = readElmts(dfsu);     % Element center coordinates
        [xn,yn,~] = readNodes(dfsu);     % Node coordinates
        
        % find the connecton between xe and xn for the wet cells....
        % 1) identify index for wet cells (done)
        % 2) find xn (node coordinates) for wet cell index
        %   -> TN = tn(wet_ind(wet_ind_inside),:);
        %   -> xn(TN) indicates node coordinates for wet cells
        %   -> use this coordinates for area calculation
        %
        % 3) calculate area
        % 4) area*concentration for each cell
        
        aidx = tn(wet_ind(wet_ind_inside),:);
        
        Area = fun_calculate_cell_area(xn,yn,aidx);
        
        Conc = TR.*Area;
        AvgC(ii,kk) = sum(Conc)/sum(Area);
        kk = kk + 1;
        
        fprintf(1,'File number: %d, Network %d, Time step (dfsu step): %d\n',j,ii,k)
    end
    plot(AvgC(ii,:),line_color{ii})
    hold on
    %     clear kk k
    print(1,'-dpng',sprintf('IC_%d_.png',tr_time(j)*120))
end
close(dfsu)
% end
%%
% figure(3), clf, shg
% hn = mzCalcNodeValues(tn,xn,yn,tracer,xe,ye);
% % subplot(2,2,3)
% H = mzPlot(tn,xn,yn,hn,tracer);
% % H = mzPlot(tn,xn,yn,hn,tracer);
% % set(H,'EdgeAlpha',0);   % remove element lines
% % title(sprintf('%s',items{1,1}));
% axis tight
% plot(AvgC(1,:),'.-')
% hold on
% plot(AvgC(2,:),'r.-')
% plot(AvgC(3,:),'g.-')
% plot(AvgC(4,:),'k.-')
% plot(AvgC(5,:),'c.-')
grid
legend('N1','N2','N3','N4','N5')
xlabel('hours')
ylabel('Concentration')
title(sprintf('tracer starts after %d hours',tr_time(j)))
sav_filename = sprintf('AD_%d.mat',tr_time(j)*120);
save(sav_filename,'AvgC')
end
end_time_sec = toc;
fprintf(1,'elapsed time: %.2f min\n',end_time_sec/60)