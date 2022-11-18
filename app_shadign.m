clear all
close all

baseImage = imread('basepic.jpg');
bwImage = rgb2gray(baseImage);
numRows = 500;
numCols = 800;
imresize(bwImage, [500 800])


% Downsample image
scale = 0.25;
bwImage = imresize(bwImage, scale);

% Find areas under threshold to be drawn
[row, col] = find(bwImage < 150);
mat = [col row];
mat = mat.*(1 / scale);

% Set start of drawing to bottom left of Etch-A-Sketch
curX = 0;
curY = numRows;

% Plotting
h = animatedline;
axis([0, numCols, 0, numRows])

% Calculate points to draw
pointsLeft = size(mat, 1);
while pointsLeft > 0
    pointsLeft = pointsLeft - 1;
    disp(pointsLeft);
    
    % Find index of closest (x, y) pair in mat
    index = dsearchn(mat, [curX curY]);

    % Set current point to index
    curX = mat(index, 1);
    curY = mat(index, 2);
   
    % Remove index to be drawn
    mat(index, :) = [];

    % Draw on figure
    addpoints(h, curX, numRows - curY)
    drawnow limitrate
end