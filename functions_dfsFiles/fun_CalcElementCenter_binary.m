function [Elmt, xe, ye, ze] = fun_CalcElementCenter_binary(mesh_info)

% mesh_info: Header.mesh_info from [Locate_Data_Block_2012.m] or
%           [fun_ReadDfsuHeader_v2012.m]
% data in [mesh_info]: 
%   1. Node id: serial number
%   2. X-coord:  
%   3. Y-coord: 
%   4. Z-coord: 
%   5. Code   : boundary values at node
%   6. Element id:     serial number
%   7. Element type:   21 (triangles) or 25 (quads)
%   8. No of nodes:    3 or 4 (# of nodes consisting each elements)
%   9. Connectivity:   element table in a vector format

Elem_id = mesh_info(6).data;
Elem_len = length(Elem_id);

No_node = mesh_info(8).data;
Conn    = mesh_info(9).data;

Elmt = zeros(Elem_len,4);  % element table

%% Using For loop - not ideal
% tic
% Et(1,1:No_node(1)) = Conn(1:No_node(1));
% 
% for i = 2:Elem_len
%     conn_loc = sum(No_node(1:i-1));
%     Et(i,1:No_node(i)) = Conn(conn_loc+1:conn_loc+No_node(i));
%     
%     
% end
% toc

%% loop 2nd option - a little better than 1st loop

indsum = cumsum(No_node);
for k = 1:Elem_len
    
    Elmt(k,1:No_node(k)) = ...
        Conn(indsum(k)-No_node(k)+1:indsum(k));
end


% vectorization fail !!!!!
% indsum = cumsum(No_node);
% Et(Elem_id(:),1:No_node(:)) = Conn(indsum(:)-No_node(:)+1:indsum(:));

%% 
[xe,ye,ze] = mzCalcElmtCenterCoords(Elmt,mesh_info(2).data,mesh_info(3).data,mesh_info(4).data);