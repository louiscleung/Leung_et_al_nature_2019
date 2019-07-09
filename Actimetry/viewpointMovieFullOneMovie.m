function [] = viewpointMovieFullOneMovie(excel,dirname,vpTime)
% viewpointMovieFullOneMovie.m
% Author: Louis C. Leung, Ph.D.
% Department of Psychiatry & Behavioral Sciences, Stanford University

%suppress common warnings
warning('off','MATLAB:mkdir:DirectoryExists');
warning('off','MATLAB:Images:initSize:adjustingMag');
warning('off','MATLAB:getframe:RequestedRectangleExceedsFigureBounds');
warning('off','MATLAB:audiovideo:avifile:indeo5NotFound');
warning('off','MATLAB:audiovideo:VideoWriter:mp4FramePadded');
%--------------------------------------------------------------------------
if nargin<1
    [excelCSV, dirname] = uigetfile2('.xls','Select the viewpoint generated excel file...');
else
    excelCSV = excel;
end

[~,baseFilename,~] = fileparts(excelCSV);
folderContents = dir(dirname);
fileList = extractfield(folderContents,'name');
dateList = extractfield(folderContents,'date');
searchTag = strcat(baseFilename,'_c001_');
actualFiles = strfind(fileList, searchTag);
numFiles = sum(~cellfun('isempty',actualFiles));
dateIdx = find(~cellfun(@isempty,actualFiles));

if numFiles == 0
    error('In selected folder there are no  viewpoint movies...');
end

for kk = 1:numFiles
    %Well 1-24
    indivName = sprintf('_c001_00%02d.avi', kk);
    filename = strcat(baseFilename,indivName);
    filenameIdx{kk} = filename;
end

%% Select a well
prompt = {'Which well do you want to extract movie from (1-24; 0 for full plate): ','What format for the movie: (MPEG-4/AVI/Best)', 'How fast for playback: ', 'Skip how many frames: ', 'How many frames do you want from each Viewpoint video file: (1800 is 1min, 0 will be whole thing)'};
    dlg_title = 'Set movie settings';
    num_lines = 1;
    default = {'1', 'AVI','30','30','1800'};
    answer = inputdlg(prompt,dlg_title,num_lines,default);
viewpointROI = str2double(cell2mat(answer(1)));
videoFormat = cell2mat(answer(2));
outputFrameRate = str2double(cell2mat(answer(3)));
skip = str2double(cell2mat(answer(4)));
subSection = str2double(cell2mat(answer(5)));
mkdir(dirname,'Exported Movies');

numofVids = numFiles;
%dateIdx = dateIdx;

switch videoFormat
    case 'MPEG-4'
        switch viewpointROI
            case num2cell(1:24)
                newfilename=sprintf('Well_%02d_combined.mp4',viewpointROI);
                fontSize = 8;
            case 0
                newfilename = 'Plate_combined.mp4';
                fontSize = 20;
        end
        %newfilename=strcat(newfilename,'_part_',num2str(ii),'.mp4');
        % create movie object
        cropMovieOut = VideoWriter([dirname,filesep,'Exported Movies',filesep,newfilename],'MPEG-4');
        % %100frames of 170x170 mp4 is 11kb
        %set frame rate before opening the object
        cropMovieOut.FrameRate = outputFrameRate; % 30 is default and also the rate recorded in viewpoint
        % set quality [0,100] for MPEG-4 and motion jpeg avi default 75
        cropMovieOut.Quality = 100;
    case 'AVI'
        switch viewpointROI
            case num2cell(1:24)
                newfilename=sprintf('Well_%02d_combined.avi',viewpointROI);
                fontSize = 8;
            case 0
                newfilename = 'Plate combined.avi';
                fontSize = 20;
        end
        %newfilename=strcat(newfilename,'_part_',num2str(ii),'.avi');
        % create movie object
        cropMovieOut = VideoWriter([dirname,filesep,'Exported Movies',filesep,newfilename],'Motion JPEG AVI');
        % %100frames of 170x170 mp4 is 11kb
        %set frame rate before opening the object
        cropMovieOut.FrameRate = outputFrameRate; % 30 is default and also the rate recorded in viewpoint
        % set quality [0,100] for MPEG-4 and motion jpeg avi default 75
        cropMovieOut.Quality = 100;
    case 'Best'
        switch viewpointROI
            case num2cell(1:24)
                newfilename=sprintf('Well_%02d_combined.avi',viewpointROI);
                fontSize = 8;
            case 0
                newfilename = 'Plate combined.avi';
                fontSize = 20;
        end
        %newfilename=strcat(newfilename,'_part_',num2str(ii),'.avi');
        % create movie object
        cropMovieOut = VideoWriter([dirname,filesep,'Exported Movies',filesep,newfilename],'Uncompressed avi');
        % %100frames of 170x170 mp4 is 11kb
        %set frame rate before opening the object
        cropMovieOut.FrameRate = outputFrameRate; % 30 is default and also the rate recorded in viewpoint
end

%general movie settings
cmap = gray(256);
%separate movies
open(cropMovieOut);

tic;
for ii = 1:numofVids

    movie = fullfile(dirname,filenameIdx{ii});
   
    vpMovie = VideoReader(movie);
    vprecordedRate = vpMovie.FrameRate;
    numofFrames = vpMovie.NumberOfFrames;
    
    %waitbar
    h = waitbar(0,'Opening Frame: ','position',[10 10 300 60]);
    hw=findobj(h,'Type','Patch');
    set(hw,'EdgeColor',[0 0.8 1],'FaceColor',[0 0.8 1]) % changes the color to green
    aw = get(findobj(h,'type','axes'));
    aw2 = aw.Title;
    set(aw2,'Position',[1 1.3 1]);
    set(aw2,'HorizontalAlignment','left');
    
    if subSection==0
        subSection = numofFrames;
    end
    %if one of the last files is less than chosen subSection then make it
    %equal
    if numofFrames < subSection
        subSection = numofFrames;
    end
    
    saveIdx = [1:skip:subSection];
    %initiate saving out index
    for jj = 1:subSection-1 %added -1 as get frequent errors
        %hh1 = figure('Position',[100 100 171 171]); %a.Height a.Width]);
        tempFrame = read(vpMovie,jj);
        firstgrayimage = rgb2gray(tempFrame);
        %If needed change the crop according to choice
        switch viewpointROI
            case {1}
                frame = firstgrayimage(50:220, 5:175);
            case {2}
                frame = firstgrayimage(50:220, 175:345);
            case {3}
                frame = firstgrayimage(50:220, 345:515);
            case {4}
                frame = firstgrayimage(50:220, 515:685);
            case {5}
                frame = firstgrayimage(50:220, 685:855);
            case {6}
                frame = firstgrayimage(50:220, 855:1024);
            case {7}
                frame = firstgrayimage(220:390, 5:175);
            case {8}
                frame = firstgrayimage(220:390, 175:345);
            case {9}
                frame = firstgrayimage(220:390, 345:515);
            case {10}
                frame = firstgrayimage(220:390, 515:685);
            case {11}
                frame = firstgrayimage(220:390, 685:855);
            case {12}
                frame = firstgrayimage(220:390, 855:1024);
            case {13}
                frame = firstgrayimage(390:560, 5:175);
            case {14}
                frame = firstgrayimage(390:560, 175:345);
            case {15}
                frame = firstgrayimage(390:560, 345:515);
            case {16}
                frame = firstgrayimage(390:560, 515:685);
            case {17}
                frame = firstgrayimage(390:560, 685:855);
            case {18}
                frame = firstgrayimage(390:560, 855:1024);
            case {19}
                frame = firstgrayimage(550:720, 5:175);
            case {20}
                frame = firstgrayimage(550:720, 175:345);
            case {21}
                frame = firstgrayimage(550:720, 345:515);
            case {22}
                frame = firstgrayimage(550:720, 515:685);
            case {23}
                frame = firstgrayimage(550:720, 685:855);
            case {24}
                frame = firstgrayimage(550:720, 855:1024);
            case {0}
                frame = firstgrayimage;
            otherwise
                frame = firstgrayimage;
        end
    %     imshow(frame); 
    %     videoframe = getframe;
        if any(jj==saveIdx)
            %faster way of implementing skip?
            annotation = strcat('Well_',num2str(viewpointROI),' at:',dateList(dateIdx(ii)));
            frame = insertText(frame,[10 5],annotation,'FontSize',fontSize,'TextColor','white','BoxOpacity',0);
            frame = frame(:,:,1);
            videoframe = im2frame(frame,cmap);
            writeVideo(cropMovieOut,videoframe);
            %display('Frame saved');
        end
        saveTime = toc/60; % convert to minutes
        waitbarMessage = sprintf('Opening Frame: %04d of %06d. Completed %02d/%2d vids.\nElapsed Time = %.2fmin.', jj, numofFrames, ii, numofVids, saveTime);
        waitbar(jj/subSection,h,waitbarMessage);
    end
    close(gcf);
    delete(h);
%     close(cropMovieOut);
    delete(vpMovie);
end
% if big one together
close(cropMovieOut);
movieSaveTime = toc;
message = sprintf('Time taken to generate movie frames = %.2fs.\n\nDone, check out the folder for results.',movieSaveTime);
msgbox(message);