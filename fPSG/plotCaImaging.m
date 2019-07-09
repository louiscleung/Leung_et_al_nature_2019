function [] = plotCaImaging(sorteddFF, sortIdx, dirname, cropHeight, cropWidth, varargin)
%This function generates several outputs useful in Ca2+ analysis such as
%traces, correlation and PCA plots etc...
%
%
%Requirements: absmax.m, absmin.m, export_fig.m, rasterplot_LL.m
%
%Export_fig(handle, 'filename.tif .jpg .pdf', '-rXXX(dpi)', '-mX(mag)',
%'-aX(aliasing 1-4)', '-nocrop','-cmyk(or '-rgb'),'-qXXX(compression 0-100)',
%-transparent);
%
%Syntax:    plotCaImaging(sorteddFF, sortIdx, dirname, cropHeight,
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
%
%Date created: Feb 2, 2015
%Last modified: Aug 18, 2017

%Suppress common warnings
warning('off', 'MATLAB:getframe:RequestedRectangleExceedsFigureBounds');
warning('off', 'MATLAB:audiovideo:avifile:indeo5NotFound');
warning('off', 'MATLAB:LargeImage');

%% Simple linegraph plot (and capture as an AVI)
%switch names
dFF=sorteddFF;

%set frame size for figure and video
videoHeight = cropHeight;
videoWidth = videoHeight.*(5/3); %aspect ratio 5:3

xtxt = 'Time (sec)';
ytxt = 'Ca2+ transients (DeltaF/F)';%'GFP Fluorescence (DeltaF/F)';

max_y = absmax(dFF);   %get the y maximum %can change to absolute value
min_y = absmin(dFF);   %get the y minimum
max_yminusfirst = ceil(absmax(dFF(:, 2:end)) + 1);

prompt3 = {'What was acquisition rate (Hz)','Enter new plot line width (px):','If you want colour plot, enter 1 here:','If you want an AVI, enter 1 here:','Enter new playback speed (fps):'};
    dlg_title3 = 'Set movie settings';
    num_lines3 = 1;
    default3 = {'2','0.15','0','0','20'};
    answer3 = inputdlg(prompt3,dlg_title3,num_lines3,default3);
    %convert first cell to a number
    FAR = str2double(cell2mat(answer3(1))); %Frame acquisition rate
    %convert second cell to a number
    plotlineWidth = str2double(cell2mat(answer3(2)));
    %toggle for black output or sorted colour mode
    colourPlot  = str2double(cell2mat(answer3(3)));
    %toggle for make an avi or not
    needAVIBool = str2double(cell2mat(answer3(4)));
    %convert third cell to a number
    playFPS = str2double(cell2mat(answer3(5)));
        
%Set a hsv colormap for each ROI used for all outputs
hsvcmap = hsv(size(dFF, 1)); 
%a sortedhsvcmap since we sort the data using sortIdx
%to be consistent with mask colours...
sortedhsvcmap=hsvcmap(sortIdx, :);

%Customise width and height/aspect ratio to suit numOfFrames and numOfROIs
figure('Position',[100 100 videoWidth*5 videoHeight/2]);
axis([0 size(dFF,2) min_y(1) max_yminusfirst]);

%Convert xlim to seconds
currXlbl = get(gca, 'XTickLabel');
currXlblnum = size(currXlbl,1);
frameNumber = (size(dFF,2))./(currXlblnum-1);
currXlbl = str2double(cellstr(currXlbl));
%divide by acquisition rate
xlabels = num2str(currXlbl./FAR);
set(gca, 'XTickLabel', xlabels);

%axis off; %Toggle: sometimes you only want the trace
hold all;
for k = 1:size(dFF,1) %each roi
    if (colourPlot)
        plot(dFF(k,1:size(dFF,2)), 'Color', sortedhsvcmap(k,:), 'linewidth',plotlineWidth);
    else
        %just black size(dFF,2)
        plot(dFF(k,1:size(dFF,2)), 'Color', 'k', 'linewidth',plotlineWidth);
    end
end

xlabel(xtxt,'fontsize',10, 'fontweight','b');  %label the x axis
ylabel(ytxt,'fontsize',10, 'fontweight','b');  %label the y axis
set(gcf, 'color', 'w');                 
%export plot
if(colourPlot)
    print('-dtiff','-r300',[dirname,filesep,'Analysis',filesep,'dFF_colour.tif']);
    %export_fig([dirname,filesep,'Analysis',filesep,'dFF_colour.tif'], ...
    %           '-r300','-nocrop','-a2');
else
    print('-dtiff','-r300',[dirname,filesep,'Analysis',filesep,'dFF_bw.tif']);
    %export_fig([dirname,filesep,'Analysis',filesep,'dFF_bw.tif'], '-r300','-nocrop','-a2');
end
close(gcf) 

%% Generate separated plots of dFF traces with defined times
% shared error bar plot of average dFF
figure('Position',[100 100 1000 600])
%mean
dFF_mean = nanmean(dFF,1);
%SD
dFF_SD = nanstd(dFF,1);
dFF_SEM = dFF_SD./((size(dFF,1)^0.5));
shadedErrorBar([],dFF_mean,dFF_SEM,{'linestyle','-','color','k','linewidth',0.5},0);
%axis off
set(gcf, 'color', 'w');
print('-depsc','-r300',[dirname,filesep,'Analysis',filesep,'dFF_shaded.eps']);
print('-dsvg','-r300',[dirname,filesep,'Analysis',filesep,'dFF_shaded.svg']);
close(gcf)

%Select from which frame to take the plot
startStretch = 1;
%Select when the plot should end
endStretch = size(dFF,2);

maxYparam = max_yminusfirst; %set max for Y scale
stretchParam = 0.03; %this parameter regulates the spacing between
                     %the traces. 0.03 - 0.10 works for most plots

%Black and white plot
figure
for sp= 1:size(dFF,1)
    hh=subplot(size(dFF,1),1,sp);
    if sp >= 1 && sp <= 10
        %Toggle if you want gray lines for ROIs 1-10 
        plot(dFF(sp,startStretch:endStretch),'Color','k'); 
        %plot(dFF(sp,startStretch:endStretch),'Color',[0.5 0.5 0.5]);
    else
        plot(dFF(sp,startStretch:endStretch),'Color','k');
    end
    plot(dFF(sp,startStretch:endStretch), 'Color', 'k');
    ax=get(hh,'Position');
    ax(4)=ax(4)+stretchParam;
    set(hh,'Position',ax);
    axis off
    ylim([0 maxYparam]);
end

print('-dtiff','-r300',[dirname,filesep,'Analysis',filesep,'Sep_Channels_BW.tif']);
close(gcf);

%Coloured plot
figure
for spsp= 1:size(dFF,1)
    hhhh=subplot(size(dFF,1),1,spsp);
    plot(dFF(spsp,startStretch:endStretch), 'Color', sortedhsvcmap(spsp,:));
    ax=get(hhhh,'Position');
    ax(4)=ax(4)+stretchParam;
    set(hhhh,'Position',ax);
    axis off
    ylim([0 maxYparam]);
end

print('-dtiff','-r300',[dirname,filesep,'Analysis',filesep,'Sep_Channels_Color.tif']);
close(gcf);

%---------------------------------------------------------------------------
%% ZScore analysis of ITI, Amplitude and CI
% zScore comparison of means - center the data
% To standardise comparison across brains and different imaging paradigms,
% you can center all dFF measurements to the mean of zero and standard
% deviation of 1.  Here, we take the default second arg of 0 so leave it []
% and are calculating across rows (ROIs) so need dim 2. Score of 1 is 1 sd
% from mean and -1 is score 1 sd below the mean and 0 is mean.

[ZscoreMatrix, meandFF, sigmadFF] = zscore(sorteddFF, [], 2);

ZscoreMatrixFlat = reshape(ZscoreMatrix,[],1);
%Set your spike threshold here
actionpotThresh = prctile(ZscoreMatrixFlat,10) + 1.5;

hold all;
%zscore plot
for m = 1:size(ZscoreMatrix,1)
    %just black
    plot(ZscoreMatrix(m,1:size(ZscoreMatrix,2)), 'Color', 'k', 'linewidth',0.5);
end

%Add a red line with the threshold
print('-depsc','-r300','-painters',[dirname,filesep,'Analysis',filesep,'zScore_plot.eps']);

line([0, size(ZscoreMatrix,2)], [actionpotThresh, actionpotThresh], 'Color', 'r', 'LineWidth', 0.5);

print('-depsc','-r300','-painters',[dirname,filesep,'Analysis',filesep,'zScore_plot_withThreshold.eps']);
print('-dsvg','-r300','-painters',[dirname,filesep,'Analysis',filesep,'zScore_plot_withThreshold.svg']);
close(gcf)

%detrended zscore plot
hold all;
for mm = 1:size(ZscoreMatrix,1)
    [p,~,mu] = polyfit((1:numel(ZscoreMatrix(mm,2:end))),ZscoreMatrix(mm,2:end),6); %set parameter above
    f_y = polyval(p,(1:numel(ZscoreMatrix(mm,2:end))),[],mu);
    detrendedZscoreMatrix(mm,:) = ZscoreMatrix(mm,2:end) - f_y;
    %just black
    plot(detrendedZscoreMatrix(mm,1:size(detrendedZscoreMatrix,2)), 'Color', 'k', 'linewidth',0.5);
end
print('-depsc','-r300','-painters',[dirname,filesep,'Analysis',filesep,'zScore_plot_detrended.eps']);
print('-dsvg','-r300','-painters',[dirname,filesep,'Analysis',filesep,'zScore_plot_detrended.svg']);
close(gcf)

%Separate trace plots

% change here to make time selection
beginSel = 1; 
endSel = size(dFF,2);  
stretchParam2 = 0.10; % a range of 0.03 -> 30 works dependent on ymin and ymax
%set yscale
ymin = -5;
ymax = 30; 

% separated zscore traces
figure
for o= 1:size(ZscoreMatrix,1)
    hh2=subplot(size(ZscoreMatrix,1),1,o);
    if o >= 1 && o <= 10
        %toggle if you want ROIs 1-10 traces to be gray
        plot(ZscoreMatrix(o,beginSel:endSel), 'Color', 'k');
        %plot(ZscoreMatrix(o,beginSel:endSel), 'Color', [0.5 0.5 0.5]);
    else
        plot(ZscoreMatrix(o,beginSel:endSel), 'Color', 'k');
    end
    ax2=get(hh2,'Position');
    ax2(4)=ax2(4)+stretchParam2;
    set(hh2,'Position',ax2);
    axis off
    ylim([ymin ymax]);
end
print('-depsc','-r300',[dirname,filesep,'Analysis',filesep,'zScore_plot_separate.eps']);
print('-dsvg','-r300',[dirname,filesep,'Analysis',filesep,'zScore_plot_separate.svg']);
close(gcf);

%careful detrendedZscore matrix has one less timepoint so can cause errors.
figure
for od= 1:size(detrendedZscoreMatrix,1)
    hh3=subplot(size(detrendedZscoreMatrix,1),1,od);
    if od >= 1 && od <= 10
        %toggle if you want ROIs 1-10 traces to be gray
        plot(detrendedZscoreMatrix(od,beginSel:endSel-1), 'Color', 'k');
        %plot(detrendedZscoreMatrix(od,beginSel:endSel-1), 'Color', [0.5 0.5 0.5]);
    else
        plot(detrendedZscoreMatrix(od,beginSel:endSel-1), 'Color', 'k');
    end
    ax3=get(hh3,'Position');
    ax3(4)=ax3(4)+stretchParam2; 
    set(hh3,'Position',ax3);
    axis off
    ylim([-1 ymax]);
end
print('-depsc','-r300',[dirname,filesep,'Analysis',filesep,'zScore_plot_sep_detrended.eps']);
print('-dsvg','-r300',[dirname,filesep,'Analysis',filesep,'zScore_plot_sep_detrended.svg']);
close(gcf);

%% Rasterplot
%Choose between raw dFF and zscore for producing a spike idx
outputChoice = menu('Do you need the raw dFF or zscore?','dFF','zscore','position','center');
if outputChoice==1
    %configure the threshold based on the dFF distribution of your experiment
    actionpotThresh = 3; %mean(mean(dFF,2,1);
    rasterdFF = dFF';
    raster_idx = rasterdFF > actionpotThresh;
else
    actionpotThresh = prctile(ZscoreMatrixFlat,10) + 1.5;
    rasterdFF = detrendedZscoreMatrix'; 
    raster_idx = rasterdFF > actionpotThresh;
end

rasterplot_LL(find(raster_idx),size(rasterdFF, 2),size(rasterdFF, 1));
axis off
set(gcf, 'color', 'w');
print('-depsc','-r300',[dirname,filesep,'Analysis',filesep,'zRasterplot.eps']);
close(gcf); 

%% Coherence index (CI)

%Calculate the probability that given 1 spike in one ROI, that another n ROI
%would also have a spike.

%Adjust here if there is a pre and post demarcation in experiment - i.e.
%time of treatment such as drug addition (changeTime2).
changeTime = 2;
changeTime2 = 2;

%cumAcPot has the combined total of spikes per time bin
cumAcPot = sum(raster_idx,2);

for iii = 1:size(raster_idx,2)
    acValues(iii) = iii;
    acCount(iii) = size(find(cumAcPot==iii),1);
    zpreCTCount(iii) = size(find(cumAcPot(1:changeTime,1)==iii),1);
    zpostCTCount(iii) = size(find(cumAcPot(changeTime2:end,1)==iii),1);
end

%Adjust threshold to 50% of ROIs active (i.e. 10 for 20 ROIs)
CIthreshold = 10; 

zn1 = sum(zpreCTCount(CIthreshold:size(raster_idx,2))); %how many spikes have more than 10 neurons cofiring
zN1 = sum(zpreCTCount); %how many spikes counted in the period
zn2 = sum(zpostCTCount(CIthreshold:size(raster_idx,2))); 
zN2 = sum(zpostCTCount);

%Normalise to total spike number recorded in imaging period
pre_CI = (zn1./zN1)*100;
post_CI = (zn2./zN2)*100;

%------------------------------------------------------------------------
%% Amplitude
rasterdFF2 = sorteddFF';

%pre
raster_idxpre = raster_idx;
raster_idxpre(changeTime2:end,:) = false;
selectedSpikeValues = rasterdFF2(raster_idxpre);

%post
raster_idxpost = raster_idx;
raster_idxpost(1:changeTime,:) = false;
selectedSpikeValues2 = rasterdFF2(raster_idxpost);

%average
preAmpMean = mean(selectedSpikeValues);
postAmpMean = mean(selectedSpikeValues2);

%Standard Deviation
preAmp_sd = nanstd(selectedSpikeValues);
postAmp_sd = nanstd(selectedSpikeValues2);

%sem
preAmp_SEM = preAmp_sd./(size(rasterdFF2,2)^0.5);
postAmp_SEM = postAmp_sd./(size(rasterdFF2,2)^0.5);

%percentage change
amplitudeChange = ((postAmpMean-preAmpMean)/preAmpMean)*100;

%-------------------------------------------------------------------------
%% Inter Ca2+ transient Interval (ITI)

preITI_vect = nan(size(raster_idxpre,1), size(raster_idxpre,2));
postITI_vect = nan(size(raster_idxpost,1), size(raster_idxpost,2));

% calculate differences for each ROI separately
for iti = 1:size(raster_idx,2)
%     CV_ISI_vect_temp=0.5*diff(find(abs(raster_idx(:,ii)))); 
    CV_ISI_vect_temp=diff(find(abs(raster_idxpre(:,iti)))); 
    preITI_vect(1:numel(CV_ISI_vect_temp),iti) = CV_ISI_vect_temp;
    CV_ISI_vect_temp1=diff(find(abs(raster_idxpost(:,iti))));
    postITI_vect(1:numel(CV_ISI_vect_temp1),iti) = CV_ISI_vect_temp1;
end

% filter out the non-gaps where logical 1s are consecutive as this is below
%nyquist sampling.
preITI_vect(preITI_vect < 2) = nan; 
postITI_vect(postITI_vect < 2) = nan;

prePeakIntervalsZ = reshape(preITI_vect,[],1);
prePeakIntervalsZ = prePeakIntervalsZ(~isnan(prePeakIntervalsZ)); 
%prePeakIntervalsZ = sort(prePeakIntervalsZ,1);
postPeakIntervalsZ = reshape(postITI_vect,[],1);
postPeakIntervalsZ = postPeakIntervalsZ(~isnan(postPeakIntervalsZ)); 
%postPeakIntervalsZ = sort(postPeakIntervalsZ,1);

% calculate differences from collated ROIs - use for single ROI that contains multiple independent neurons
%
% for iti = 1:size(raster_idx,2)
% %     CV_ISI_vect_temp=0.5*diff(find(abs(raster_idx(:,ii)))); 
%     CV_ISI_vect_temp=find(abs(raster_idxpre(:,iti))); 
%     preITI_vect(1:numel(CV_ISI_vect_temp),iti) = CV_ISI_vect_temp;
%     CV_ISI_vect_temp1=find(abs(raster_idxpost(:,iti))); 
%     postITI_vect(1:numel(CV_ISI_vect_temp1),iti) = CV_ISI_vect_temp1;
% end
% 
% prePeakIntervalsZ = reshape(preITI_vect,[],1);
% prePeakIntervalsZ = prePeakIntervalsZ(~isnan(prePeakIntervalsZ));
% prePeakIntervalsZ = sort(prePeakIntervalsZ,1);
% postPeakIntervalsZ = reshape(postITI_vect,[],1);
% postPeakIntervalsZ = postPeakIntervalsZ(~isnan(postPeakIntervalsZ));
% postPeakIntervalsZ = sort(postPeakIntervalsZ,1);
% 
% prePeakIntervalsZ = diff(prePeakIntervalsZ);
% postPeakIntervalsZ = diff(postPeakIntervalsZ);
% 
% %filter out the non-gaps where logical 1s are consecutive as this is below
% %nyquist sampling.
% prePeakIntervalsZ(prePeakIntervalsZ < 2) = nan;
% prePeakIntervalsZ = prePeakIntervalsZ(~isnan(prePeakIntervalsZ));
% postPeakIntervalsZ(postPeakIntervalsZ < 2) = nan;
% postPeakIntervalsZ = postPeakIntervalsZ(~isnan(postPeakIntervalsZ)); 

%mean
preITI = nanmean(prePeakIntervalsZ);
postITI = nanmean(postPeakIntervalsZ);

%Standard Deviation
preITI_sd = nanstd(prePeakIntervalsZ);
postITI_sd = nanstd(postPeakIntervalsZ);

%sem
preITI_SEM = preITI_sd./(size(raster_idx,2)^0.5);
postITI_SEM = postITI_sd./(size(raster_idx,2)^0.5);
    
%% Create Heatmap of dFF

%Heatmap variables

%generate green-only cmap
greencmap = zeros(64, 3);
greencmap(:,2) = 0:.0158:1; %did 1/64 to find ~0.0158;

HColor = greencmap; %Other good ones include 'redgreencmap', 'autumn' and 'winter'. 'parula' not available in R2011a
%HTitle = 'heatmap of dFF'
Hxaxis = 'Time';
Hyaxis = 'Single Neuron ROIs';
%draw heatmap with sort index labels for Rows 
h3 = HeatMap(dFF, 'standardize', 1, 'colormap', HColor, 'RowLabels', sortIdx);%, 'RowLabelsColor', num2str(hsvcmap));
%addTitle(h3, HTitle, 'FontSize',14, 'FontWeight', 'b');
addXLabel(h3, Hxaxis, 'FontSize',10, 'FontWeight', 'b');
addYLabel(h3, Hyaxis, 'FontSize',10, 'FontWeight', 'b');

plot(h3);

%add colorbar;
c = colorbar;
cpos = get(c, 'position');

% closer to axis
cpos(1) = 0.9200;
% align to bottom of axis
cpos(2) = 0.1100;
% width of color bar
cpos(3) = 0.0357;
% height of color bar
cpos(4) = 0.8150;

%change colorbar position
set(c, 'position', cpos);

%standardise the cmapping tick values of the colorbar
%set(c, 'YLim', [0 1]);
%set(c, 'color', [0 1 0]);
%set(c,'colororder', greencmap);
%change values for 0-1 rather than 1-64
set(c, 'YTickLabel', [1 2 3 4 5 6]); 

% HM = getframe(gcf); 
% HM_image = HM.cdata; %image data
% 
%Write a .tif
set(gcf, 'color', 'w');
print('-dtiff','-r300',[dirname,filesep,'Analysis',filesep,'Heatmap_dFF.tif']);
%export_fig([dirname,filesep,'Analysis',filesep,'Heatmap_dFF.tif'], '-r300','-nocrop','-a2'); 
close(gcf) %worked for figure 2
close(gcf) %worked for figure 1
close all force;

%% Correlation Coefficients
%correlations between ROIs
dFFinverse=(ZscoreMatrix)';
%correlation coefficient
[corr, corr_p] = corrcoef(dFFinverse);

%new custommaps
customgreenredcmap = zeros(64, 3);
customgreenredcmap(1:32,1) = 0:.0316:1;
customgreenredcmap = sort(customgreenredcmap, 'descend');
customgreenredcmap(33:64,2) = 0:.0316:1; %did 1/32 to find ~0.0316;

%Alternative colormap with more black in the map in case there is not
%enough contrast for the raeder.
customgreenredcmap2 = customgreenredcmap;
customgreenredcmap2(16:32,1) = 0;
customgreenredcmap2(33:49,2) = 0;

%produce heatmap
%if using unsorted dFF, use this. 
CC_HM = HeatMap(corr, 'Colormap', customgreenredcmap,'RowLabels', 1:length(corr), 'ColumnLabels', 1:length(corr));
%if sorteddFF, use this
%CC_HM = HeatMap(corr, 'standardize',1, 'Colormap', greenredcmap,'RowLabels',sortIdx, 'ColumnLabels',sortIdx);
CC_HM.addTitle('Neuron to Neuron Correlation', 'fontsize', 13);
% HM2.addXLabel('ROIs', 'fontsize', 12);
% HM2.addYLabel('ROIs', 'fontsize', 12);

h6 = plot(CC_HM);
set(h6,'DataAspectRatio', [1 1 1]);
set(h6, 'Position', [0.05 0.11 0.775 0.815]);
%set(h6, 'XLabel', 'ROIs');

%add colorbar;
c2 = colorbar;
cpos2 = get(c2, 'position');

% closer to axis
cpos2(1) = 0.755;
% align to bottom of axis
cpos2(2) = 0.1100;
% width of color bar
cpos2(3) = 0.0357;
% height of color bar
cpos2(4) = 0.8150;

%change colorbar position
set(c2, 'position', cpos2);

%label in 3 places, highly correlated, uncorrelated, higher anti-correlated
set(c2, 'YTick', [3 33 63]);
set(c2, 'YTickLabel', {'Highly anti-correlated', 'Uncorrelated', 'Highly correlated'});


% %Write a .tif
print('-dtiff','-r300',[dirname,filesep,'Analysis',filesep,'Heatmap_CorrCoef.tif']);
close(gcf) %worked for figure 2
close all force;
%-------------------------------------------------------------------------
%% singular value decomposition

% normalize the data
zdata = zscore(dFF,[],2);
datasub = bsxfun(@minus, zdata, mean(zdata)); %subtract mean from all values.

%reduce dimensionality
[U, S, V] = svd(datasub, 'econ');

%plot in 2D principal space 
%choose segment of timelapse to plot
startPoint = 1; %
endPoint = size(dFF,2); 
%set treatment point (i.e. drug addition)
treatmentPoint = changeTime2; %

% 2D plot -----------------------------------------------------------------
% moving average
smoothV = movmean(V,3,1);

%before treament
figure; hold on;
plot(smoothV(startPoint:treatmentPoint,1), smoothV(startPoint:treatmentPoint,2), '.','MarkerSize',8, 'color', [0.5 0.5 0.5]); %changed from gray crosses to dots
plot(smoothV(startPoint:treatmentPoint,1), smoothV(startPoint:treatmentPoint,2), 'color', [0.5 0.5 0.5]);
%after treatment
plot(smoothV(treatmentPoint:endPoint,1), smoothV(treatmentPoint:endPoint,2), '.','MarkerSize',8, 'color', 'k'); %changed from black crosses to dots
plot(smoothV(treatmentPoint:endPoint,1), smoothV(treatmentPoint:endPoint,2), 'k'); %changed from red line

%adjust depending on values
SVDscale = 20; 

axis([-0.01*SVDscale 0.01*SVDscale -0.01*SVDscale 0.01*SVDscale]);

xlabel('PC1'); 
ylabel('PC2'); 

set(gcf, 'color', 'w');

% annotate the start and end point
%start
plot(smoothV(startPoint,1), smoothV(startPoint,2), 'o', 'MarkerSize',6,'MarkerFaceColor','y', 'MarkerEdgeColor','k');
%end
plot(smoothV(endPoint,1), smoothV(endPoint,2), 'o', 'MarkerSize',6,'MarkerFaceColor','g','MarkerEdgeColor','k');

print('-depsc','-r300',[dirname,filesep,'Analysis',filesep,'SVD_plot_smooth.eps']);
print('-dsvg','-r300',[dirname,filesep,'Analysis',filesep,'SVD_plot_smooth.svg']);
close(gcf) 

% % 3d plot -----------------------------------------------------------------
% figure;
% hold on
% %before treatment
% plot3(smoothV(startPoint:treatmentPoint,1), smoothV(startPoint:treatmentPoint,2),smoothV(startPoint:treatmentPoint,3), '.','MarkerSize',8, 'color', [0.5 0.5 0.5]); 
% plot3(smoothV(startPoint:treatmentPoint,1), smoothV(startPoint:treatmentPoint,2),smoothV(startPoint:treatmentPoint,3), 'color', [0.5 0.5 0.5],'linewidth',0.5);
% %after treatment
% plot3(smoothV(treatmentPoint:end,1), smoothV(treatmentPoint:end,2),smoothV(treatmentPoint:end,3), '.', 'MarkerSize',8,'color', 'k'); 
% plot3(smoothV(treatmentPoint:end,1), smoothV(treatmentPoint:end,2),smoothV(treatmentPoint:end,3), 'k','linewidth',0.5); 
% 
% %start
% plot3(smoothV(startPoint,1), smoothV(startPoint,2), smoothV(startPoint,3), 'o', 'MarkerSize',6,'MarkerFaceColor','y', 'MarkerEdgeColor','k');
% %end
% plot3(smoothV(endPoint,1), smoothV(endPoint,2), smoothV(endPoint,3), 'o', 'MarkerSize',6,'MarkerFaceColor','g','MarkerEdgeColor','k');
% 
% view(45,26) %view(45,26) %position PC1 to left of PC2
% %axis([-0.06 0.06 -0.06 0.06 -0.06 0.06]);
% 
% axis([-0.01*SVDscale 0.01*SVDscale -0.01*SVDscale 0.01*SVDscale -0.01*SVDscale 0.01*SVDscale]);
% 
% xlabel('PC1'); 
% ylabel('PC2'); 
% zlabel('PC3');
% grid on;
% set(gcf, 'color', 'w');
% 
% print('-depsc','-r300',[dirname,filesep,'Analysis',filesep,'SVD_plot_smooth3D.eps']);
% print('-dsvg','-r300',[dirname,filesep,'Analysis',filesep,'SVD_plot_smooth3D.svg']);
% close(gcf) 

% %% Uncomment to watch SVD plot by timelapse
% 
% figure
% startPoint = 1;
% endPoint = size(dFF,2);
% hold on
% for i = startPoint:endPoint
%     plot(V(i,1), V(i,2), 'o');
%     plot(V(startPoint:i,1), V(startPoint:i,2), 'r-');
%     pause(0.001);
% end
% close(gcf);

%% Independent Component Analysis

% take 5 principal components to get rid of noise and take the top 3 independent components
[ICA_replot]=fastica(dFF, 'lastEig', 5, 'numOfIC', 3); 

figure;
for l = 1:size(ICA_replot,1)
    subplot(size(ICA_replot,1),1,l); plot(ICA_replot(l,:), 'color', 'k','linewidth',plotlineWidth);
    axis off
end
print('-depsc','-r300',[dirname,filesep,'Analysis',filesep,'ICA_plot.eps']);
print('-dsvg','-r300',[dirname,filesep,'Analysis',filesep,'ICA_plot.svg']);
close(gcf)

%% Build a DFF trace movie
if (needAVIBool)
    tic;
    h = waitbar(0,'Creating Plot(timepoint): ','position',[10 10 360 60]);
    for i = 1:size(dFF,2)  
        waitbar(i/size(dFF,2),h,['Creating Plot(timepoint): ',num2str(i)]);
        h2 = figure('Position',[100 100 round(videoWidth/1.5) round(videoHeight/1.5)]);
        axis([1 size(dFF,2) min_y(1) max_y(1)]);
        set(h2, 'color', 'w'); 
        currXlbl = get(gca, 'XTickLabel');
        currXlbl = str2double(cellstr(currXlbl));
        xlabels = num2str(currXlbl./FAR);
        set(gca, 'XTickLabel', xlabels);
        
        hold all
        for j = 1:size(dFF,1)
            if (colourPlot)
                plot(dFF(j,1:i), 'Color', sortedhsvcmap(j,:), 'linewidth', plotlineWidth);
            else
                %just black
                plot(dFF(j,1:i), 'Color', 'k', 'linewidth',plotlineWidth);
            end
        end
        xlabel(xtxt,'fontsize',10, 'fontweight','b'); 
        ylabel(ytxt,'fontsize',10, 'fontweight','b');  
                                                       
        M(i) = getframe(gcf);
        hold off
        close(h2)
    end
    close(h)
    elapsedTime = toc;
    
    %Convert to AVI:
    movie2avi(M,[dirname,filesep,'Analysis', filesep,'dFF_traces.avi'],'quality', 100, 'fps', playFPS);
    movieSaveTime = toc;
end
%-------------------------------------------------------------------------
%% Complete message with stats
% save out metadata
save([dirname, filesep,'Analysis',filesep,'metadata.mat']);

%to avoid error if avi is not accepted
if needAVIBool == 0
    elapsedTime=0;
    movieSaveTime=0;
end
message = sprintf('Time taken to generate movie frames = %.2fs.\nTime taken to save movie = %.2fs.\n\nDone, check out the Analysis folder for results.',elapsedTime,movieSaveTime);
msgbox(message);
clear all; close all;
