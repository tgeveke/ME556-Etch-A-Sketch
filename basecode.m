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
% Note initial value only influences minor position of x,y start axis
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
scale = 0.3;
baseImage = imresize(baseImage, scale);
baseImage = baseImage * (1/scale);
bwImage = rgb2gray(baseImage);
[numRows, numCols] = size(bwImage);

h = animatedline;
axis([0, 500, 0, 800])
[row, col] = find(bwImage < 255);
mat = [row col];
mat = mat * 3;

pointsLeft = 2;
curX = numCols;
curY = 0;

%runs through each travel point using fuction moveitto.  This function
%relies on the global variables that are setup in this program and therefore cannot be run
%without the basecode.

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

    addpoints(h, curY, numRows - curX + 350)
    drawnow limitrate

    moveitto(curY-15, numRows - curX + 350);

end

% Return home
moveitto(0, 0);

clear all; % Clears all variables, including most importantly "a" which shuts down the stepper motors