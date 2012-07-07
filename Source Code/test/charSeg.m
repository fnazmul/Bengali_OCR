%function [chars charCount charLocs] = charSeg( line, words, wordNo, matraLoc )
function [wordChars chars cCount] = charSeg( line, words, wordNo, matraLoc )
global maxHeight minHeight;
global Lup upData %dnData;


allLets = [76 77 78 79 80 81 82 83 84 85 87 88 89 90 97 98 99 100 ...
           101 102 103 104 105 106 173 107 109 110 111 112 113 118 119 129 121];
specialLets = [86 175 108 115 116 117 173];
upLets = [161 201 162 163 177];
dnLets = [165 168];

wordChars = ' ';

word = line(:, words(wordNo,1):words(wordNo,2));
%figure,imshow(word);

lenMin = ceil(maxHeight - maxHeight*0.24);
lenMax = ceil(maxHeight - maxHeight*0.03);

if (minHeight >= maxHeight*0.95)
    minHeight = maxHeight;
elseif (minHeight < lenMin)
    minHeight = lenMin;
elseif (minHeight > lenMax)
    minHeight = lenMax;
end

%upper portion
up = word(1:matraLoc(1)-1,:);
SE = [1;1;1];
up = imerode(up, SE);
SE = [1,1;1,1];
up = imdilate(up, SE);


[Lup,upObj] = bwlabel(up);
upData = regionprops(Lup,'boundingbox');

%filter small components
Lup = filterComponents(Lup, upObj, upData,0.45);
%figure,imshow(Lup);

%lower portion
dn = word(minHeight- ceil(0.03*minHeight) : maxHeight,:);
%figure, imshow(dn);

%word after removing upper and lower portion
temp = word;
temp(1:matraLoc(2), :) = 0;
temp(minHeight:maxHeight,:) = 0;

%%%-----------------------------------------%%%
%%%        Removing Thin Matra With         %%%
%%%           Erosion & Dilation            %%%
%%%-----------------------------------------%%%

SE = [1; 1];                    % defining structuring element                                  
temp = imopen(temp, SE);        % applying erosion & dilation

%estimated character height
estHeight = minHeight - matraLoc(2);

[L,noObj] = bwlabel(temp);
data = regionprops(L, 'basic');
%find lower characters

[lowerChars lowerImages]= findLowers(dn, L, noObj, data);

char_h = 20;
char_w = 20;
chars = zeros( char_h, char_w, noObj);
charLocs = zeros(noObj,2);

aakar = -2;

indx = noObj+2;
charCount = 0;
cCount = 0;

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
            bbbx = data(i).BoundingBox;
            % if it is akar or hrosho-ikar
            if( whRatio>=0.08 && whRatio<= 0.27 && tmp(4)>0.8*estHeight)
                %who = 1;
                if((aakar+1) == charCount)
                    who = checkKar(Lup, upData, data(i).BoundingBox, 1);
                %wordChars = strcat(wordChars,char(upLets(who)));       
                else
                    who = checkKar(Lup, upData, data(i).BoundingBox, 0);
                end
                %fprintf(finalOutput,'%s',char(upLets(who)));
                wordChars = strcat(wordChars,char(upLets(who)));
                cCount = cCount + 1;
                chr = word(round(bbbx(2)): round(bbbx(2))+bbbx(4)-1, round(bbbx(1)):round(bbbx(1))+bbbx(3)-1);
                chars(:,:,cCount) = resize20x20(chr,0);
            % if it is aa-kar
            elseif( whRatio > 0.27 && whRatio<= 0.45 && tmp(4)>0.8*estHeight)
                wordChars = strcat(wordChars,char(specialLets(7)));
                aakar = charCount;
                cCount = cCount + 1;                
                chr = word(round(bbbx(2)): round(bbbx(2))+bbbx(4)-1, round(bbbx(1)):round(bbbx(1))+bbbx(3)-1);
                chars(:,:,cCount) = imresize(chr,[char_h,char_w],'nearest');
                %fprintf(finalOutput,'%s',char(upLets(2)));
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
    cCount = cCount+1;
    chars(:,:,cCount) = ch;
    %charLocs(charCount,1) = y;
    %charLocs(charCount,2) = y+tmp(3)-1;   
    
    %recognize the character and put it in the word
    [a b c d] = neuralNetSimulation(ch); %(chars(:,:, charCount));
    %a 
    %b
    %figure, imshow(ch);
    
    % when dha or e-kar is found
    if( c==25 )
       u = checkOikar(Lup, upData, data(i).BoundingBox);
       if(u==1)  %found oi-kar
          %fprintf(finalOutput,'%s',char(specialLets(2)));
          wordChars = strcat(wordChars,char(specialLets(2)));    %index of oikar is 2
          continue;
       else
           aakar = charCount;
       end    
    elseif(c==13)
       u = checkTop(Lup, upData, data(i).BoundingBox);
       if(u~=1) %found ta ****faltu*****
           %wordChars = strcat(wordChars,char(allLets(c)));%(specialLets(1)));
           %fprintf(finalOutput,'%s',char(specialLets(1)));
           wordChars = strcat(wordChars,char(specialLets(1)));  %index of ta is 1
           if(lowerChars(i)~=0)
                %fprintf(finalOutput,'%s',char(dnLets(lowerChars(i))));
                wordChars = strcat(wordChars,char(dnLets(lowerChars(i))));
                cCount = cCount + 1;
                chars(:,:,cCount) = lowerImages(:,:,i);
           end    
           continue;
       end
    end
    %fprintf(finalOutput,'%s',char(allLets(c)));
    wordChars = strcat(wordChars,char(allLets(c)));
    
    if(lowerChars(i)~=0)
        %fprintf(finalOutput,'%s',char(dnLets(lowerChars(i))));
        wordChars = strcat(wordChars,char(dnLets(lowerChars(i))));
        cCount = cCount + 1;
        chars(:,:,cCount) = lowerImages(:,:,i);
    end
    
    %wr(i) =1;
end
%wr 
%{
for d=charCount:-1:1
    figure, imshow(chars(: , : , d));
end
%}
%figure, imshow(temp);
end


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



function [lowerChars lowerImages]= findLowers(down, L, Lnum, Ldata)

%global dnData h;
lowerChars = zeros(1,Lnum);
lowerImages = zeros(20,20,Lnum);

[h w] = size(down);
[r c] = size(L);

L = filterComponents(L, Lnum, Ldata, 0.35);
[Ldn,dnObj] = bwlabel(down);
dnData = regionprops(Ldn,'boundingbox','eulernumber');
%figure, imshow(Ldn);

for i= 1:dnObj
    b = dnData(i).BoundingBox;
    e = dnData(i).EulerNumber;
    
    if(b(4)> h*0.75)
    
        c1 = round(b(1));
        c2 = c1 + round(b(3)/2);
        
        tempo = down(round(b(2)): round(b(2))+ b(4)-1, c1:c1+b(3)-1);
        rImage = resize20x20(tempo, 1);
       
        obj = max( max(L(round(r/2):r,c1:c2)));
        if((obj~=0) && (e<=0))
            lowerChars(obj) = 1;
            lowerImages(:,:,obj) = rImage;
            %figure, imshow(lowerImages(:,:,obj));
        elseif( (obj~=0) && (e==1))
            lowerChars(obj) = 2;
            lowerImages(:,:,obj) = rImage;
            %figure, imshow(lowerImages(obj));
        end
        
    end
end
%lowerChars
end



function region = filterComponents(region, numObj, Data, percnt)
[h w] = size(region);
    
for num = 1 : numObj
    Bbox = Data(num).BoundingBox;
    if(Bbox(4)<= h*percnt)		
        indices = find(region == num);
    	region(indices) = 0;
    end
end
end

function   who = checkOikar(Lup, upData, BBox)
    
    c1 = round(BBox(1));%-2;
    c2 = c1+BBox(3)-1;
    %r2 = BBox(4);
    [r c] = size(Lup);
    %figure, imshow(Lup);
    
    thresh =  round(0.5*BBox(3));
    
    who = 0;
    
    if(r ~= 0)
        obj = max( max(Lup(ceil(r/2): r,c1:c2-thresh)));
        %figure, imshow(Lup(ceil(r/2): r,c1:c2-thresh));
        if(obj~=0)
            b = upData(obj).BoundingBox;
         leftEnd = round(b(1));
            if(leftEnd <= c2 - thresh)    % oi-kar 1.34
                who = 1;        % oi-kar 1.34
            end
        end
    end
    %who
end
        
  
function   who = checkKar(Lup, upData, BBox, aakar)
    
    c1 = round(BBox(1));%-2;
    c2 = c1+BBox(3)-1;
    %r2 = BBox(4);
    [r c] = size(Lup);
    
    thresh =  0.1*BBox(4);
    
    who = 1;
    obj = max( max(Lup(1:r,c1:c2)));
    if(obj~=0)
        b = upData(obj).BoundingBox;
        rightEnd = round(b(1))+b(3)-1;
        leftEnd = round(b(1));
        
        if(rightEnd > c2 + thresh) %&& (b(3)/b(4) >1.9))
            who = 3;            % hrossho i-kar
        elseif(leftEnd <= c2 + thresh)    % oi-kar 1.34
            if(aakar == 1)
                who = 5;        % oi-kar 1.34
            else
                   who = 4;        % dirgho i-kar 1.88
                
            end
        end
    end
%    who
end


function   who = checkTop(Lup, upData, BBox)
    
    c1 = round(BBox(1));
    c2 = c1+BBox(3)-1;
    thresh = c1 - round(BBox(3)*0.1);
    %r2 = BBox(4);
    [r c] = size(Lup);
    
    who = 1;
    obj = max( max(Lup(1:r,c1:c2)));
    if(obj~=0)
        b = upData(obj).BoundingBox;
        leftEnd = round(b(1));
        %rightEnd = round(b(1))+b(3)-1;
        % leftEnd starts at left and rightEnd is connected to matra
        if((leftEnd < thresh) && (max(max(Lup(r-1:r,c2-1:c2+1)))))
            who = 2;    %ta        
        end    
       
    end
    %figure,imshow(Lup(1:r,c1:c2));
    %figure, imshow(Lup);
end


function rImage = resize20x20(charImg, wh)

%width is fixed
if(wh == 1)
    tmp = imresize(charImg,[NaN,20]);
    [r c] = size(tmp);
    if(20-r >0)
        padding = zeros(20-r,c);
        rImage = [tmp;padding];
    else
        rImage = tmp(1:20,1:20); 
    end
else
    tmp = imresize(charImg,[20,NaN]);
    [r c] = size(tmp);
    if(20-c >0)
        padding = zeros(r,20-c);
        rImage = [tmp,padding];
    else
        rImage = tmp(1:20,1:20); 
    end
end

end
