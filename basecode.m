% This is the main code that runs and controls functions.  With this code
% The arduino stepper commands are controlled to move in x y positions
% Stored in position matrix, mat: columns of x and y positions

clear all

global arduino_object; % Create an Arduino object

arduino_object = arduino('com6', 'Uno');  %this is an internal program in matlab that creates a follower program in the Arduino that is controlled by the leader matlab program.   The first time this runs it will take a little longer as it will downlad the follower program into the arduino.

%Set and configure pins for arduino
global stepX dirX stepY dirY enPin;

stepX = 'D2';
dirX  = 'D5';
stepY = 'D3';
dirY  = 'D6';
enPin = 'D8';

configurePin(arduino_object,'D2','DigitalOutput')
configurePin(arduino_object,'D5','DigitalOutput')
configurePin(arduino_object,'D3','DigitalOutput')
configurePin(arduino_object,'D6','DigitalOutput')
configurePin(arduino_object,'D8','DigitalOutput')

% Set initial position, lower left hand corner
% Full range is approximately rangex = 875 rangey = 610
global currentx currenty;
currentx = 0;
currenty = 0;

% Establishes where backlash starts: 0 is negative, 1 is positive
% Note initial value only influences minor position of x, y start axis
global currentdirx currentdiry;
currentdirx = 1;
currentdiry = 1;

% Set initial backlash; number of steps after changing direciton in order for
% Visible movement to occur. This is a positive value
global backlashx backlashy;
backlashy = 8;
backlashx = 10;

global time;
time = 0; % This value of time pauses between movements. note because of arduino and matlab communication this can only increase the speed to a certain degree. 0 is full speed.


% Pull up list of x,y points to travel to, mat
% A seperate function should be put here.
% [mat]=dots();    

baseImage = imread('basepic.jpg');
baseImage = insertText(baseImage, [100, 400], "ME556", FontSize = 100, TextColor='black', BoxOpacity = 0);

bwImage = rgb2gray(baseImage);
numRows = 550;
numCols = 700;

axis([0, numCols, 0, numRows])


% Set start of drawing to bottom left of Etch-A-Sketch
curX = 0;
curY = numRows;

% Plotting
h = animatedline;

% Downsample image
bwImage = imresize(bwImage, [numRows numCols]);

scale = 0.4;
bwImage = imresize(bwImage, scale);

% Find areas under threshold to be drawn
[row, col] = find(bwImage < 150);
mat = [col row];
mat = mat.*(1 / scale);

%runs through each travel point using fuction moveitto.  This function
%relies on the global variables that are setup in this program and therefore cannot be run
%without the basecode.

% Calculate points to draw
pointsLeft = size(mat, 1);
disp(pointsLeft)
while pointsLeft > 0
    pointsLeft = pointsLeft - 1;
%     disp(pointsLeft);
    
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
    moveitto(curX, numRows - curY)
end

% pixelsLeft = smallrows * smallcols;
% for col = 1 : smallcols
%     for row = 1 : smallrows
%         val = double(bwImage(row, col));
%         width = interp1([255, 0], [0, colwidth], val);
%     
%         % Draw on figure
%         addpoints(h, (colwidth * col) + width, rowheight * (smallrows - row))
%         %moveitto((colwidth * col) + width, rowheight * (smallrows - row));
%         drawnow limitrate
%     end
% end

clear all; % Clears all variables, including most importantly "a" which shuts down the stepper motors