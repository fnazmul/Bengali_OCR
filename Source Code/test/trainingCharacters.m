%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                         %%%
%%%    All Training Charachter Are Defined In This File     %%%
%%%                                                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function trainingCharacters()

%load letters;
%load upChars;

%totalChars = size(letters,3);

allCharFeatures = all_f();


allCharFeatures = allCharFeatures';         % Making 'allCharFeatures' a Column Vector



net1Chars = [1, 4, 6, 7, 8, 11, 12, 13, 15, 17, 19, 21, 22, 23, 24];    % Index Of The characters In The allCharFeatures Array To Train NN 1
net2Chars = [2, 3, 5, 9, 10, 14, 16, 18, 20, 25];                       % Index Of The characters In The allCharFeatures Array To Train NN 2

net3Chars = [6, 7, 13];                                                 % Index Of The characters In The allCharFeatures Array To Train NN 3
net4Chars = [1, 2, 3, 4, 9, 10, 14, 16, 18, 19, 20, 22, 24];            % Index Of The characters In The allCharFeatures Array To Train NN 4
net5Chars = [5, 7, 8, 11, 12, 15, 17, 21, 23, 25];                      % Index Of The characters In The allCharFeatures Array To Train NN 5

net6Chars = [1, 3, 4, 5, 6, 7, 9, 10, 11, 18, 20, 22, 24];              % Index Of The characters In The allCharFeatures Array To Train NN 6
net7Chars = [2, 3, 8, 12, 13, 14, 15, 16, 17, 19, 21, 23, 25];          % Index Of The characters In The allCharFeatures Array To Train NN 7


%%%------------------------------------%%%
%%%        Saving The Variables        %%%
%%%------------------------------------%%%


save ('trainingChars', 'net1Chars', 'net2Chars', 'net3Chars', 'net4Chars', 'net5Chars', 'net6Chars', 'net7Chars','allCharFeatures');


%%%%%%%%%%       SAVED into file 'trainingChars'   %%%%%%%%%%%%%%%%