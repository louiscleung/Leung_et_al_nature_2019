function [] = avitomp4Convert();
% avitomp4Convert.m
% Author: Louis C. Leung, Ph.D.
% Stanford University

[filename, dirname] = uigetfile2('.avi','Select the avi file...');

movie = fullfile(dirname,filename);

%Movie = VideoReader(movie);
%vprecordedRate = Movie.FrameRate;
%numofFrames = Movie.NumberOfFrames;

%shorter way

avimovie = VideoReader(movie);
newfilename = strcat(filename,'.mp4');
mp4movie = VideoWriter([dirname,filesep,newfilename],'MPEG-4');
mp4movie.FrameRate = 20;%20
mp4movie.Quality = 100; %was 100 - you can also reduce size using handbrake between quality settings 20-23
open(mp4movie);
for i = 1:avimovie.NumberOfFrames
	img = read(avimovie,i);
    %img = imrotate(img,90);
	writeVideo(mp4movie,img);
end
close(mp4movie);