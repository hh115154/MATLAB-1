Word = actxserver('Word.application'); 
Word.Visible = 0; 
set(Word,'DisplayAlerts',0); 
Docs = Word.Documents; 
Doc = Docs.Open('C:\Work\13-1027_Yolo\DOC\Figure_Templates\Figures Final\Fig C1-80\test1.docx'); 
selection = Word.Selection; 
%selection.Find.Execute('Figure Title',0,0,0,0,0,1,1,0,'Really?',2,0,0,0,0); 
selection.Find.Execute('Figure X-X',0,0,0,0,0,1,1,0,'Figure C-1',2,0,0,0,0); 
selection.Find.Execute('XXX',0,0,0,0,0,1,1,0,'SJB',2,0,0,0,0); 
selection.Find.Execute('Figure Title',0,0,0,0,0,1,1,0,'Wetted Area for WY 1997 for Feb 15 Gate Closure',2,0,0,0,0); 
selection.Find.Execute('Notes:',0,0,0,0,0,1,1,0,'Notes: TUFLOW model results showing wetted area (lower) and gate flows (upper)',2,0,0,0,0); 

Doc.Save; Docs.Close; 
invoke(Word,'Quit'); 
delete(Word);