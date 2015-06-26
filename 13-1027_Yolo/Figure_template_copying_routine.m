clear all;close all;
% this is to copy template files to a new name for Ch. 7 appendix


%% Template 1
% template = 'template_Legal_landscape.docx';
% alt_type = {'FreLg';'FreMed';'FreSm';'SacW'};
% 
% for kk = 1:length(alt_type)
%     for i = 1997:2012
%         fig_number = (i-1997+1)+16*kk;
%         newfile = sprintf('Fig_A7-%d_%s_WY%d.docx',fig_number,alt_type{kk},i);
%         copyfile(template,newfile)
%         
%     end
% end

%% Template 2
template = 'FigureBox_Letter_Landscape_cbec_HDR_rev050914.docx';
alt_type = {'Feb15';'Mar1';'Mar15';'Apr1';'Apr30'};

for kk = 1:length(alt_type)
    for i = 1997:2012
        fig_number = (i-1997+1)+16*(kk-1);
        newfile = sprintf('Fig_A7-%d_FreQ_WetA_%s.docx',fig_number,alt_type{kk});
        copyfile(template,newfile)
        
    end
end