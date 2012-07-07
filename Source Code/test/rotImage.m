function rotImage()

global binImg;

prev_max = 0;
temp = imresize(binImg,0.1);

C = temp;
for x = 0 : 0.01 : 2;
    s = sum(C, 2);
    max_val = max(s);
        
    C = imrotate(temp,x);
    
    if(max_val >= prev_max)
        prev_max = max_val;
        angle = x;
    end
end

C = temp;
for x = 0 : 0.05: 2;
    s = sum(C, 2);
    max_val = max(s);
    
    C = imrotate(temp,-x);
    
    if(max_val >= prev_max)
        prev_max = max_val;
        angle = -x;
    end
end

binImg = imrotate(binImg, angle);

%angle
