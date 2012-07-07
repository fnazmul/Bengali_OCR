function [a3 a2 result percentage] = neuralNetSimulation( ch )


load trainingChars;
load trainedNeuralNets;

a = findFeatures(ch);     % Finding the features of the given character


tmp = [a.matra, a.Lbar, a.Rbar, a.centroid(1),a.centroid(2),...
       a.eNum, a.eccent, a.hRatio, a.vRatio,...
       a.parts(1,1:4), a.parts(2,1:4), a.parts(3,1:4), a.parts(4,1:4),...
       a.HPSkewness, a.VPSkewness, a.HPKurtosis, a.VPKurtosis]';


%%%---------------------------------------%%%
%%%      Matra/Without Matra Testing      %%%
%%%---------------------------------------%%%

if(a.matra == 1)
    [val1 indx] = max(sim(net1, tmp));
    ans1 = net1Chars(indx);
    
    %{
    if(ans1 == 6 || ans1 == 7)     % dicision between 'cha' & 'chhaa'
        if(a.Lbar == 1)
            ans1 = 6;       %cha
        else
            ans1 = 7;       %chaa
        end
    end
    %}
else
    [val1 indx] = max(sim(net2, tmp));
    ans1 = net2Chars(indx);
    
    if(ans1 == 3 || ans1 == 14)     % dicision between 'ga' & 'pa'
        if(a.eNum == 0) %pa
            ans1 = 20;
        else
            ans1 = 3;       %ga
        end
    end
    
end
%//////////////////////////////////////////////

%%%---------------------------------------%%%
%%%   Sidebar/Without Sidebar Testing     %%%
%%%---------------------------------------%%%

if(a.Lbar == 1)
    [val2 indx] = max(sim(net3, tmp));
    ans2 = net3Chars(indx);
    if(ans2 == 6 || ans2 == 13)     % dicision between 'cha' & 'dhoow'
        if(a.eNum == 0)
            ans2 = 6;
        else
            ans2 = 13;
        end
    end
elseif(a.Rbar == 1)
    [val2 indx] = max(sim(net4, tmp));
    ans2 = net4Chars(indx);
    if(ans2 == 4 || ans2 == 18)     % dicision between 'ghaw' & 'dhaaw'
        if(a.matra == 1)
            ans2 = 4;
        else
            ans2 = 18;
        end
    elseif(ans2 == 19 || ans2 == 22)    % dicision between 'donton-no' & 'baaw'
        if(a.eNum == 0)
            ans2 = 22;
        else
            ans2 = 19;
        end
    elseif(ans2 == 1 || ans2 == 9)    % dicision between 'ka' & 'jhaa'
        if(a.matra == 1)
            ans2 = 1;
        else
            ans2 = 9;
        end
        %{
    elseif(ans2 == 3 || ans2 == 14)     % dicision between 'ga' & 'murdhon-no'
        if(a.hRatio >= 3.05) %murdho-no
            ans2 = 14;
        else
            ans2 = 3;       %ga
        end
         %}
    elseif(ans1 == 3 || ans1 == 14)     % dicision between 'ga' & 'pa'
        if(a.eNum == 0) %pa
            ans1 = 20;
        else
            ans1 = 3;       %ga
        end
    end

else
    [val2 indx] = max(sim(net5, tmp));
    ans2 = net5Chars(indx);
end
%//////////////////////////////////////////////

%%%---------------------------------------%%%
%%%       Loop/Without Loop Testing       %%%
%%%---------------------------------------%%%

if(a.eNum <= 0)
    [val3 indx] = max(sim(net6, tmp));
    ans3 = net6Chars(indx);
    if(ans3 == 4 || ans3 == 18)
        if(a.matra == 1)
            ans3 = 4;
        else
            ans3 = 18;
        end
     %{   
    elseif(ans3 == 6 || ans3 == 7)     % dicision between 'cha' & 'chhaa'
        if(a.Lbar == 1)
            ans3 = 6;
        else
            ans3 = 7;
        end
       %} 
    end
        
else
    [val3 indx] = max(sim(net7, tmp));
    ans3 = net7Chars(indx);
    %{
    if(ans3 == 3 || ans3 == 14)     % dicision between 'ga' & 'murdhon-no'
        if(a.hRatio >= 3.05) %murdho-no
            ans3 = 14;
        else
            ans3 = 3;       %ga
        end
    end
    %}
end
%//////////////////////////////////////////////

a2 = [val1, val2, val3];
a3= [ans1, ans2, ans3];

if(ans1 == ans2)
    if(ans2 == ans3)
        percentage = max(a2);              % maximum match percentage is returned among 3nets
    else
        percentage = max(val1, val2);      % maximum match percentage is returned among 2 nets
    end
    result = ans1;

elseif(ans1 == ans3)
    result = ans1;
    percentage = max(val1, val3);
    
elseif(ans2 == ans3)
    result = ans2;
    percentage = max(val2, val3);
    
else
    
    [val indx] = max(a2);
    
    result = a3(indx);
    
    percentage = val;
end