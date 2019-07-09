function [sorteddFF, dirname] = doubleChannelCaGUI(varargin)
%Ca2+ analysis of single channel acquisition with manual ROI selection 
%and background subtraction. Region select. Motion Correction. fEEG or 
%fECG plotting.
%
%Requirements: uigetdir2.m, findimgs.m, gain_slider.m, gain_slider.fig,
%polygeom.m, menu.m, drawRegionFree.m, prepareMaskArrayRegion.m,
%sortdFF.m, plotAVIlite.m and dftregistration.m
%
%Syntax:    [sorteddFF, dirname] = doubleChannelCaGUI()
%Input:     Various
%           
%Output:    'sorteddFF' = Matrix of DF/F values for ROIs (rows)
%across time (columns)
%           'dirname' = directory root
%           
%Author: Louis Leung / Stanford University / Department of Psychiatry and
%Behavioral Sciences
%
%Date created: Mar 24, 2015

clc;
clear all;
close all;


dirname = []; %Folder with nuclei images
dirname2 = []; %Folder with GCaMP images
mb_limit = 4096;

%Get nuclei images
%Get the location of the nuclei images you want to open
if isempty(dirname)
   dirname = uigetdir2('','Directory where your nuclei images are');
end

dir_struct = dir(dirname);  
idx = [dir_struct.isdir];  
dirnames = {dir_struct.name};  
filenames = dirnames(~idx);  
filenames = findimgs(filenames);
info = imfinfo([dirname,filesep,filenames{1}]);
imgsize = info.FileSize/1000000;  
stksize = size(filenames,2); 

if imgsize*stksize > mb_limit  
    imgnum = floor(mb_limit/imgsize); 
    skip = floor(stksize/imgnum);
else
    skip = 1;
end

%Get GCaMP filenames for later
%Get the location of the GCaMP images you want to open
if isempty(dirname2)
   dirname2 = uigetdir2('','Directory where your GCaMP images are');
end

dir_struct2 = dir(dirname2);  
idx2 = [dir_struct2.isdir];  
dirnames2 = {dir_struct2.name};
filenames2 = dirnames2(~idx2); 
filenames2 = findimgs(filenames2);

%Check image depth - just use the first nuclei image
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
%-------------------------------------------------------------------------
% Motion correct
% Ask if user has motionCorrected images for nuclei already or not?

choice = menu('Do you have motionCorrected Images already for nuclei?','Yep','Nope','position','center');
if choice==1
    % just move onto next step
else
    % make new directory
    mkdir(dirname, 'motionCorrected');

    %set dft pixel accuracy:
    dftPxAccuracy = 10; % 1/100 pixel default is 100

    %open firsttimepoint image
    tInitial = imread([dirname,filesep,filenames{1}]);

    %if it is RGB image, it needs conversion into uint8
    [~, ~, noColorChannels] = size(tInitial);

    if noColorChannels == 3
        tInitial = rgb2gray(tInitial);
    end

    %export initial image to new folder
    lo_hi = stretchlim(tInitial,[0 1]);
    tInitialSave = imadjust(tInitial, lo_hi);
    imwrite(tInitialSave, [dirname, filesep, 'motionCorrected', filesep, filenames{1}]);
    %2 dimension fft
    tInitialfft = fft2(tInitial);

    %from second timepoint on, compare to the initial and write a new file to
    %motionCorrected folder
    %waitbar for motion correction:
    hh = waitbar(0,'MotionCorrecting Image: ','position',[10 40 420 60]);     
    %Go through rest of images and apply motion correction
    for t = 2:size(filenames, 2) 
        waitbar(t/(size(filenames,2)),hh,['Registering Image: ',filenames{t}]);
        tCurrent = imread([dirname,filesep,filenames{t}]);
        %if it is RGB image, you need to convert it to 8-bit color
        if noColorChannels == 3
            tCurrent = rgb2gray(tCurrent);
        end

        tCurrentfft = fft2(tCurrent);
        [~, dft_temp] = dftregistration(tInitialfft, tCurrentfft, dftPxAccuracy);
        shiftedImage_temp = ifft2(dft_temp);
        %Make sure bitdepth is correct here
        if info.BitDepth == 16
            shiftedImage = uint16(shiftedImage_temp);
        else
            shiftedImage = uint8(shiftedImage_temp);
        end
        
        %export the file to new folder
        imwrite(shiftedImage, [dirname, filesep, 'motionCorrected', filesep, filenames{t}]);
    end
    close(hh);
end

% Ask if user has motionCorrected images for GCaMP already or not?

choice2 = menu('Do you have motionCorrected Images already for GCaMP?','Yep','Nope','position','center');
if choice2==1
    % just move onto next step
else
    % make new directory
    mkdir(dirname2, 'motionCorrected');

    %set dft pixel accuracy:
    dftPxAccuracy2 = 10; % 1/100 pixel default is 100

    %open firsttimepoint image
    tInitial2 = imread([dirname2,filesep,filenames2{1}]);

    %if it is RGB image, it needs conversion into uint8
    [~, ~, noColorChannels2] = size(tInitial2);

    if noColorChannels2 == 3
        tInitial2 = rgb2gray(tInitial2);
    end

    %export initial image to new folder
    lo_hi2 = stretchlim(tInitial2,[0 1]);
    tInitialSave2 = imadjust(tInitial2, lo_hi2);
    imwrite(tInitialSave2, [dirname2, filesep, 'motionCorrected', filesep, filenames2{1}]);
    %2 dimension fft
    tInitialfft2 = fft2(tInitial2);

    %from second timepoint on, compare to the initial and write a new file to
    %motionCorrected folder
    %waitbar for motion correction:
    hh2 = waitbar(0,'MotionCorrecting Image: ','position',[10 40 420 60]);     
    %Go through rest of images and apply motion correction
    for t = 2:size(filenames2, 2) 
        waitbar(t/(size(filenames2,2)),hh2,['Registering Image: ',filenames2{t}]);
        tCurrent2 = imread([dirname2,filesep,filenames2{t}]);
        %if it is RGB image, you need to convert it to 8-bit color
        if noColorChannels == 3
            tCurrent2 = rgb2gray(tCurrent2);
        end

        tCurrentfft2 = fft2(tCurrent2);
        [~, dft_temp2] = dftregistration(tInitialfft2, tCurrentfft2, dftPxAccuracy2);
        shiftedImage_temp2 = ifft2(dft_temp2);
        %Make sure bitdepth is correct here
        if info.BitDepth == 16;
            shiftedImage2 = uint16(shiftedImage_temp2);
        else
            shiftedImage2 = uint8(shiftedImage_temp2);
        end
        
        %export the file to new folder
        imwrite(shiftedImage2, [dirname2, filesep, 'motionCorrected', filesep, filenames2{t}]);
    end
    close(hh2);
end
%--------------------------------------------------------------------------
% Make a virtual stack with motion corrected images

%if third dimension of vstk will be over 4000 frames, consider just taking first
%3600 or you could run out of memory
if size(filenames,2) > 4000
    vstkendFrame = 3600;
else
    %Used(size(filenames,2)-1) in order to miss out last frame which may have
    %black pixelvalues of 0 because of pausing of imaging
    vstkendFrame = size(filenames,2)-1; 
end

vstk = zeros(info.Height,info.Width,vstkendFrame,imgclass);

%now go through each file 
h = waitbar(0,'Opening Image: ','position',[10 10 360 60]);

%read in required virtual stack for ROI selection
for l = 1:skip:vstkendFrame
    waitbar(l/vstkendFrame,h,['Opening Image: ',filenames{l}]);   %update progress
    vstk(:,:,l) = imread([dirname,filesep,'motionCorrected', filesep,filenames{l}]);
end
close(h);

%-------------------------------------------------------------------------
%Now select brain regions to analyse with standard deviation or max projection image
[L4, cropHeight, cropWidth] = drawRegionFree(vstk, ch_max, dirname, dirname2, info);

%Now prepare Mask Array based on L4 mask
%in donut ring formation
[nucleiMasksROI, num] = prepareMaskArrayRing(L4, dirname, dirname2, ...
                                             filenames, filenames2, ch_max, cropHeight, cropWidth);

%-------------------------------------------------------------------------
%Extract fluorescence signals from ROIs

%Initialise arrays
avedata = zeros(num, (size(filenames2,2)-1));

%now go through each file and extract out ROI meanvalues
h = waitbar(0,'Processing Image: ','position',[10 10 360 60]);
for i = 1:(size(filenames2,2)-1)  
    waitbar(i/(size(filenames2,2)-1),h,['Processing Image: ',filenames2{i}]);
    %Read in motion corrected image
    curr_img = imread([dirname2,filesep,'motionCorrected', filesep,filenames2{i}]);
    %Crop image to nuclei image size
    curr_img_cropped = curr_img(1:cropHeight, 1:cropWidth);
    for j = 1:num 
        %Apply mask image (j)
        roi_data_tmp = curr_img_cropped(nucleiMasksROI(:,:,j)); 
        %Measure mean intensity of mask (j)
        avedata(j,i) = mean(roi_data_tmp);  
    end
end
close(h)

% ------------------------------------------------------------------------
%Calculate dF/F

%Initialise background matrix
minvalues = zeros(1,size(avedata,1));
%for all ROIs, size of avedata row
for k=1:size(avedata,1); 
    %Measure the lowest mean intensity for each ROI
    minvalues(1,k)= min(avedata(k,:));
end
%Convert rows to columns
minvalues=minvalues'; 
%Populate each timepoint of an ROI with the min value
min_matrix=repmat(minvalues,1,size(avedata,2));

%DF/F is current ROI mean pixel value subtracted by mininmum value across
%time, divided by minimum value:
dFF = (avedata - min_matrix)./min_matrix;

%-------------------------------------------------------------------------
%Outputs: dFF movie and heatmap

%Option to sort dFF how you want heatmap displayed or leave unsorted
[sorteddFF, sortIdx] = sortdFF(dFF);

%save current workspace to analysis file
mkdir(dirname2, 'Analysis');

%Output dynamic dFF trace and plot other analysis outputs
outputChoice = menu('Which output config do you want?','fPSG','fECG heartrate','position','center');
if outputChoice==1
    plotCaImaging(sorteddFF, sortIdx, dirname2, cropHeight, cropWidth);
else
    plotECG(sorteddFF, sortIdx, dirname2, cropHeight, cropWidth);
end
%clear all;
close all;