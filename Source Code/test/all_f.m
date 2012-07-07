
function allCharFeatures = all_f()

load all_let


allCharFeatures = [];


for i = 1:25
    ch1 = letters1(:,:,i);
    ch2 = letters2(:,:,i);
    ch3 = letters3(:,:,i);
    ch4 = letters4(:,:,i);
    ch5 = letters5(:,:,i);
    
    ch1 = findFeatures(ch1);
    ch2 = findFeatures(ch2);
    ch3 = findFeatures(ch3);
    ch4 = findFeatures(ch4);
    ch5 = findFeatures(ch5);
    
    
    a = [ch1.matra, ch2.matra, ch3.matra, ch4.matra, ch5.matra];
    %a = mean(a)
    t.matra = mean(a);
    
    a = [ch1.Lbar, ch2.Lbar, ch3.Lbar, ch4.Lbar, ch5.Lbar];
    t.Lbar = mean(a);
    
    a = [ch1.Rbar, ch2.Rbar, ch3.Rbar, ch4.Rbar, ch5.Rbar];
    t.Rbar = mean(a);
    
    a = [ch1.centroid(1), ch2.centroid(1), ch3.centroid(1), ch4.centroid(1), ch5.centroid(1)];
    t.centroid(1) = mean(a);
    
    a = [ch1.centroid(2), ch2.centroid(2), ch3.centroid(2), ch4.centroid(2), ch5.centroid(2)];
    t.centroid(2) = mean(a);
    
    a = [ch1.eNum, ch2.eNum, ch3.eNum, ch4.eNum, ch5.eNum];
    t.eNum = mean(a);
    
    a = [ch1.eccent, ch2.eccent, ch3.eccent, ch4.eccent, ch5.eccent];
    t.eccent = mean(a);
    
    a = [ch1.hRatio, ch2.hRatio, ch3.hRatio, ch4.hRatio, ch5.hRatio];
    t.hRatio = mean(a);
    
    a = [ch1.vRatio, ch2.vRatio, ch3.vRatio, ch4.vRatio, ch5.vRatio];
    t.vRatio = mean(a);
    
    a = [ch1.HPSkewness, ch2.HPSkewness, ch3.HPSkewness, ch4.HPSkewness, ch5.HPSkewness];
    t.HPSkewness = mean(a);
    
    a = [ch1.VPSkewness, ch2.VPSkewness, ch3.VPSkewness, ch4.VPSkewness, ch5.VPSkewness];
    t.VPSkewness = mean(a);
    
    a = [ch1.HPKurtosis, ch2.HPKurtosis, ch3.HPKurtosis, ch4.HPKurtosis, ch5.HPKurtosis];
    t.HPKurtosis = mean(a);
    
    
    a = [ch1.VPKurtosis, ch2.VPKurtosis, ch3.VPKurtosis, ch4.VPKurtosis, ch5.VPKurtosis];
    t.VPKurtosis = mean(a);
    
    for j = 1:4
        for k = 1:4
            a = [ch1.parts(j,k), ch2.parts(j,k), ch3.parts(j,k), ch4.parts(j,k), ch5.parts(j,k)];
            t.parts(j,k) = mean(a);
        end
    end
    
    allCharFeatures = [allCharFeatures, t];
end
    
    
    
    

