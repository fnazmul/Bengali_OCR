function t = findFeatures( ch )

        char_h = 20;
        char_w = 20;

        r_thresh = round(char_h * 0.25);    % row threshold
        c_thresh = round(char_w * 0.50);    % column threshold
        w_thresh = round(char_w * 0.85);    % width threshold
        h_thresh = round(char_h * 0.85);    % height threshold

        ch = bwmorph(ch, 'fill', Inf);      % Fills isolated interior pixels (individual 0's that are surrounded by 1's)

        %Matra detection........................
        s = ch(1:r_thresh,:);
        s  = sum(s, 2);
        [max_val indx] = max(s);

        if(max_val > w_thresh)
            
            tmp = ch(indx, : );
            [B,L] = bwboundaries(tmp,'noholes');
            data = regionprops(L, 'boundingbox');
            [height w] = size(data);
            
            t.matra = 0;
            for i = 1: height
                if( data(i).BoundingBox(3) >= h_thresh)
                    t.matra = 1;
                    break;
                end
            end

        else
            t.matra = 0;
        end
        
        %Leftside Vertical bar..................
        s = ch(:, 1:c_thresh);
        s = sum(s, 1);

        [max_val indx] = max(s);
       
        if(max_val > h_thresh)
            
            tmp = ch(:, indx);
            [B,L] = bwboundaries(tmp,'noholes');
            data = regionprops(L, 'boundingbox');
            [height w] = size(data);
            
            t.Lbar = 0;
            for i = 1: height
                if( data(i).BoundingBox(4) >= h_thresh)
                    t.Lbar = 1;
                    break;
                end
            end

        else
            t.Lbar = 0;
        end

        %Rightside Vertical bar..................
        s = ch(:, c_thresh+1:char_w);
        s = sum(s, 1);

        [max_val indx] = max(s);
        if(max_val > h_thresh)
            
            tmp = ch(:, c_thresh+indx);
            [B,L] = bwboundaries(tmp,'noholes');
            data = regionprops(L, 'boundingbox');
            [height w] = size(data);
            
            t.Rbar = 0;
            %for i = 1: height
                if( data(1).BoundingBox(4) >= h_thresh)
                    t.Rbar = 1;
                    %break;
                end
            %end

        else
            t.Rbar = 0;
        end

        % centroid, euler number, eccentricity, orientation
        [B,L] = bwboundaries(ch,'noholes');
        data = regionprops(L, 'area','centroid', 'eulernumber', 'eccentricity');
        if(size(data,1)>1)
            [val idx] = max([data.Area]);
            t.centroid = data(idx).Centroid;
            t.eNum = data(idx).EulerNumber;
            t.eccent = data(idx).Eccentricity;
            %t.orient = data(idx).Orientation;    
        else
            t.centroid = data.Centroid;
            t.eNum = data.EulerNumber;
            t.eccent = data.Eccentricity;
            %t.orient = data.Orientation;    
        end
        
        
        %4x4 partition of the character with the number of on pixels
        t.parts = zeros(4,4);
        for j = 0:3
            for k = 0:3
                temp = ch(1+j*5:5+j*5,1+k*5:5+k*5);
                rsum = sum(temp,2);
                s = sum(rsum,1);
                t.parts(j+1,k+1) = s;
            end
        end
        
        
        % Horizontal & Vertical Ratio Calculation.........
        upper_h=sum(sum(ch(1:char_h/2,1:char_w)));    
        lower_h=sum(sum(ch(char_h/2+1:char_h,1:char_w)));     
        t.hRatio=upper_h/lower_h;
        left_h=sum(sum(ch(1:char_h,1:char_w/2)));    
        right_h=sum(sum(ch(1:char_h,char_w/2+1:char_w)));        
        t.vRatio=left_h/right_h;
        
                
        % Compute the horizontal and vertical projections (column vectors)
        t.hProjection = sum(ch,2);
        t.vProjection = sum(ch,1)';	

        % Find the central moments of the horizontal and vertical projections

        [r,c] = size(ch);
        
        % Find the 0th and 1st moments of H and V projections
        t.HPMoment = [ones(1,r) ; 1:r]*t.hProjection;
        t.VPMoment = [ones(1,c) ; 1:c]*t.vProjection;
        
        
        %t.HCenter = t.HPMoment(2)/t.HPMoment(1);
        %t.VCenter = t.VPMoment(2)/t.VPMoment(1);

        r_norm = [1:r]-t.centroid(2);
        ind_r = [r_norm.^2 ; r_norm.^3 ; r_norm.^4];
        c_norm = [1:c]-t.centroid(1);
        ind_c = [c_norm.^2 ; c_norm.^3 ; c_norm.^4];
                
        t.HPMoment(3:5) = ind_r * t.hProjection;
        t.VPMoment(3:5) = ind_c * t.vProjection;

        t.HPSkewness = t.HPMoment(4)/t.HPMoment(3)^(3/2);
        t.VPSkewness = t.VPMoment(4)/t.VPMoment(3)^(3/2);

        t.HPKurtosis = t.HPMoment(5)/t.HPMoment(3)^(2);
        t.VPKurtosis = t.VPMoment(5)/t.VPMoment(3)^(2);

        %stat.Class=0;
  