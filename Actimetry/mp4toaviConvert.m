function [] = mp4toaviConvert();
% mp4toaviConvert.m
% Author: Louis C. Leung, Ph.D.
% Stanford University

[filename, dirname] = uigetfile2('.mp4','Select the mp4 file...');

movie = fullfile(dirname,filename);

% %shorter way
% 
% mp4movie = VideoReader(movie);
% newfilename = strcat(filename,'.avi');
% avimovie = VideoWriter([dirname,filesep,newfilename],'Motion JPEG AVI');
% avimovie.FrameRate = 10;
% avimovie.Quality = 100;
% open(avimovie);
% for i = 1:mp4movie.NumberOfFrames
% 	img = read(mp4movie,i);
% 	writeVideo(avimovie,img);
% end
% close(avimovie);

% Longer way

Movie = VideoReader(movie);
vprecordedRate = Movie.FrameRate;
numofFrames = Movie.NumberOfFrames;

% % create movie object
newfilename = strcat(filename,'.avi');
cropMovieOut = VideoWriter([dirname,filesep,newfilename],'Motion JPEG AVI');

%set frame rate before opening the object
cropMovieOut.FrameRate = 10; % 30 is default and also the rate recorded in viewpoint
% set quality [0,100] for MPEG-4 and motion jpeg avi default 75
cropMovieOut.Quality = 50;

%general movie settings
cmap = gray(256);
%separate movies
open(cropMovieOut);
for ii = 1:numofFrames
	tempFrame = read(Movie,ii);
	tempFrame = tempFrame(:,:,1); %change if 3 layered
	videoframe = im2frame(tempFrame,cmap);
	writeVideo(cropMovieOut,videoframe);
end
close(cropMovieOut);
delete(Movie)
