%preprocessing
%global binImg maxHeight minHeight;

function ocrEngine(handles)

global binImg finalOutput lineCount;

%set(handles.waitText,'Visible','off');
set(handles.oOutput,'String',[]);
drawnow
%read the image
%readImage();
%readImage('newP.bmp');
binImg = ~binImg;          %Binary Image


space = ' ';
newLine = '\r';

%line segmentation
lines = lineSeg();

%create the final output cell array
finalOutput = cell(lineCount,1);

%zone detection
%lNum = 4;
for lNum= 1:lineCount
    [line matraLoc] = zoneSeg(lines, lNum);
    %word segmentation
    [words wordCount] = wordSeg(line);

    for wNum = 1:wordCount
        
        set(handles.waitText,'Visible','off');
        drawnow
        
        %character segmentation
        %[chars charCount charLocs] = charSeg(line, words, wNum, matraLoc);
        [temp chars charCount] = charSeg(line, words, wNum, matraLoc);      
        
        for cNum = 1:charCount
            buttonState = get(handles.stepButton,'Value');
            if buttonState == get(handles.stepButton,'Max')
                stepByStep(handles, chars, cNum, temp(cNum))%,lNum);                
                pause(1/2);
            end            
                %concatenate the word with the rest of the line
                finalOutput{lNum} = [finalOutput{lNum},char(temp(cNum))];                
                set(handles.oOutput,'String',finalOutput);
                drawnow           
        end
        finalOutput{lNum} = [finalOutput{lNum},char(space)];
        
    end    
end
end
%send the lines to the MS-Word
%send2Word();


function stepByStep(handles,chars,cNum,text)%,lNum)
    
        %global finalOutput;
        
        axes(handles.stepChar);
        %colormap(gray(2));        
        imshow(chars(:,:,cNum));
    
        str=strcat('=',char(text));
        set(handles.stEqual,'String',str);    
        
        set(handles.stepChar,'XTick',[]);
        set(handles.stepChar,'YTick',[]);
        
        set(handles.stepChar,'Visible','on');
        set(handles.stEqual,'Visible','on');            
        
        
        %waitfor(handles.stepNext,'Value',1.0);
        %set(handles.stepNext,'Value',0.0);
        %{
        set(handles.stepNext,'Value',0.0);
        
        rb_state=get(handles.stepNo,'Value');
        if rb_state==get(handles.stepNo,'Max') 
            finalOutput{lNum} = [finalOutput{lNum},char('-')];
        else   
            finalOutput{lNum} = [finalOutput{lNum},char(text)];
        end
        
        
        set(handles.oOutput,'String',finalOutput);
        %}
        %waitfor(handles.stepNext,'Value',1.0);
        %set(handles.stepNext,'Value',0.0);      
end


