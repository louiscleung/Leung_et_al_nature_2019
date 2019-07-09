function [newfilenames] = findimgs(filenames)
%This little function takes a list of filenames, as output by the dir
%function, and finds files that are supported by imread.
%Synatax:   [newfilenames] = findimgs(filenames)
%Input:     filenames = name of files in a cell row vector, e.g.,
%           {file.tif,file2.tif,metadata.txt...}
%           Note: By default the function supports these file extensions:
%           .tif,.tiff,.jpg,.png,.gif
%           if you want more add it.  It's easy.
%Output:    newfilenames = the names of image files in a cell row vector,
%           e.g., {file.tif,file2.tif}

%first look for all the extensions
idx1 = strfind(filenames,'.tif');
idx2 = strfind(filenames,'.jpg');
idx3 = strfind(filenames,'.png');
idx4 = strfind(filenames,'.gif');
idx5 = strfind(filenames,'.tiff');

%put the indexes together
idx_all = vertcat(idx1,idx2,idx3,idx4,idx5);

%now go through each file and remove the none image files
itr = 1;    %independent file pointer
newfilenames = {};
for i = 1:size(filenames,2)
    if ~isempty(cell2mat(idx_all(:,i)))     %if this file is a supported type
        newfilenames{itr} = filenames{i};   %keep filename
        itr = itr+1;    %iterate up
    end
end