
% this function does the line segmentation operation
% only one argument is the binary image matrix
% returns the no of lines(lineCount) and 
% the starting and ending index of each line (lines)

function lines = lineSeg( )

global binImg maxHeight lineCount;

totalLines = 30;
threshold = 3;
lThresh = 3;

h = [];
lineCount = 0;
%maxHeight = 0;
lines = zeros(totalLines,2);

height = size(binImg,1);
rowSum = sum(binImg, 2);

start = 0;
for i = 1 : height
    if( (rowSum(i)<threshold) && (start~=0) && (i-top >lThresh)  ) 
            bottom = i;                   
                           
            h = [h, bottom - top];
            %{
            if (h < threshold)
                continue;
            end

            if(h > maxHeight)
                  maxHeight = h;
            end
            %}
            lines(lineCount, 2) = bottom;
            start = 0;        
            
    elseif (rowSum(i)>threshold && start == 0)
        top = i;
        lineCount = lineCount + 1;
        lines(lineCount,1) = top;
        start = 1;
    end
end

maxHeight = max(h);
%remove extra lines
lines = lines(1:lineCount,:);

%lines(1:lineCount,:)
%for l=1:lineCount
 %   figure, imshow(binImg(lines(l,1):lines(l,2),:));
%end