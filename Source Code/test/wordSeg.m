% this function does the word segmentation operation
% the argument is the line to operate on (line) 
% returns the number of words (wordCount)
% and the starting and end location of each word (words)

function [words, wordCount] = wordSeg( line )


totalWords = 30;
threshold = 1;
words = zeros(totalWords, 2);

% height and width of the line being processed
[height width] = size(line);
%column sums of the line
colSum = sum(line, 1);

% determine average word gap to avoid splitted words
gap = [];
c = colSum > threshold;
[L, noObj] = bwlabel(c);
dt = regionprops(L, 'boundingbox');
for i=2:noObj
    gap=[gap,(dt(i).BoundingBox(1) - dt(i-1).BoundingBox(1)- dt(i-1).BoundingBox(3))];
end
avgGap = mean(gap);

wordCount = 0;
start = 0;
right = -width;
for i = 1 : width
    if( colSum(i)<threshold && start~=0)
            right = i-1;                   
            words(wordCount, 2) = right;
            start = 0;
    elseif (colSum(i)>threshold && start == 0)
        %end of last word minus start of the new word
        wordGap = i - right;
        
        if(wordGap < avgGap * 0.35)
            start = 1;            
            continue;
        else        
            wordCount = wordCount+1;
            left = i;
            words(wordCount,1) = left;
            start = 1;
        end
    end
end

%remove extra data
words = words(1:wordCount,:);

%words(1:wordCount,:)
%wordCount

%for x=1:wordCount
    %figure, imshow(line(:, words(x,1):words(x,2)));
%end

