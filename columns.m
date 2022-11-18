clear all
close all

baseImage = imread('mona.jpg');
bwImage = rgb2gray(baseImage);
numRows = 500;
numCols = 800;

% Set start of drawing to bottom left of Etch-A-Sketch
curX = 0;
curY = numRows;

% Plotting
h = animatedline;

% Downsample image
colwidth = 10;
smallcols = (numCols / colwidth);
rowheight = 12;
smallrows = (numRows / rowheight);
bwImage = imresize(bwImage, [smallrows smallcols]);

axis([0, numCols, 0, numRows])

pixelsLeft = smallrows * smallcols;
for col = 1 : smallcols
    for row = 1 : smallrows
        val = double(bwImage(row, col));
        width = interp1([255, 0], [0, colwidth], val);
    
        % Draw on figure
        %addpoints(h, (colwidth * col), rowheight * (smallrows - row) + rowheight)
        addpoints(h, (colwidth * col) + width, rowheight * (smallrows - row))

        drawnow limitrate
    end
end
