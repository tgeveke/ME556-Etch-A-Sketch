clear all
close all

baseImage = imread('basepic.jpg');

scale = 0.3;

baseImage = imresize(baseImage, [500, 800]);
baseImage = imresize(baseImage, scale);
baseImage = baseImage * 10;

bwImage = rgb2gray(baseImage);
[numRows, numCols] = size(bwImage);

h = animatedline;
%axis([0, numCols, 0, numRows])
[row, col] = find(bwImage < 255);
mat = [row col];
mat = mat * 3;

pointsLeft = 2;
curX = numRows;
curY = 0;

while pointsLeft > 1
    numLeft = size(mat);
    pointsLeft = numLeft(1);
    disp(pointsLeft);
    
    index = dsearchn(mat, [curX curY]);
    closest_col = mat(index, 2); % Y
    closest_row = mat(index, 1); % X
   
    mat(index, :) = [];

    curX = closest_row;
    curY = closest_col;

    addpoints(h, curY/3, numRows - curX + 250)
    drawnow limitrate
end