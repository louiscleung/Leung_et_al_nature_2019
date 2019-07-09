% deflicker.m
% Author: Louis C. Leung, Ph.D.
% Stanford University

%% clean up
clc;
clear all;
close all;

dirname = []; 
mb_limit = 4096; 

%Get the location of the images you want to open
if isempty(dirname)
   dirname = uigetdir2('','Directory where your images are'); 
end

%Grab image sequence
dir_struct = dir(dirname);  
idx = [dir_struct.isdir]; 
dirnames = {dir_struct.name};   
filenames = dirnames(~idx);   
filenames = findimgs(filenames);  
info = imfinfo([dirname,filesep,filenames{1}]); 
imgsize = info.FileSize/1000000;    
stksize = size(filenames,2);
if imgsize*stksize > mb_limit   
    imgnum = floor(mb_limit/imgsize);  %allowable image number
    skip = floor(stksize/imgnum);
else   
    skip = 1;
end

%Put the virtual stack into an actual volume
info = imfinfo([dirname,filesep,filenames{1}]);    
switch info.BitDepth   
    case 8
        imgclass = 'uint8';
        ch_max = intmax('uint8');
    case 16
        imgclass = 'uint16';
        ch_max = intmax('uint16');
    %special case for avi converted tiffs
    case 24
        imgclass = 'uint8';
        ch_max = intmax('uint8');
    case 32
        imgclass = 'uint32';
        ch_max = intmax('uint32');
    otherwise
        imgclass = 'double';
        ch_max = 1;
end
% make new directory
mkdir(dirname, 'deFlickered');

%background mask
bkmask = false(info.Height, info.Width);
bkmask(5:55,5:55) = true;

%average value
desiredbkValue = 10; %some small number

%open firsttimepoint image
tInitial = imread([dirname,filesep,filenames{1}]);

%if it is RGB image, it needs conversion into uint8
[~, ~, noColorChannels] = size(tInitial);

%apply transform to bring average down or up.

%waitbar for motion correction:
hh = waitbar(0,'Deflickering Image: ','position',[10 40 420 60]);     

for t = 1:size(filenames, 2)  
    waitbar(t/(size(filenames,2)),hh,['Deflickering Image: ',filenames{t}]);
    tCurrent = imread([dirname,filesep,filenames{t}]);
    %if it is RGB image, you need to convert it to 8-bit color
    if noColorChannels == 3
        tCurrent = rgb2gray(tCurrent);
    end

    %Apply mask image (j)
    roi_data_tmp = tCurrent(bkmask); 
    %Measure mean intensity of mask (j)
    avebkdata = mean(roi_data_tmp);  

    if avebkdata > desiredbkValue
        deflkImg = tCurrent./(avebkdata/desiredbkValue);
    else
        deflkImg = tCurrent.*(desiredbkValue/avebkdata);
    end
    
     %Make sure bitdepth is correct here
    if info.BitDepth == 16;
        deflkImg = uint16(deflkImg);
    else
        deflkImg = uint8(deflkImg);
    end
    imwrite(deflkImg, [dirname, filesep, 'deFlickered', filesep, filenames{t}]);
end
close(hh);
