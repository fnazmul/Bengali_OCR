%preprocessing

function binSeg()

global binImg allChars lineCount;

%negate the image
%readImage();
%readImage('newP.bmp');
binImg = ~binImg;          %Binary Image

cNum = 0;

%line segmentation
lines = lineSeg();

%zone detection
%lNum = 4;
for lNum= 1:lineCount
    [line matraLoc] = zoneSeg(lines, lNum);
    %word segmentation
    [words wordCount] = wordSeg(line);

    for wNum = 1:wordCount
        
        %character segmentation
        [chars charCount] = letterSeg(line, words, wNum, matraLoc); 

        for c = 1:charCount
            cNum = cNum + 1;
            allChars(:,:,cNum) = chars(:,:,c);            
            %figure, imshow(allChars(:,:,cNum));
        end        
    end    
end
end




function [chars charCount] = letterSeg( line, words, wordNo, matraLoc )

global maxHeight;
global minHeight;

word = line(:, words(wordNo,1):words(wordNo,2));

lenMin = ceil(maxHeight - maxHeight*0.20);
lenMax = ceil(maxHeight - maxHeight*0.10);
if (minHeight < lenMin)
    minHeight = lenMin;
elseif (minHeight > lenMax)
    minHeight = lenMax;
end


temp = word;
temp(1:matraLoc(2), :) = 0;
temp(minHeight:maxHeight,:) = 0;


%%%        Removing Thin Matra          %%%


SE = [1; 1];                    % defining structuring element                                  
temp = imopen(temp, SE);        % applying erosion & dilation

%estimated character height
estHeight = minHeight - matraLoc(2);

[L,noObj] = bwlabel(temp);
data = regionprops(L, 'basic');

char_h = 20;
char_w = 20;
chars = zeros( char_h, char_w, noObj);
charLocs = zeros(noObj,2);

aakar = -2;

indx = noObj+2;
charCount = 0;

for i = 1 : noObj
        
    tmp = data(i).BoundingBox;
    whRatio = tmp(3)/tmp(4);
    
    
    %totally ignore garbage components
    if(tmp(4) < 0.25*estHeight)
        continue;
    %specially handle components that are neither garbage nor character
    %w/h < 0.6 and h< 0.8*estHeight    
    elseif( (whRatio < 0.45) || (tmp(4) < 0.75*estHeight))
        % consequetive non-character components
        res = 0; % assume no characters found
        if ( indx+1 == i)
            %handle specially, try to join the components
            [ch res] = tryJoin(data(i-1).BoundingBox, data(i).BoundingBox,...
                       word, matraLoc);
        end

        %if a character is found
        if(res ==1)
            y = data(i-1).BoundingBox(1);                              
            indx = 0;
        else              
            % if it is akar or hrosho-ikar or jo-fola
            if( whRatio>=0.08 && whRatio<= 0.4 && tmp(4)>0.8*estHeight)
                continue;
            elseif( (i>1 &&  ...
             (tmp(1)+tmp(3)) > (data(i-1).BoundingBox(1)+ data(i-1).BoundingBox(3)))...
              || (i==1))
                 indx = i;                        
            end
            continue;             
        end
        
            
    % valid characters
    else
        x = round(tmp(2));          %Row
        y = round(tmp(1));          %column
        if(matraLoc(1)<x)
            ch = word(matraLoc(1):x+tmp(4)-1, y:y+tmp(3)-1);
        else
            ch = word(x:x+tmp(4)-1, y:y+tmp(3)-1);
        end
    end
    %resize the character and store in the chars array
    ch = imresize(ch,[char_h,char_w],'nearest');
    charCount = charCount + 1;
    chars(:,:,charCount) = ch;
    charLocs(charCount,1) = y;
    charLocs(charCount,2) = y+tmp(3)-1;   
    
end
 
end
%{
for d=1:charCount
    figure, imshow(chars(: , : , d));
end
%}


function [ch res] = tryJoin(Bbox1, Bbox2, wrd, matra)
        
    global minHeight;

    estHeight = minHeight - matra(2);
    akarThresh = 0.75*estHeight;
    
    if( Bbox1(4) >akarThresh && Bbox2(4) >akarThresh)
        res = 0;
        ch = [];
        return
    end
    
    r1 = matra(1);
    r2 = max(round(Bbox1(2)) + Bbox1(4)-1, round(Bbox2(2)) + Bbox2(4)-1);
    c1 = round(Bbox1(1));
    c2 = round(Bbox2(1)) + Bbox2(3)-1;
    r3 = max(round(Bbox1(2)), round(Bbox2(2)));
    r3 = round((r3 - r1)/2);
    c3 = round((c1+c2)*0.25);
        
    ch = wrd(r1:r2, c1:c2);
     
    %connect using 50% matra
    ch(1:r3, c1+c3: c2-c3) = 1;
    %jora = (c2-c1)/(r2-r1)
    
    [h1 w1] = size(ch);
    if( (w1/h1) > 0.62) && (h1 >= 0.85*estHeight)
        res = 1;
    else
        res = 0;
    end
end





