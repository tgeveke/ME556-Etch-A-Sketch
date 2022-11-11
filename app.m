clear all
close all

baseImage = imread('basepic.jpg');

baseImage = imresize(baseImage, 1);
bwImage = rgb2gray(baseImage);

threshold = [.1 .6]; % [low, high]
edgesImage = edge(bwImage, 'Canny', threshold);

inverted_edgesImage = imcomplement(edgesImage);

% Display
% imshow(inverted_edgesImage)

[numRows, numCols] = size(inverted_edgesImage);

h = animatedline;
axis([0, numCols, 0, numRows])
[row, col] = find(~inverted_edgesImage);
mat = [row col];

pointsLeft = 2;
curX = 0;
curY = 0;

while pointsLeft > 1
    numLeft = size(mat);
    pointsLeft = numLeft(1);
    disp(pointsLeft);
    
    index = dsearchn(mat, [curX curY]);
    closest_col = mat(index, 1);
    closest_row = mat(index, 2);
   
    mat = clearIndex(mat, index);

    curX = closest_col;
    curY = closest_row;

    addpoints(h, curY, numCols - curX)
    drawnow limitrate

end

% Functions
function inputMatrix = clearIndex(inputMatrix, index)
   inputMatrix(index, :) = [];
   return
end

function nearest_point = NearestPoint(matrix)
    [numRows, numCols] = size(matrix);
    for col = numCols - 1:numCols
        for row = 1:numRows
            val = matrix(col, row);
            if val == 1
                nearest_point = [row, col];
                return
            end
        end
    end
end