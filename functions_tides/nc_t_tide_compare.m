function varargout = t_tide_compare(ncmodel,ncdata,varargin)
%NC_T_TIDE_COMPARE   visualize comparison of nc_t_tide results
%
%   nc_t_tide_compare(ncmodel,ncdata,<keyword,value>)
%
% plots the results from a tidal analysis performed by
% NC_T_TIDE. ncmodel and ncdata are pairwise linked lists 
% of netCDF files (obtained with e.g. OPENDAP_CATALOG and sorted).
%
% See also: T_TIDE, NC_T_TIDE, OPENDAP_CATALOG

%% Copyright notice
%   --------------------------------------------------------------------
%   Copyright (C) 2007-2010 Delft University of Technology/Deltares
%       Gerben J. de Boer
%
%       g.j.deboer@tudelft.nl / gerben.deboer@deltares.nl	
%
%       Fluid Mechanics Section
%       Faculty of Civil Engineering and Geosciences
%       PO Box 5048
%       2600 GA Delft
%       The Netherlands
%
%   This library is free software: you can redistribute it and/or
%   modify it under the terms of the GNU Lesser General Public
%   License as published by the Free Software Foundation, either
%   version 2.1 of the License, or (at your option) any later version.
%
%   This library is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%   Lesser General Public License for more details.
%
%   You should have received a copy of the GNU Lesser General Public
%   License along with this library. If not, see <http://www.gnu.org/licenses/>.
%   --------------------------------------------------------------------

   OPT.export              = 0;
   OPT.directory           = pwd;
   OPT.axis                = [];
   OPT.vc                  = 'http://opendap.deltares.nl/thredds/dodsC/opendap/noaa/gshhs/gshhs_l.nc';

   OPT.plot.spectrum       = 1;
   OPT.plot.scatter        = 1;
   OPT.plot.planview       = 1;
   
   OPT.color.data          = [0 0 0];
   OPT.color.model         = [.4 .4 .4];
   OPT.fontsize            = 8;

   OPT.title.fontsize      = 15;
   OPT.axes.fontsize       = 8;
   OPT.verticalalignment   = 'top' ; %[ top | cap | {middle} | baseline | bottom ]
   OPT.horizontalalignment = 'left'; %[ {left} | center | right ]
   
   OPT.pause               = 0; % after each station/netCDF file
   OPT.names2label         = {'q1','o1','k1','eps2','mu2','n2','m2','l2','s2','mo3','mk3','mn4','m4','ms4','2mk5','2mn6','m6','2ms6'};%'k2',
   OPT.names2planview      = {'q1','o1','k1','eps2','mu2','n2','m2','l2','s2','mo3','mk3','mn4','m4','ms4','2mk5','2mn6','m6','2ms6'};%'k2',
   OPT.amp_min             = 0.01; %[0.005];
   OPT.ddatenumeps         = 1e-8;
  %OPT.verticaloffset      = [1 1 1 2 1 1 1 1 1 1 1 1]; % plots the text for the specified station at the #th line (1 = normal 1st line)
   OPT.eps                 = 10*eps;
   
   OPT = setProperty(OPT,varargin{:});
   
   if nargin==0
      varargout = {OPT};
      return
   end
   
%% Initialize

   FIG.spectrum = figure('name','spectrum');
   FIG.scatter  = figure('name','scatter');

   if OPT.plot.planview
      for icomp=1:length(OPT.names2planview)
      FIGS(icomp) = figure('name',['planview_',OPT.names2planview{icomp}]);
      end
   end

%% Station loop

   nfiles = length(ncmodel);
   for ifile=1:nfiles
   
   %% LOAD data

     [M,Ma] = nc2struct(ncmodel{ifile});% Load model    data
     [D,Da] = nc2struct(ncdata{ifile}); % Load observed data
     
     D.station_name = make1d(char(D.station_name))';
     D.station_id   = make1d(char(D.station_id  ))';
     
     if abs(M.longitude - D.longitude) > OPT.eps;error('lon coordinates of model and data do not match');end
     if abs(M.latitude  - D.latitude ) > OPT.eps;error('lat coordinates of model and data do not match');end

     D.title = [D.station_name,' (',...
                D.station_id  ,') [',...
                num2str(D.longitude),'\circ E, ',...
                num2str(D.latitude ),'\circ N]'];

   %% SCATTER plot

      if OPT.plot.scatter
      
         figure(FIG.scatter);clf
            
      %% SCATTER component loop
      
         for dcomp = 1:size  (D.amplitude,1);
             mcomp = strmatch(D.component_name(dcomp,:),...
                              M.component_name);
                             
            if ~isempty(mcomp)     
            
            if D.amplitude(dcomp) > OPT.amp_min;
         
               name = lower(deblank(D.component_name(dcomp,:)));
               tmp  = strmatch(name,OPT.names2label);
         
               subplot(1,2,1)
               loglog(D.amplitude  (dcomp),...
                      M.amplitude  (mcomp),'k+')
               hold on
               if ~isempty(tmp)
               plot(D.amplitude(dcomp),M.amplitude(mcomp),'ko')
         
               %% draw name at side where not 45 degree line is located
               loc = sign(D.amplitude(dcomp) - M.amplitude(mcomp));
               if loc < 0
               text(D.amplitude(dcomp),M.amplitude(mcomp),...
                    [name,'     '],'rotation',-45,'horizontalalignment','right')
               else
               text(D.amplitude(dcomp),M.amplitude(mcomp),...
                    ['     ',name],'rotation',-45)
               end
               end
	       
               subplot(1,2,2)
               plot(D.phase(dcomp),...
                    M.phase(mcomp),'k+')
               hold on
               if ~isempty(tmp)
               plot(D.phase(dcomp),M.phase(mcomp),'ko')
         
               %% draw name at side where not 45 degree line is located
               loc = sign(D.phase(dcomp) - M.phase(mcomp));
               if loc < 0
               text(D.phase(dcomp),M.phase(mcomp),...
                    [name,'     '],'rotation',-45,'horizontalalignment','right')
               else
               text(D.phase(dcomp),M.phase(mcomp),...
                    ['     ',name],'rotation',-45)
               end
               end
            end
            
            end
         
         end
         
      %% SCATTER lay-out

        subplot(1,2,1)
         xlims = [5e-3 1];
         ylims = [5e-3 1];
         plot(xlims,     ylims,'-k')
         plot(xlims,0.9.*ylims,'-k')
         plot(xlims,1.1.*ylims,'-k')
         
         axis equal
         grid on
         xlabel('data amplitude [m]')
         ylabel('model amplitude [m]')
         xlim(xlims)
         ylim(ylims)
         plot(xlims       ,ylims + 0.01,'-','color',[.5 .5 .5])
         plot(xlims       ,ylims       ,'-','color',[.5 .5 .5])
         plot(xlims + 0.01,ylims       ,'-','color',[.5 .5 .5])
         
         title(D.title)
         
        subplot(1,2,2)
         xlims = [0 360];
         ylims = [0 360];
         for ddeg = [0 -360 360]
         plot(xlims,ylims + 10 + ddeg,'-k')
         plot(xlims,ylims      + ddeg,'-k')
         plot(xlims,ylims - 10 + ddeg,'-k')
         plot(xlims,ylims + 20 + ddeg,'-k','color',[.5 .5 .5])
         plot(xlims,ylims      + ddeg,'-k','color',[.5 .5 .5])
         plot(xlims,ylims - 20 + ddeg,'-k','color',[.5 .5 .5])
         end
         axis equal
         grid on
         xlabel('data phase [deg]')
         ylabel('model phase [deg]')
         xlim(xlims)
         ylim(ylims)
         set(gca,'xtick',[0:90:360]);
         set(gca,'ytick',[0:90:360]);
         title([{datestr(udunits2datenum(M.period(  1),Ma.period.units),0),...
                 datestr(udunits2datenum(M.period(end),Ma.period.units),0)}])
         
        if OPT.export
         text(1,0,mktex('Created with t_tide (Pawlowicz et al, 2002) & OpenEarthTools <www.OpenEarth.eu>'),'rotation',90,'units','normalized','verticalalignment','top','fontsize',6)
         basename = [OPT.directory,filesep,'scatter',filesep,filename(ncmodel{ifile})];
         print2screensizeoverwrite([basename,'_scatter.png'])
        %print2screensizeeps      ([basename,'_scatter.eps'])
        end
         
        disp(['processed station file ',num2str(ifile,'%0.4d'),' of ',num2str(nfiles,'%0.4d')])

      end % OPT.plot.scatter

   %% SPECTRUM plot

      if OPT.plot.spectrum
      
         figure(FIG.spectrum);clf
         
         ncomp_plotted{1} = 0;
         ncomp_plotted{2} = 0;
         ncomp_plotted{4} = 0;
         ncomp_plotted{6} = 0;
         
      %% SPECTRUM component loop
         
         for dcomp = 1:size  (D.amplitude,1);
             mcomp = strmatch(D.component_name(dcomp,:),...
                              M.component_name);
                             
            if ~isempty(mcomp)     
            if D.amplitude(dcomp) > OPT.amp_min & ...
               M.amplitude(mcomp) > OPT.amp_min;

            %disp([D.component_name(dcomp,:) M.component_name(mcomp,:)])
            %disp(num2str([M.amplitude(mcomp) D.amplitude(dcomp)]))
            
         
               if (D.frequency(dcomp) > 0     & ...
                   D.frequency(dcomp) < 2/24) % 1
                  ncomp_plotted{1} = ncomp_plotted{1} + 1;
                  spaces           = repmat(' ',[1 ceil(ncomp_plotted{1}./2)]);
                  leftright        = odd(ncomp_plotted{1});
           elseif (D.frequency(dcomp) > 1/24  & ...
                   D.frequency(dcomp) < 3/24) % 2
                  ncomp_plotted{2} = ncomp_plotted{2} + 1;
                  spaces           = repmat(' ',[1 ceil(ncomp_plotted{2}./2)]);
                  leftright        = odd(ncomp_plotted{2});
           elseif (D.frequency(dcomp) > 3/24  & ...
                   D.frequency(dcomp) < 5/24) % 4
                  ncomp_plotted{4} = ncomp_plotted{4} + 1;
                  spaces           = repmat(' ',[1 ceil(ncomp_plotted{4}./2)]);
                  leftright        = odd(ncomp_plotted{4});
           elseif (D.frequency(dcomp) > 5/24  & ...
                   D.frequency(dcomp) < 7/24) % 6
                  ncomp_plotted{6} = ncomp_plotted{6} + 1;
                  spaces           = repmat(' ',[1 ceil(ncomp_plotted{6}./2)]);
                  leftright        = odd(ncomp_plotted{6});
               end                  

               name  = lower(deblank(D.component_name(dcomp,:)));
               index = strmatch(name,OPT.names2planview);
               
               if ~isempty(index)
               
               subplot(2,1,1)

            %% harmonic (incl. nodal)

               plot([M.frequency(mcomp)],...
                    [M.amplitude(mcomp)],'k.','markersize',8)
               hold on
               plot([M.frequency(mcomp)],...
                    [D.amplitude(dcomp)],'ko','markersize',6)
               plot([M.frequency(mcomp) M.frequency(mcomp)],...
                    [M.amplitude(mcomp) D.amplitude(dcomp)],'k-')
               if leftright
               text([M.frequency(mcomp)],...
                    [D.amplitude(dcomp)],[' ',spaces,name])
               else
               text([M.frequency(mcomp)],...
                    [D.amplitude(dcomp)],[name,spaces,' '],'horizontalalignment','right')
               end
               
               xlim([0 0.3]);
               ylim([5e-3 1]);

               subplot(2,1,2)
               plot([M.frequency(mcomp)],...
                    [M.phase(mcomp)],'k.','markersize',8)
               hold on
               plot([M.frequency(mcomp)],...
                    [D.phase(dcomp)],'ko','markersize',6)

               if leftright
               text([M.frequency(mcomp)],...
                    [D.phase(dcomp)],[' ',spaces,name])
               else
               text([M.frequency(mcomp)],...
                    [D.phase(dcomp)],[name,spaces,' '],'horizontalalignment','right')
               end
               
               difference = M.phase(mcomp)  - ...
                            D.phase(dcomp);
               
               xlim([0 0.3]);

               if (abs(difference) < 180)
               plot([ M.frequency(mcomp) M.frequency(mcomp)],[M.phase(mcomp) D.phase(dcomp)],'k-')
               else
               maximum = max([D.phase(dcomp) M.phase(mcomp)]);
               minimum = min([D.phase(dcomp) M.phase(mcomp)]);
               plot    ([ M.frequency(mcomp) M.frequency(mcomp)],[0       minimum],'k-')
               plot    ([ M.frequency(mcomp) M.frequency(mcomp)],[maximum 360    ],'k-')
               end
               
               end % index
               
            end
            end
         end      
         
      %% SPECTRUM lay-out

         subplot(2,1,1)
         title(D.title)

         xlim([.02 .27])
         set(gca,'xtick',[1 2 3 4 5 6]./24)
         set(gca,'xticklabel',{'1/24','1/12','1/8','1/6','5/24','1/4'})
         set(gca,'yscale','log')

         grid on
         ylabel(['Amplitude [',Da.amplitude.units ,']'],'Interpreter','none')

         legend('model','data')

         subplot(2,1,2)
         ylim([0 360])

         xlim([.02 .27])
         set(gca,'xtick',[1 2 3 4 5 6]./24)
         set(gca,'xticklabel',{'1/24','1/12','1/8','1/6','5/24','1/4'})
         set(gca,'ytick',[0:45:360])

         grid on
         xlabel(['Frequency [',Da.frequency.units,']'],'Interpreter','none')
         ylabel(['Phase [',Da.phase.units ,']'],'Interpreter','none')
         
         if OPT.export
         text(1,0,mktex('Created with t_tide (Pawlowicz et al, 2002) & OpenEarthTools <www.OpenEarth.eu>'),'rotation',90,'units','normalized','verticalalignment','top','fontsize',6)
         basename = [OPT.directory,filesep,'spectrum',filesep,filename(ncmodel{ifile})];
         print2screensizeoverwrite([basename,'_spectrum.png'])
        %print2screensizeeps      ([basename,'_spectrum.eps'])
         saveas         (gcf,[basename,'_spectrum.fig'],'fig')
         end
         
      
      end
      
   %% PLANVIEW plot

      if OPT.plot.planview
      
      %% PLANVIEW component loop

         for dcomp = 1:size  (D.amplitude,1);
             mcomp = strmatch(D.component_name(dcomp,:),...
                              M.component_name);
                             
            if ~isempty(mcomp)     
            if D.amplitude(dcomp) > OPT.amp_min;
         
               name  = lower(deblank(D.component_name(dcomp,:)));
               index = strmatch(name,OPT.names2planview);
               
               if ~isempty(index)
               
               figure(FIGS(index))
               
               %               data | model
               % amplitude     x    |  x
               % phase         x    |  x
               
               plot(D.longitude(1),D.latitude(1),'k.')
               hold on

               txt.D.amp   = pad(num2str(D.amplitude(dcomp),'%4.2f'),5,' ');
               txt.D.phase = pad(num2str(D.phase    (dcomp),'%4.1f'),5,' ');
               
               txt.M.amp   = pad(num2str(M.amplitude(mcomp),'%4.2f'),5,' ');
               txt.M.phase = pad(num2str(M.phase    (mcomp),'%4.1f'),5,' ');
               
               try;txt.D = rmfield(txt.D,'both');end
               try;txt.M = rmfield(txt.M,'both');end

               if isfield(OPT,'verticaloffset')
                  txt.D.both{OPT.verticaloffset(ifile)  } = [txt.D.amp  ,' ',Da.amplitude.units,' | ',txt.D.phase,' ',Da.phase.units];
                  txt.M.both{OPT.verticaloffset(ifile)+1} = [txt.M.amp  ,' ',Ma.amplitude.units,' | ',txt.M.phase,' ',Ma.phase.units];
                  txt.M.both{OPT.verticaloffset(ifile)+2} = [char(D.station_id)];
               else
                  txt.D.both{1}                           = [txt.D.amp  ,' ',Da.amplitude.units,' | ',txt.D.phase,' ',Da.phase.units];
                  txt.M.both{2}                           = [txt.M.amp  ,' ',Ma.amplitude.units,' | ',txt.M.phase,' ',Ma.phase.units];
                  txt.M.both{3}                           = [char(D.station_id)];
               end
               
               text(D.longitude(1),D.latitude(1),'.')
               text(D.longitude(1),D.latitude(1),txt.D.both,'verticalalignment',OPT.verticalalignment,'color',OPT.color.data ,'horizontalalignment',OPT.horizontalalignment,'fontsize',OPT.fontsize);
               text(D.longitude(1),D.latitude(1),txt.M.both,'verticalalignment',OPT.verticalalignment,'color',OPT.color.model,'horizontalalignment',OPT.horizontalalignment,'fontsize',OPT.fontsize);

               end
               
            end
            end
         end
         
      end % if OPT.plot.planview
      
   %% Pause

      if OPT.pause
      disp('Press key to continue ...')
      pause
      
      end

   end % Station loop

%% PLANVIEW lay-out (NB after Station loop)

   if OPT.plot.planview
   
      if ~isempty(OPT.vc);
         try % if http and you're not connected
         L.lon = nc_varget(OPT.vc,'lon');
         L.lat = nc_varget(OPT.vc,'lat');
         catch
         L.lon = [];
         L.lat = [];
         end
      end

      for icomp=1:length(OPT.names2planview)
   
         figure(FIGS(icomp))
         
         if ~isempty(OPT.axis)
            axislat(mean(OPT.axis(3:4)))
            axis([OPT.axis])
         else
            axislat
            axis tight
         end
         
         tickmap('ll','format','%0.1f')
         h = title({[upper(OPT.names2planview{icomp}),'    \color[rgb]{',num2str(OPT.color.data ),'}^{data}',...
                                                          '\color[rgb]{',num2str(OPT.color.model),'}_{model}']});
         set(h  ,'fontSize',OPT.title.fontsize)
         set(gca,'fontSize',OPT.axes.fontsize );
         if ~isempty(OPT.vc)
            plot(L.lon,L.lat,'color',[.7 .7 .7]);
         end
         hold on
         
         if OPT.export
         text(1,0,mktex('Created with t_tide (Pawlowicz et al, 2002) & OpenEarthTools <www.OpenEarth.eu>'),'rotation',90,'units','normalized','verticalalignment','top','fontsize',6)
         basename = [OPT.directory,filesep,'planview',filesep,filename(ncmodel{ifile})];
         print2screensizeoverwrite([basename,'_plan_',OPT.names2planview{icomp},'.png'])
        %print2screensizeeps      ([basename,'_plan_',OPT.names2planview{icomp},'.eps'])
         end
         
      end
   
   end
