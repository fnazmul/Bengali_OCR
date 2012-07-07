% this function does the line segmentation operation
% takes two input arguments
% first argument is the line number to operate on (lineNo) and 
% second argument is the starting and ending index of each line (lines)
% returns an individual line (line), location of matra (matraLoc)

function [line, matraLoc] = zoneSeg( lines, lineNo )

global binImg maxHeight minHeight;

temp = binImg(lines(lineNo,1):lines(lineNo,2),:);
h = size(temp,1);

if(maxHeight > h)
    diff = maxHeight - h;
    halfDiff = floor(diff/2);
    
    line = [ binImg(lines(lineNo,1)-halfDiff : lines(lineNo,1)-1, :) ;
             temp;
             binImg(lines(lineNo,2)+1 : lines(lineNo,2)+diff-halfDiff , :) 
            ];
else
    line = temp;
end

%imshow(line);

rowSum = sum(line,2);
[maxval index] = max(rowSum);

threshold = maxval - floor(maxval * 0.25);

top = index;
bottom = index;

for i = 1 : floor(maxHeight/5)
    if ( ((index -i) >= 1) && (rowSum(index - i) >= threshold) )
            top = index - i;        
    end
    if ( (index+i <= maxHeight) && (rowSum(index+i) >= threshold) )
    %if rowSum(index+i) >= threshold
        bottom = index + i;
    end
end
matraLoc = [top , bottom];
%figure, imshow(line(top:bottom,:))

[L,no_obj] = bwlabel(line);

data = regionprops(L, 'boundingbox');

if(no_obj >0)
    y_data = [];%data(1).BoundingBox;
    for x= 1:no_obj
        y_data = cat(1, y_data, data(x).BoundingBox);
    end
    y_data(:,1) = [];   %removing x
    y_data(:,2) = [];   %removing x_width
    rowSum = sum(y_data, 2);

    minHeight = ceil(min(rowSum));
end
