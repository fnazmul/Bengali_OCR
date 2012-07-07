%preprocessing
%global binImg maxHeight minHeight;
global finalOutput lineCount

%read the image
%readImage('words.jpg');
readImage('newP.bmp');

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
        
        %character segmentation
        %[chars charCount charLocs] = charSeg(line, words, wNum, matraLoc);
        [temp] = charSeg(line, words, wNum, matraLoc);
        %concatenate the word with the rest of the line
        finalOutput{lNum} = [finalOutput{lNum},char(temp),char(space)];
        
    end    
end

%send the lines to the MS-Word
send2Word();


