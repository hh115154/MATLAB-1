clear all; close all;
% Figure filename change + MS Word text box change
cd('C:\Work\13-1027_Yolo\DOC\Figure_Templates\Figures Final\Fig D1-64')
% cd('C:\Work\13-1027_Yolo\DOC\Figure_Templates\Figures Final\Fig C1-80')
curr_dir = pwd;
% This is the first step; changing filenames.

% file_ext = 'jpg';
file_ext = 'docx';
file_search = ['*.' file_ext];

D = dir(file_search);
% WY = 1997:2012;

%%
for i = 1:length(D)
    
    filename = D(i).name;
    
    Word = actxserver('Word.application');
    Word.Visible = 0;
    set(Word,'DisplayAlerts',0);
    Docs = Word.Documents;
    Doc = Docs.Open(fullfile(curr_dir,filename));
    
    hSections = Doc.Sections.Add;
    
    hSections.Footers.Item(1).Range.Text = ' ';
    % selection = Word.Selection;
    % new_figurenum_docx = sprintf('Figure D%d',old_filenum-80);
    % selection.Find.Execute('Figure X-X',0,0,0,0,0,1,1,0,new_figurenum_docx,2,0,0,0,0);
    
    
    Doc.Save; Docs.Close;
    invoke(Word,'Quit');
    delete(Word);
    
    fprintf(1,'old: %s\n',filename)

end