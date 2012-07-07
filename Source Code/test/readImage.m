% reads the image into a matrix

function readImage()%(imageName)

global binImg;

image = binImg;
%image = imread(imageName);      %read the image
image = imresize(image, [1024, NaN]);
level = graythresh(image);      %convert to binary
blackNwhite = im2bw(image,level);
binImg = ~blackNwhite;          %Binary Image
%rotImage();
%binImg = imrotate(binImg,-0.1);