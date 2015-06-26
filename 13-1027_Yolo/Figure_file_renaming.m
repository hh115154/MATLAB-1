%% renaming massive figure files.
clear all
close all

% Figure 7-14 group
cd('\\CBEC-READYNAS\backup\DiskStation01_1\cbec\Projects\13-1027_Yolo_Bypass_Fish_Passage\Reporting\YBM_Model_Report_Draft\Figures\SJB\Ch7\Fig 7-17 SacW animation snapshot')

% file_ext = 'jpg';
file_ext = 'docx';
file_search = ['*A7*.' file_ext];

alt_type = 'SacW';
D = dir(file_search);
WY = 1997:2012;
for j = 1:length(D)
    old_fn = str2num(D(j).name(8:9));
    new_fn = ((old_fn-1)/16 + 4)*16+1;
    
    old_filename = sprintf('Fig_A7-%d_%s_WY%d.%s',old_fn,alt_type,WY(j),file_ext);
    new_filename = sprintf('Fig_A7-%d_%s_WY%d.%s',new_fn,alt_type,WY(j),file_ext);
    
    if isempty(dir(old_filename))
        break
    end
    movefile(old_filename,new_filename);
end