% tifftoepsConversion.m
% Author: Louis C. Leung, Ph.D.
% Stanford University

% Select a tif image
[file,dirname] = uigetfile('*.tif','Choose your .tif image');
I = imread(fullfile(dirname, file));
I_rgb = label2rgb(I, 'gray');
imshow(I);
[~,name,~] = fileparts(file);
%rename
newEpsName = strcat(name,'.eps');
%export
print('-depsc','-r300',[dirname,filesep,newEpsName]);
close all;
