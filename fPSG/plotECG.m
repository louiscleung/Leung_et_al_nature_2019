function [] = plotECG(sorteddFF, sortIdx, dirname, cropHeight, cropWidth, varargin)
%This function generates several outputs useful in fECG analysis such as
%traces, histograms and IBI.
%
%Requirements: Signal Processing Toolbox (findpeaks)
%
%Export_fig(handle, 'filename.tif .jpg .pdf', '-rXXX(dpi)', '-mX(mag)',
%'-aX(aliasing 1-4)', '-nocrop','-cmyk(or '-rgb'),'-qXXX(compression 0-100)',
%-transparent);
%
%Syntax:    plotECG(sorteddFF, sortIdx, dirname, cropHeight,
%cropWidth)
%Input:     'sorteddFF' = the dFF data for the movie sorted by mean
%etc...
%           'sortIdx' = sort indexing
%           'dirname' = directory root
%           'cropWidth' = the width of the figure in pixels
%           'cropHeight' = the height of the figure in pixels
%
%Output:    Various into ./Analysis/
%
%Author: Louis C. Leung / Stanford University / Department of Psychiatry and
%Behavioral Sciences

%suppress common warnings
warning('off', 'MATLAB:getframe:RequestedRectangleExceedsFigureBounds');
warning('off', 'MATLAB:audiovideo:avifile:indeo5NotFound');
warning('off', 'MATLAB:LargeImage');

%% peakAnalysis
dFF=sorteddFF;
% detrend movement artefacts
[p,~,mu] = polyfit((1:numel(dFF(2:end))),dFF(2:end),6);
f_y = polyval(p,(1:numel(dFF(2:end))),[],mu);
ECG_Data = dFF(2:end) - f_y;
plot(ECG_Data)
print('-depsc','-r300',[dirname,filesep,'Analysis',filesep,'heartRhythmDetrended.eps']);
close(gcf)

[~, locs] = findpeaks(ECG_Data, 'MinPeakProminence',0.01); %, 'MinPeakHeight',0.05);
peakInterval = diff(locs);
figure;
xbins = 1:30;
hist(peakInterval, xbins)

print('-depsc','-r300',[dirname,filesep,'Analysis',filesep,'heartIntervalHistogram.eps']);
close(gcf)
save([dirname, filesep,'Analysis',filesep,'histogramStats.mat'],'peakInterval');

figure;
startHB = 2;
endHB = size(ECG_Data,2);

plot(ECG_Data(1,startHB:endHB),'k')
hold on
%plot(locs,ECG_Data(locs),'k^','markerfacecolor',[1 0 0]);
locsSubset = locs > startHB & locs < endHB;
plot(locs(locsSubset)-startHB+1,ECG_Data(locs(locs > startHB & locs < endHB)),'k^','markerfacecolor',[1 0 0]);
hold off
ylim([-1.5 1.5])
axis off
print('-depsc','-r300',[dirname,filesep,'Analysis',filesep,'heartRhythmPeaks.eps']);
close(gcf)

% heartrate stats
meanIBI = mean(diff(locs));
% 10hz, adjust divisor to your imaging rate.
heartRate = (1./(meanIBI/10)).*60; 

averageInterval = strcat('Average interval between heartbeats is: ',num2str(meanIBI*100),'ms');
averageHeartRate = strcat('Average heartRate is: ',num2str(heartRate),'beats per minute (bpm)');

%write some key stats to a text file
fid = fopen([dirname,filesep,'Analysis',filesep,'Stats.txt'],'wt');
fprintf(fid, '%s\n%s', averageInterval, averageHeartRate);
fclose(fid);

save([dirname,filesep,'Analysis',filesep,'fECG.mat']);
%close all; clear all;
