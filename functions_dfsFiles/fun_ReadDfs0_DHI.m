function data = fun_ReadDfs0_DHI(infile)
%fun_ReadDfs0_DHI Read a dfs0 file using DHI-MATLAB DLL
%
%   Data = fun_ReadDfs0_DHI(filename);
%   Simpler, but still requires DHI DLL.

NET.addAssembly('DHI.Generic.MikeZero.DFS');
import DHI.Generic.MikeZero.DFS.*;
import DHI.Generic.MikeZero.DFS.dfs0.*;

% infile = 'data/data_ndr_roese.dfs0';
if nargin <1
    [infile,dfs0_path]=uigetfile('*.dfs0','Select the .dfs0 to load ...');
else
    dfs0_path = cd;
%     disp('Error: Select Valid dfs2 file');
end


dfs0File  = DfsFileFactory.DfsGenericOpen(fullfile(dfs0_path,infile));


%% Read times and data - one timestep at a time - this is VERY slow!
% Matlab does not handle .NET method calls very efficiently, so the user
% should minimize the number of method calls to .NET components.
t = zeros(dfs0File.FileInfo.TimeAxis.NumberOfTimeSteps,1);
data = zeros(dfs0File.FileInfo.TimeAxis.NumberOfTimeSteps,dfs0File.ItemInfo.Count);
tic
for it = 1:dfs0File.FileInfo.TimeAxis.NumberOfTimeSteps
    for ii = 1:dfs0File.ItemInfo.Count
        itemData = dfs0File.ReadItemTimeStep(ii,it-1);
        if (ii == 1)
            t(it) = itemData.Time;
        end
        data(it, ii) = double(itemData.Data);
    end
%     if (mod(it,100) == 0)
%         fprintf('it = %i of 7921\n',it);
%     end
end
toc
fprintf('Did app. %f .NET calls per second\n',...
    double(dfs0File.FileInfo.TimeAxis.NumberOfTimeSteps*(2*dfs0File.ItemInfo.Count+1))/toc);

%% Read some item information
items = {};
for i = 0:dfs0File.ItemInfo.Count-1
   item = dfs0File.ItemInfo.Item(i);
   items{i+1,1} = char(item.Name);
   items{i+1,2} = char(item.Quantity.Unit);
   items{i+1,3} = char(item.Quantity.UnitAbbreviation); 
end

dfs0File.Close();
