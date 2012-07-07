%MATLAB ActiveX automation client example 
 % Open Word, add Docs, add dok, 
 % copy & paste using clipboard
 
function send2Word()
 

global finalOutput lineCount

%First, open an WORD Server.
Word = actxserver('Word.Application');

% Not saving to a file, so make WORD visible
set(Word, 'Visible', 1);

% Insert a new document.
Docs = Word.Documents;
Doc = invoke(Docs, 'Add');

%set the font settings
set(Word.application.selection.Font,'Name','AdarshaLipiNormal');
set(Word.application.selection.Font,'Size',20);
newline = sprintf('\r');

for line=1: lineCount
      
    %copy the contents in the clipboard
    clipboard('copy',char(finalOutput{line}));
    %str=clipboard('paste');

    % To place cursor at End of Doc
    end_of_doc = get(Word.activedocument.content,'end');
    set(Word.application.selection,'Start',end_of_doc);
    set(Word.Application.Selection,'End',end_of_doc);
    
    %invoke the 'paste' command in WORD
    invoke(Word.Application.Selection,'Paste');
    
    
    % set the font settings
    set(Word.application.selection.Font,'Name','AdarshaLipiNormal');
    set(Word.application.selection.Font,'Size',20);

    %copy the newline in the clipboard
    clipboard('copy',newline);
    %str=clipboard('paste');
    
    %set the cursor at the end of the doc
    end_of_doc = get(Word.activedocument.content,'end');
    set(Word.application.selection,'Start',end_of_doc);
    set(Word.application.selection,'End',end_of_doc);
    
    %invoke the 'paste' command in WORD
    invoke(Word.Application.Selection,'Paste');    
    
    
end
