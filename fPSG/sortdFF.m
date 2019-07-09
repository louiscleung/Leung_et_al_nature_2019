function [sorteddFF, sortIdx] = sortdFF(dFF)
%
%This function sorted the rows of the dFF matrix by the mean, median or
%mode or starting value in ascending order
%
%Requirements: dFF
%
%Syntax:    sorteddFF = sortdFF(dFF)
%Input:     dFF dataset
%Output:    sorteddFF
%
%Author: Louis Leung / Stanford University / Department of Psychiatry and
%Behavioral Sciences
%
%Date created: Feb 17, 2015
%Last modified: Apr 3, 2015 added extra output of sortIdx


choice=menu('How do you want to sort dFF for heatmap?',...
    'By first timepoint', 'By Mean', 'By Median',...
    'By Mode', 'Leave unsorted (default)','position', 'center');

if choice==1
    [~, initialIdx] = sortrows(dFF, 1); %tilde discards the input as we don't need the actual values sorted
    sortIdx=initialIdx;

elseif choice==2
    [~, meanIdx] = sortrows(mean(dFF, 2)); 
    sortIdx=meanIdx;

elseif choice==3
    [~, medianIdx] = sortrows(median(dFF, 2)); 
    sortIdx=medianIdx;
    
elseif choice==4
    [~, modeIdx] = sortrows(mode(dFF, 2));
    sortIdx=modeIdx;
    
elseif choice==5
    sortIdx=[1:1:length(dFF(:,1))]';
end

%Sort dFF rows by new index Idx
sorteddFF=dFF(sortIdx, :);

end


%Initial fluorescence sort
% dFF=[1 2 3 98 5 6; 4 2 1 3 6 5 ; 8 8 8 8 4 5 ; 1 1 1 1 1 2; 4 5 6 7 8 9; 16 10 11 12 5 6; 2 2 2 2 2 2; 3 3 3 3 3 3];
% 
% %sort the rows of the dFF matrix in ascending order of first timepoint
% [initialSorted, initialIdx] = sortrows(dFF, 1);
% %sort through dFF with the row index medianIdx
% sorteddFF = dFF(initialIdx, :); 
% 
% %Median
% 
% %calculate the median for each row and generate ascending index
% [medianSorted, medianIdx] = sortrows(median(dFF, 2)); 
% %sort through dFF with the row index medianIdx
% sorteddFF = dFF(medianIdx, :); 
% 
% %Mean
% 
% %calculate the mean for each row and generate ascending index
% [meanSorted, meanIdx] = sortrows(mean(dFF, 2)); 
% %sort through dFF with the row index meanIdx
% sorteddFF = dFF(meanIdx, :); 
% 
% %Mode
% 
% %calculate the mode for each row and generate ascending index
% [modeSorted, modeIdx] = sortrows(mode(dFF, 2)); 
% %sort through dFF with the row index modeIdx
% sorteddFF = dFF(modeIdx, :); 
% 
% 
% 
% %---------------------------------
% %Code from when i was testing it.
% %dFF=[1 2 3 98 5 6; 4 2 1 3 6 5 ; 8 8 8 8 4 5 ; 1 1 1 1 1 2; 4 5 6 7 8 9; 16 10 11 12 5 6];
% %dFFmedian = median(dFF, 2); %calculate median by row
% %[medianSorted, medianIdx] = sortrows(dFFmedian);
% end

