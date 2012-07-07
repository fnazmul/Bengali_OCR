%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                           %%%
%%%    This File Is Used To Create All The Neural Networks     %%%
%%%                                                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function createAllNets()

load trainingChars;           % Loading The Characters That Are Used To Train The Neural Networks

%%%__________________________________%%%
%%%   Creating Neural Network No. 1  %%%
%%%__________________________________%%%

[h w] = size(net1Chars);

alphabet=[];
tmp = [];
targets = zeros(w,w);         % There are W characters to ouput

a = allCharFeatures;

for i=1:w
    n = net1Chars(i);       % n now holds the value of the index in the allChars array
    
    tmp = [a(n).matra, a(n).Lbar, a(n).Rbar, a(n).centroid(1),a(n).centroid(2),...
           a(n).eNum, a(n).eccent, a(n).hRatio, a(n).vRatio,...
           a(n).parts(1,1:4), a(n).parts(2,1:4), a(n).parts(3,1:4), a(n).parts(4,1:4),...
           a(n).HPSkewness, a(n).VPSkewness, a(n).HPKurtosis, a(n).VPKurtosis]';
    
    %{
    tmp = [a(n).matra, a(n).Lbar, a(n).Rbar, a(n).centroid(1),a(n).centroid(2),...
           a(n).eNum, a(n).eccent, a(n).hRatio, a(n).vRatio,...
           a(n).parts(1,1:4), a(n).parts(2,1:4), a(n).parts(3,1:4), a(n).parts(4,1:4),...
           a(n).hProjection', a(n).vProjection',... 
           a(n).HPSkewness, a(n).VPSkewness, a(n).HPKurtosis, a(n).VPKurtosis]';
    %}   
    alphabet = [alphabet, tmp]; 
    targets(i,i) = 1;
end

S1 = 23;                    % No. of Neurons in the HIDDEN Layer   
S2 = w;                     % No. of Neurons in the OUTPUT Layer

net1 = newff(minmax(alphabet),[S1 S2],{'logsig' 'logsig'},'traingdx');   % creating neural net 1
net1.LW{2,1} = net1.LW{2,1}*0.01;
net1.b{2} = net1.b{2}*0.01;


net1.performFcn = 'sse';        % Sum-Squared Error performance function
net1.trainParam.goal = 0.1;     % Sum-squared error goal.
net1.trainParam.show = 20;      % Frequency of progress displays (in epochs).
net1.trainParam.epochs = 5000;  % Maximum number of epochs to train.
net1.trainParam.mc = 0.7;       % Momentum constant.


%%%__________________________________%%%
%%%   Creating Neural Network No. 2  %%%
%%%__________________________________%%%

[h w] = size(net2Chars);

alphabet=[];
tmp = [];
targets=zeros(w,w);         % There are W characters to ouput

a = allCharFeatures;

for i=1:w
    n = net2Chars(i);       % n now holds the value of the index in the allChars array
    
    tmp = [a(n).matra, a(n).Lbar, a(n).Rbar, a(n).centroid(1),a(n).centroid(2),...
           a(n).eNum, a(n).eccent, a(n).hRatio, a(n).vRatio,...
           a(n).parts(1,1:4), a(n).parts(2,1:4), a(n).parts(3,1:4), a(n).parts(4,1:4),...
           a(n).HPSkewness, a(n).VPSkewness, a(n).HPKurtosis, a(n).VPKurtosis]';
    
    alphabet = [alphabet, tmp];
    targets(i,i) = 1;
end

S1 = 15;
S2 = w;

net2 = newff(minmax(alphabet),[S1 S2],{'logsig' 'logsig'},'traingdx');   % creating neural net 2
net2.LW{2,1} = net2.LW{2,1}*0.01;
net2.b{2} = net2.b{2}*0.01;


net2.performFcn = 'sse';        % Sum-Squared Error performance function
net2.trainParam.goal = 0.1;     % Sum-squared error goal.
net2.trainParam.show = 20;      % Frequency of progress displays (in epochs).
net2.trainParam.epochs = 5000;  % Maximum number of epochs to train.
net2.trainParam.mc = 0.7;       % Momentum constant.


%%%__________________________________%%%
%%%   Creating Neural Network No. 3  %%%
%%%__________________________________%%%

[h w] = size(net3Chars);

alphabet=[];
tmp = [];
targets=zeros(w,w);         % There are W characters to ouput

a = allCharFeatures;

for i=1:w
    n = net3Chars(i);       % n now holds the value of the index in the allChars array
    
    tmp = [a(n).matra, a(n).Lbar, a(n).Rbar, a(n).centroid(1),a(n).centroid(2),...
           a(n).eNum, a(n).eccent, a(n).hRatio, a(n).vRatio,...
           a(n).parts(1,1:4), a(n).parts(2,1:4), a(n).parts(3,1:4), a(n).parts(4,1:4),...
           a(n).HPSkewness, a(n).VPSkewness, a(n).HPKurtosis, a(n).VPKurtosis]';
    
    alphabet = [alphabet, tmp];
    targets(i,i) = 1;
end

S1 = 4;                     % No. of Neurons in the HIDDEN Layer   
S2 = w;                     % No. of Neurons in the OUTPUT Layer

net3 = newff(minmax(alphabet),[S1 S2],{'logsig' 'logsig'},'traingdx');   % creating neural net 3
net3.LW{2,1} = net3.LW{2,1}*0.01;
net3.b{2} = net3.b{2}*0.01;


net3.performFcn = 'sse';        % Sum-Squared Error performance function
net3.trainParam.goal = 0.1;     % Sum-squared error goal.
net3.trainParam.show = 20;      % Frequency of progress displays (in epochs).
net3.trainParam.epochs = 5000;  % Maximum number of epochs to train.
net3.trainParam.mc = 0.7;       % Momentum constant.


%%%__________________________________%%%
%%%   Creating Neural Network No. 4  %%%
%%%__________________________________%%%

[h w] = size(net4Chars);

alphabet=[];
tmp = [];
targets=zeros(w,w);         % There are W characters to ouput

a = allCharFeatures;

for i=1:w
    n = net4Chars(i);       % n now holds the value of the index in the allChars array
    
    tmp = [a(n).matra, a(n).Lbar, a(n).Rbar, a(n).centroid(1),a(n).centroid(2),...
           a(n).eNum, a(n).eccent, a(n).hRatio, a(n).vRatio,...
           a(n).parts(1,1:4), a(n).parts(2,1:4), a(n).parts(3,1:4), a(n).parts(4,1:4),...
           a(n).HPSkewness, a(n).VPSkewness, a(n).HPKurtosis, a(n).VPKurtosis]';
    
    alphabet = [alphabet, tmp];
    targets(i,i) = 1;
end

S1 = 20;                    % No. of Neurons in the HIDDEN Layer   
S2 = w;                     % No. of Neurons in the OUTPUT Layer

net4 = newff(minmax(alphabet),[S1 S2],{'logsig' 'logsig'},'traingdx');   % creating neural net 4
net4.LW{2,1} = net4.LW{2,1}*0.01;
net4.b{2} = net4.b{2}*0.01;


net4.performFcn = 'sse';        % Sum-Squared Error performance function
net4.trainParam.goal = 0.1;     % Sum-squared error goal.
net4.trainParam.show = 20;      % Frequency of progress displays (in epochs).
net4.trainParam.epochs = 5000;  % Maximum number of epochs to train.
net4.trainParam.mc = 0.7;       % Momentum constant.


%%%__________________________________%%%
%%%   Creating Neural Network No. 5  %%%
%%%__________________________________%%%

[h w] = size(net5Chars);

alphabet=[];
tmp = [];
targets=zeros(w,w);         % There are W characters to ouput

a = allCharFeatures;

for i=1:w
    n = net5Chars(i);       % n now holds the value of the index in the allChars array
    
    tmp = [a(n).matra, a(n).Lbar, a(n).Rbar, a(n).centroid(1),a(n).centroid(2),...
           a(n).eNum, a(n).eccent, a(n).hRatio, a(n).vRatio,...
           a(n).parts(1,1:4), a(n).parts(2,1:4), a(n).parts(3,1:4), a(n).parts(4,1:4),...
           a(n).HPSkewness, a(n).VPSkewness, a(n).HPKurtosis, a(n).VPKurtosis]';
    
    alphabet = [alphabet, tmp];
    targets(i,i) = 1;
end

S1 = 15;                    % No. of Neurons in the HIDDEN Layer   
S2 = w;                     % No. of Neurons in the OUTPUT Layer

net5 = newff(minmax(alphabet),[S1 S2],{'logsig' 'logsig'},'traingdx');   % creating neural net 5
net5.LW{2,1} = net5.LW{2,1}*0.01;
net5.b{2} = net5.b{2}*0.01;


net5.performFcn = 'sse';        % Sum-Squared Error performance function
net5.trainParam.goal = 0.1;     % Sum-squared error goal.
net5.trainParam.show = 20;      % Frequency of progress displays (in epochs).
net5.trainParam.epochs = 5000;  % Maximum number of epochs to train.
net5.trainParam.mc = 0.7;       % Momentum constant.


%%%__________________________________%%%
%%%   Creating Neural Network No. 6  %%%
%%%__________________________________%%%

[h w] = size(net6Chars);

alphabet=[];
tmp = [];
targets=zeros(w,w);         % There are W characters to ouput

a = allCharFeatures;

for i=1:w
    n = net6Chars(i);       % n now holds the value of the index in the allChars array
    
    tmp = [a(n).matra, a(n).Lbar, a(n).Rbar, a(n).centroid(1),a(n).centroid(2),...
           a(n).eNum, a(n).eccent, a(n).hRatio, a(n).vRatio,...
           a(n).parts(1,1:4), a(n).parts(2,1:4), a(n).parts(3,1:4), a(n).parts(4,1:4),...
           a(n).HPSkewness, a(n).VPSkewness, a(n).HPKurtosis, a(n).VPKurtosis]';
    
    alphabet = [alphabet, tmp];
    targets(i,i) = 1;
end

S1 = 20;                    % No. of Neurons in the HIDDEN Layer   
S2 = w;                     % No. of Neurons in the OUTPUT Layer

net6 = newff(minmax(alphabet),[S1 S2],{'logsig' 'logsig'},'traingdx');   % creating neural net 6
net6.LW{2,1} = net6.LW{2,1}*0.01;
net6.b{2} = net6.b{2}*0.01;


net6.performFcn = 'sse';        % Sum-Squared Error performance function
net6.trainParam.goal = 0.1;     % Sum-squared error goal.
net6.trainParam.show = 20;      % Frequency of progress displays (in epochs).
net6.trainParam.epochs = 5000;  % Maximum number of epochs to train.
net6.trainParam.mc = 0.7;       % Momentum constant.


%%%__________________________________%%%
%%%   Creating Neural Network No. 7  %%%
%%%__________________________________%%%

[h w] = size(net7Chars);

alphabet=[];
tmp = [];
targets=zeros(w,w);         % There are W characters to ouput

a = allCharFeatures;

for i=1:w
    n = net7Chars(i);       % n now holds the value of the index in the allChars array
    
    tmp = [a(n).matra, a(n).Lbar, a(n).Rbar, a(n).centroid(1),a(n).centroid(2),...
           a(n).eNum, a(n).eccent, a(n).hRatio, a(n).vRatio,...
           a(n).parts(1,1:4), a(n).parts(2,1:4), a(n).parts(3,1:4), a(n).parts(4,1:4),...
           a(n).HPSkewness, a(n).VPSkewness, a(n).HPKurtosis, a(n).VPKurtosis]';
    
    alphabet = [alphabet, tmp];
    targets(i,i) = 1;
end

S1 = 20;                    % No. of Neurons in the HIDDEN Layer   
S2 = w;                     % No. of Neurons in the OUTPUT Layer

net7 = newff(minmax(alphabet),[S1 S2],{'logsig' 'logsig'},'traingdx');   % creating neural net 7
net7.LW{2,1} = net7.LW{2,1}*0.01;
net7.b{2} = net7.b{2}*0.01;


net7.performFcn = 'sse';        % Sum-Squared Error performance function
net7.trainParam.goal = 0.1;     % Sum-squared error goal.
net7.trainParam.show = 20;      % Frequency of progress displays (in epochs).
net7.trainParam.epochs = 5000;  % Maximum number of epochs to train.
net7.trainParam.mc = 0.7;       % Momentum constant.


%%%___________________________________%%%
%%%   Saving All Neural Networks      %%%
%%%       Into A File Named           %%%
%%%       trainedNeuralNets           %%%
%%%___________________________________%%%

save('neuralNets','net1','net2','net3','net4','net5','net6','net7');

%%%%%%%%%%%%%%%%%%%%     SAVED     %%%%%%%%%%%%%%%%%%%%%%%%%%
