function [nucleiMasksROI, num] = prepareMaskArrayRing(L4, dirname, ...
                                                  dirname2, filenames,filenames2, ch_max, cropHeight, cropWidth)
%
%Starting with nuclei masks manually selected, we will convert the ROIs  
%selection to the correct format to feed back into
%singleChannelCaGUI.m or doubleChannelCaGUI.m
%
%Auxiliary functions required: 
%
%Syntax:    [nucleiMasksROIs, num] = prepareMaskArrayRing()
%Input:     'L4' = matrix of pre-adjusted masks
%           'dirname' = directory root
%           'filenames' = filenames
%           'ch_max' = image depth
%           'cropHeight' = dimensions of cropped region
%           'cropWidth' = dimensions of cropped region
%
%Output:    'nucleiMasksROIs' = ROI masks for measuring Ca2+ fluorescence
%           'num' = number of ROI masks
%
%Author: Louis C. Leung, Ph.D. / Stanford University / Department of Psychiatry and
%Behavioral Sciences
%
%Date created: Feb 3, 2015
%Last modified: Mar 30, 2015
%%
%suppress warnings
warning('off', 'images:label2rgb:zerocolorSameAsRegionColor');

%import L4 from drawRegionFree.m into a bwlabel matrix
[ROIs, num] = bwlabel(L4);

%------------------------------------------------------------------------
%Populate a matrix of individuals ROIs (logical) from the ROIs image

%initialise array
ROI_mask_tmp = zeros(cropHeight, cropWidth);

%structural elements
SE_close = strel('disk', 1); %1 or 2 works well - change as
                             %appropriate to your magnification 

%For 1:n ROIs 
for n=1:num %since 1 is deleted, start at 2s found in ROIs image.
            %reset the tmp image
    ROIs_tmp = ROIs;
    %keep only ROI(n);
    Ldelete=find(ROIs ~=n);
    ROIs_tmp(Ldelete) = 0;
    Lconvert=find(ROIs==n);
    ROIs_tmp(Lconvert)= ch_max;
    ROI_mask_tmp = im2bw(ROIs_tmp); 
    %perimeterize the mask
    ROI_mask_tmp = bwperim(ROI_mask_tmp);
    ROI_mask_tmp = imdilate(ROI_mask_tmp, SE_close); 
    
    %add to array, added n-1 to start the indexing from 1.
    nucleiMasksROI(:,:,n) = ROI_mask_tmp;
end

%-------------------------------------------------------------------------
% Display final ROIs overlaid with nuclei and GCaMP frames

%import GCaMP image timepoint 1 and crop
J = imread(fullfile(dirname2, 'motionCorrected', filenames2{1}));
J_cropped = J(1:cropHeight, 1:cropWidth);

%import GCaMP last timepoint and crop
JLast = imread(fullfile(dirname2, 'motionCorrected', filenames2{size(filenames2,2)-1}));
JLast_cropped = JLast(1:cropHeight, 1:cropWidth);

%Repeat filtering from autoMaskSelect
Lconvert2=find(ROIs>1);
ROIs(Lconvert2)= ch_max;

%ROIs = imerode(ROIs, SE_close2); Optional
ROIs_perim = bwperim(ROIs);
ROIs_perim = imdilate(ROIs_perim, SE_close);

% Overlay transparent colour-coded Masks with original nuclei image
jj=1;
rimMask = zeros(cropHeight, cropWidth);
while jj <=size(nucleiMasksROI,3);
    rimMask = rimMask + nucleiMasksROI(:,:,jj);
    jj = jj+1;
end

[ROIsx, numx] = bwlabel(rimMask);

hsvcmap = hsv(numx);
K = label2rgb(ROIsx, hsvcmap, 'k', 'shuffle');

% use first frame
J_rgb = label2rgb(J_cropped, 'gray');

%incase the 255 causes weird white spots in image:
whitespotIdx = false(cropHeight, cropWidth,3); %initialse as an rgb logical index
whitespotIdx = J_rgb==255;
J_rgb(whitespotIdx)= 0;

alpha = 0.4; %set 0-1 for transparency
J_sum = J_rgb + alpha.*K;

figure; imshow(J_sum);
export_fig(J_sum, [dirname2,filesep,'Analysis',filesep,'nuclei_ColorROI_overlay.tif'], '-r300', '-a3');
print('-depsc','-r300',[dirname2,filesep,'Analysis',filesep,'nuclei_ColorROI_overlay.eps']);
close(gcf);

%other image overlays
overlay2=imoverlay(J_cropped, ROIs_perim, [.3 1 .3]);
overlay3=imoverlay(JLast_cropped, ROIs_perim, [.3 1 .3]);

figure; imshow(overlay2);
export_fig(overlay2, [dirname2,filesep,'Analysis',filesep,'first_GCaMP_with_mask.tif'], '-r300', '-a3');
close(gcf);

%check if ROIs shifted significantly during timelapse
figure; imshow(overlay3);
export_fig(overlay3, [dirname2,filesep,'Analysis',filesep,'last_GCaMP_with_mask.tif'], '-r300', '-a3');
close(gcf);
end