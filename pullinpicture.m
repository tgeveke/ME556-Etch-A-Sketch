% how to pull picture data into matlab and a strategy to accurately
% manipulate pixel size.

picture=imread("basepic.jpg");  % each pixel has a value for red, blue, and green

picturegray = rgb2gray(picture);  % Each pixel has one value for greyscale

%imshow(picturegray);  %shows picture

%note full range is approximately rangex=875 full rangey=610

%Size of pixel to enable gradiants of darkness to be created
pixelx=10;   %how large I want a pixel in the x direction
pixely=1;    %how large I want a pixel in the y direction


[sizey,sizex]=size(picturegray);
quantizepixels=zeros((sizey/pixely),(sizex/pixelx));  %Makes matrix of 0s that are filled in in the loop below
numberofpointsineach=pixelx*pixely;   %Number of points that are averaged to create new pixel
for i=1:sizey
    for ii=1:sizex
        quatnizeposx=ceil(ii/pixelx);  %determines location in quantizepixelmatrix
        quatnizeposy=ceil(i/pixely);   %determines location in quantizepixelmatriy
        
        quantizepixels(quatnizeposy,quatnizeposx)=quantizepixels(quatnizeposy,quatnizeposx)+(picturegray (i,ii)/numberofpointsineach);  %averages pixels and puts in large pixel
    end
end

quantizepixels=uint8(quantizepixels);
imshow(quantizepixels) %Shows a how image data has been resized.













%value=zeros(70,100);

%B = imresize(picturegray,.1);

%[sizey,sizex]=size(picturegray);
%for i=1:sizey
    %for ii=1:sizex
        
    %picturegray(i,ii)=200+picturegray(i,ii);
    
   % end
%end

%imshow(picturegray);
    

%picturegray(i,ii)=300*(sqrt(i^2+ii^2)/sqrt(700^2+1000^2))+picturegray(i,ii);