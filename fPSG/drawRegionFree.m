function [L4, cropHeight, cropWidth] = drawRegionFree(vstk, ch_max, dirname, dirname2, info)

%Make manual selection of nuclei/neurons from standard deviation max image of nuclei or GCaMP
%time sequence to parse into prepareMaskArrayRing.m or
%prepareMaskArrayRegion.m, respectively.
%
%This version allows freehand mask selection
%
%Dependencies: Export_fig suite - see Downloads folder
%
%Syntax:    [L4, cropHeight, cropWidth] = drawRegionFree(vtsk,
%ch_max, dirname, info)
%Input:     'vstk' = virtual stack of image matrices
%           'ch_max' = depth of image
%           'dirname' = directory root
%           'info' = file information
%           
%Output:    'L4' = matrix containing ROI masks
%           'cropHeight' = dimensions of cropping
%           'cropWidth' = dimensions of cropping
%
%
%Author: Louis Leung / Stanford University / Department of Psychiatry and
%Behavioral Sciences
%
%Date created: Mar 24, 2015
%
%Last modified: Sep 18, 2015
%
%-------------------------------------------------------------------------
if ~isempty(dirname2)
    mkdir(dirname2,'Analysis');
end

defaultCropHeight = info.Height;
defaultCropWidth = info.Width./2;
%Ask user to crop and to what value
choice = menu('Do you want to crop the image?', 'Yes', 'No', 'position','center');
if choice==1
    prompt = {'Enter new width in pixels:','Enter new height in pixels:'};
    dlg_title = 'Define crop size';
    num_lines = 1;
    default = {num2str(defaultCropWidth), num2str(defaultCropHeight)};
    answer = inputdlg(prompt,dlg_title,num_lines,default);
    %convert first cell to a number
    cropWidth = str2double(cell2mat(answer(1)));
    %convert second cell to a number
    cropHeight = str2double(cell2mat(answer(2)));
else
    cropHeight = info.Height; %set full frame
    cropWidth = info.Width; %set full frame
end

%--------------------------------------------------------------------------
%Display the selection image
%full screen
k = get(0, 'screensize');
figure('units','pixels','position',[20 35 cropHeight cropWidth], ...
       'name','Please Select Your ROIs Here');

figure1 = gcf;

%Check BitDepth
if info.BitDepth == 16;
       img = im2uint16(std(im2single(vstk),[],3));
   else
       img = im2uint8(std(im2single(vstk),[],3));
end

set(gcf, 'position', k);

%crop image as selected
img=img(1:cropHeight, 1:cropWidth);

%generate the contrast image
lo_hi = stretchlim(img,[0 0.999]);   

img2 = imadjust(img,lo_hi);

imshow(img2);
axis off;
set(gca, 'position', [0 0 1 1]);
set(gcf, 'position', k);

%Save this image so later you can reference it.
img3 = img2;         
export_fig(img3, [dirname2,filesep,'Analysis',filesep,'Nuclei or GCaMP or GFP SD max.tif'], '-r300', '-a2');
%------------------------------------------------------------------------
% Make ROI mask selections on selection image
i = 1;              
j = 1;
roi_mask = zeros(cropHeight, cropWidth);
%ROI selection
while i==1             
    figure(figure1);
    roi_mask_tmp = imfreehand;
    roi_mask_tmp = createMask(roi_mask_tmp);
    
    %Draw the mask on the selection image to keep track
    img_tmp = img3;
    %Use logical selection to imprint the mask on the image
    img3(roi_mask_tmp) = ch_max;        
    imshow(img3);                        
    axis off;
    set(gca,'position',[0 0 1 1]);
    set(gcf, 'position', k);
    %Prompt the user for more ROI selection
    choice = menu('Do you want to select another ROI?','Yes - more please','No - no more','Oops - Undo','position','center');
    if choice==1
        %store masks
        roi_mask(:,:,j) = roi_mask_tmp; 
        j = j+1;       
    elseif choice==3 
        img3 = img_tmp;
        imshow(img3);
        axis off;
        set(gca,'position',[0 0 1 1]);
        set(gcf, 'position', k);
    else
        %store masks one last time
        roi_mask(:,:,j) = roi_mask_tmp; 
        %end the ROI selection process.
        i = 0;          
    end
end

%Export an image of the selected ROIs
export_fig(gcf, [dirname2,filesep,'Analysis',filesep,'Initial selected ROIs.tif'], '-r300', '-a2');
close(figure1);

%--------------------------------------------------------------------------
%initialise mask receiving matrix
bwmasks=false(cropHeight, cropWidth);
for k=1:size(roi_mask, 3);
    masks_temp=roi_mask(:,:,k);
    bwmasks=bwmasks + masks_temp;
end

%make sure no ROIs hit edge
L4=imclearborder(bwmasks);
end



