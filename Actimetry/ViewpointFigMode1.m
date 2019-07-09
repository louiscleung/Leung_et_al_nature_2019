function [] = ViewpointFigMode1(dirname,excel,needTotalBoxBool,vpWake,...
                                vpSleep,vpTime,vpBoxdata,rowLabels,...
                                d2n,n2d,outputdir, threehrBool, oneDayBool)
%Row Colors
%wake
rowColors{1,1} = [0.0,0.0,0.5];
%Sleep
rowColors{1,2} = [0.7,0.0,0.0];
%Patch color
patchColor = [1 1 0.8];

if threehrBool == 1;
    yscale = 18;
    yscale2 = 1;
else
    yscale = 150;
    yscale2 = 10;
end

%% Time of treatments
startTreat2 = min(find((all(isnan(vpWake),2))));
endTreat2 = max(find((all(isnan(vpWake),2))));
%nanmean,SD and SEM All
vpWake = vpWake(:,1:24);
vpSleep = vpSleep(:,1:24);
vpWakeM = nanmean(vpWake, 2);
vpSleepM = nanmean(vpSleep, 2);
std_1 = nanstd(vpWake')';
std_2 = nanstd(vpSleep')';
vpWakeS = std_1./sqrt(size(vpWake,2));
vpSleepS = std_2./sqrt(size(vpSleep,2));
%Zscoring All
vpWakeZ = bsxfun(@rdivide, bsxfun(@minus, vpWake, nanmean(vpWake,1)), nanstd(vpWake,0,1));
vpSleepZ = bsxfun(@rdivide, bsxfun(@minus, vpSleep, nanmean(vpSleep,1)), nanstd(vpSleep,0,1));
vpWakeZM = nanmean(vpWakeZ,2);
vpSleepZM = nanmean(vpSleepZ,2);
%
vpBoxarranged = vpBoxdata(1:24,:);
%% One big combined figure
hh = figure('Position', [10, 10, 1500, 1500]);
%text(1,1,deepestFolder);
%change size

subplot(6,4,1) %boxplot control wake
b1 = boxplot(vpWake);
%boxplot properties
set(b1(1,:),'LineStyle','-','Color',rowColors{1,1}); %set the top line to color of row
set(b1(2,:),'LineStyle','-','Color',rowColors{1,1}); %set the top line to color of row
set(b1(3,:),'Color',rowColors{1,1}); %Top line color
set(b1(4,:),'Color',rowColors{1,1}); %Bottom line color
set(b1(5,:),'Color',rowColors{1,1}); %Box line color
set(b1(6,:),'Color',rowColors{1,1}); %median line color
set(b1(7,:),'Visible','off'); %Turn off outliers
%ax properties
bb1 = findobj(gca,'Tag','Box');
for j=1:length(bb1)
     patch(get(bb1(j),'XData'),get(bb1(j),'YData'),rowColors{1,1},'FaceAlpha',.3);
end
set(gca,'XTick',[])
set(gca,'XColor','w')
set(gca,'XTickLabel',{' '})
axis(gca,[0 (size(vpWake,2)+1) 0 yscale])
ylabel('Activity (sec/min)')

boxtitle = ('Wake Activity');
title(boxtitle)

subplot(6,4,2)
[~,condVal,~] = fileparts(excel);
text(0,0.5,{dirname,condVal});
axis off

subplot(6,4,5) %boxplot Control Sleep
%remove zeros from boxplot for sleep so you can see variation whenever
%sleep is actually counted
nanviewpointData2 = vpSleep;
nanviewpointData2(nanviewpointData2==0) = nan;
b2 = boxplot(nanviewpointData2);
%boxplot properties
set(b2(1,:),'LineStyle','-','Color',rowColors{1,2}); %set the top line to color of row
set(b2(2,:),'LineStyle','-','Color',rowColors{1,2}); %set the top line to color of row
set(b2(3,:),'Color',rowColors{1,2}); %Top line color
set(b2(4,:),'Color',rowColors{1,2}); %Bottom line color
set(b2(5,:),'Color',rowColors{1,2}); %Box line color
set(b2(6,:),'Color',rowColors{1,2}); %median line color
%set(b2(7,:),'Visible','off'); %Turn off outliers
%ax properties
bb2 = findobj(gca,'Tag','Box');
for j=1:length(bb2)
    patch(get(bb2(j),'XData'),get(bb2(j),'YData'),rowColors{1,2},'FaceAlpha',.3);
end
set(gca,'XTick',[])
set(gca,'XColor','w')
set(gca,'XTickLabel',{' '})
axis(gca,[0 (size(vpSleep,2)+1) 0 yscale2])
ylabel('Sleep (min/10min)')

boxtitle2 = strcat('Sleep Duration');
title(boxtitle2)

subplot(6,4,6)
text(0,0.5,rowLabels(1,1));
axis off
%% Shaded graphs
%subplot(6,4,[9,10])
if threehrBool == 1;
    subplot(6,4,9)
elseif (oneDayBool == 1)
    subplot(6,4,9)
else
    subplot(6,4,[9,10])
end

%catch cases where there is only one column/sample
if (vpWakeS==std_1)
    plot(vpWakeM,'linewidth',0.5, 'color', 'k');
else
    shadedErrorBar([],vpWakeM',vpWakeS,'-k',0);
end
hold on
if ~isempty(startTreat2)
    patch('Faces',[1 2 3 4],'Vertices',[startTreat2 0; endTreat2 0; endTreat2 yscale; startTreat2 yscale],...
          'FaceColor',patchColor, 'EdgeColor',patchColor,'FaceAlpha',0.3);
end
%plot empty triangle for day and filled for night
for aa = 1: size(d2n,1)
    plot(d2n(aa),yscale,'v','Color','k','MarkerFaceColor','k'); %filled night
end
for bb = 1:size(n2d,1)
    plot(n2d(bb),yscale,'v','Color','k'); %empty day
end
%plot triangle for treatment in a 3hr drug
if threehrBool == 1;
    plot(60, yscale, 'v','color','r','MarkerFaceColor','r');
end
set(gca,'XTick',[])
set(gca,'XColor','w')
axis(gca, [0 inf 0 yscale])

ylabel('Abs. Activity (sec/10min)')

if threehrBool == 1;
    subplot(6,4,11)
elseif (oneDayBool == 1)
    subplot(6,4,11)
else
    subplot(6,4,[11,12])
end
if (vpSleepS==std_2)
    plot(vpSleepM,'linewidth',0.5, 'color', 'k');
else
    shadedErrorBar([],vpSleepM',vpSleepS,'-k',0);
end
hold on
if ~isempty(startTreat2)
    patch('Faces',[1 2 3 4],'Vertices',[startTreat2 0; endTreat2 0; endTreat2 yscale2; startTreat2 yscale2],...
          'FaceColor',patchColor, 'EdgeColor',patchColor,'FaceAlpha',0.3);
end
%plot empty triangle for day and filled for night
for aa = 1: size(d2n,1)
    plot(d2n(aa),yscale2,'v','Color','k','MarkerFaceColor','k'); %filled night
end
for bb = 1:size(n2d,1)
    plot(n2d(bb),yscale2,'v','Color','k'); %empty day
end
%plot triangle for treatment in a 3hr drug
if threehrBool == 1;
    plot(60, yscale2, 'v','color','r','MarkerFaceColor','r');
end
set(gca,'XTick',[])
set(gca,'XColor','w')
%daspect(gca,[aspectratio,1,1])
axis(gca, [0 inf 0 yscale2])

ylabel('Abs. Sleep (min/10min)')

%%Combined plot
if threehrBool == 1;
    subplot(6,4,13)
else
    subplot(6,4,[13,14])
end

plot(vpWakeM,'linewidth',0.75, 'color', 'k');
hold on
if ~isempty(startTreat2)
    patch('Faces',[1 2 3 4],'Vertices',[startTreat2 0; endTreat2 0; endTreat2 yscale; startTreat2 yscale],...
          'FaceColor',patchColor, 'EdgeColor',patchColor,'FaceAlpha',0.3);
end
%plot empty triangle for day and filled for night
for aa = 1: size(d2n,1)
    plot(d2n(aa),yscale,'v','Color','k','MarkerFaceColor','k'); %filled night
end
for bb = 1:size(n2d,1)
    plot(n2d(bb),yscale,'v','Color','k'); %empty day
end
%plot triangle for treatment in a 3hr drug
if threehrBool == 1;
    plot(60, yscale, 'v','color','r','MarkerFaceColor','r');
end
set(gca,'XTick',[])
set(gca,'XColor','w')
axis(gca, [0 inf 0 yscale])
lx1 = legend (rowLabels(1,1),'Location','northeast');
set(lx1,'FontSize',4)
legend('boxoff');
ylabel('Abs. Activity (sec/10min)')

if threehrBool == 1;
    subplot(6,4,17)
else
    subplot(6,4,[17,18])
end

plot(vpWakeZM,'linewidth',0.75, 'color', 'k');
hold on
if ~isempty(startTreat2)
    patch('Faces',[1 2 3 4],'Vertices',[startTreat2 -2; endTreat2 -2; endTreat2 5; startTreat2 5],...
          'FaceColor',patchColor, 'EdgeColor',patchColor,'FaceAlpha',0.3);
end
%plot empty triangle for day and filled for night
for aa = 1: size(d2n,1)
    plot(d2n(aa),5,'v','Color','k','MarkerFaceColor','k'); %filled night
end
for bb = 1:size(n2d,1)
    plot(n2d(bb),5,'v','Color','k'); %empty day
end
%plot triangle for treatment in a 3hr drug
if threehrBool == 1;
    plot(60, 5, 'v','color','r','MarkerFaceColor','r');
end
set(gca,'XTick',[])
set(gca,'XColor','w')
axis(gca, [0 inf -2 5])
ylabel('Norm. Activity (Std devs)');

if threehrBool == 1;
    subplot(6,4,15)
else
    subplot(6,4,[15,16])
end

plot(vpSleepM,'linewidth',0.75, 'color', 'k');
hold on
if ~isempty(startTreat2)
    patch('Faces',[1 2 3 4],'Vertices',[startTreat2 0; endTreat2 0; endTreat2 yscale2; startTreat2 yscale2],...
          'FaceColor',patchColor, 'EdgeColor',patchColor,'FaceAlpha',0.3);
end
%plot empty triangle for day and filled for night
for aa = 1: size(d2n,1)
    plot(d2n(aa),yscale2,'v','Color','k','MarkerFaceColor','k'); %filled night
end
for bb = 1:size(n2d,1)
    plot(n2d(bb),yscale2,'v','Color','k'); %empty day
end
%plot triangle for treatment in a 3hr drug
if threehrBool == 1;
    plot(60, yscale2, 'v','color','r','MarkerFaceColor','r');
end
set(gca,'XTick',[])
set(gca,'XColor','w')
axis(gca, [0 inf 0 yscale2])
lx2 = legend (rowLabels(1,1),'Location','northeast');
set(lx2,'FontSize',4)
legend('boxoff');
ylabel('Abs. Sleep (min/10min)')

if threehrBool == 1;
    subplot(6,4,19)
else
    subplot(6,4,[19,20])
end

plot(vpSleepZM,'linewidth',0.75, 'color', 'k');
hold on
if ~isempty(startTreat2)
    patch('Faces',[1 2 3 4],'Vertices',[startTreat2 -2; endTreat2 -2; endTreat2 5; startTreat2 5],...
          'FaceColor',patchColor, 'EdgeColor',patchColor,'FaceAlpha',0.3);
end
%plot empty triangle for day and filled for night
for aa = 1: size(d2n,1)
    plot(d2n(aa),5,'v','Color','k','MarkerFaceColor','k'); %filled night
end
for bb = 1:size(n2d,1)
    plot(n2d(bb),5,'v','Color','k'); %empty day
end
%plot triangle for treatment in a 3hr drug
if threehrBool == 1;
    plot(60, 5, 'v','color','r','MarkerFaceColor','r');
end
set(gca,'XTick',[])
set(gca,'XColor','w')
axis(gca, [0 inf -2 5])
ylabel('Norm. Sleep (Std devs)');

%% Boxplots of total wake and total sleep
%calculate if 2 or 3 condition comparison box:
if (needTotalBoxBool)
    subplot(6,4,21)
    boxplot(vpBoxarranged(:,1)); %,'BoxStyle','filled');
    set(gca,'XTick',[])
    set(gca,'XColor','w')
    set(gca,'XTickLabel',{' '}) 
    %set(gca,'XTickLabel',{'Control','Test'})
    ylabel('Day Activity (sec/min)')
    title('Day Activity')
    
    %plot nanmean as black asterisk
    hold on
    m1 = nanmean(vpBoxarranged(:,1));
    plot(m1,'*k')
    hold off
   
    subplot(6,4,22)
    boxplot(vpBoxarranged(:,2));
    set(gca,'XTick',[])
    set(gca,'XColor','w')
    set(gca,'XTickLabel',{' '})
    %set(gca,'XTickLabel',{'Control','Test'})
    ylabel('Day Sleep(min/hr)')
    title('Day Sleep')
    
    %plot nanmean as black asterisk
    hold on
    m2 = nanmean(vpBoxarranged(:,2));
    plot(m2,'*k')
    hold off
    
    subplot(6,4,23)
    boxplot(vpBoxarranged(:,3));
    set(gca,'XTick',[])
    set(gca,'XColor','w')
    set(gca,'XTickLabel',{' '})
    %set(gca,'XTickLabel',{'Control','Test'})
    ylabel('Night Activity (sec/min)')
    title('Night Activity')
    
    %plot nanmean as black asterisk
    hold on 
    m3 = nanmean(vpBoxarranged(:,3));
    plot(m3,'*k')
    hold off
    
    subplot(6,4,24)
    boxplot(vpBoxarranged(:,4));
    set(gca,'XTick',[])
    set(gca,'XColor','w')
    set(gca,'XTickLabel',{' '})
    %set(gca,'XTickLabel',{'Control','Test'})
    ylabel('Night Sleep(min/hr)')
    title('Night Sleep')
    
    %plot nanmean as black asterisk
    hold on
    m4 = nanmean(vpBoxarranged(:,4));
    plot(m4,'*k')
    hold off
    
    %Export figure hh
    set(hh, 'color', 'w');
    fileName = 'plate_All.tif';
    export_fig([outputdir,fileName], '-r500','-nocrop','-a2'); 
    fileName2 = 'plate_All.eps';
    print('-depsc','-r300',[outputdir,filesep,fileName2]);
    close(hh);
else
    set(hh, 'color', 'w');
    fileName = 'plate_All.tif';
    export_fig([outputdir,fileName], '-r500','-nocrop','-a2'); 
    fileName2 = 'plate_All.eps';
    print('-depsc','-r300',[outputdir,filesep,fileName2]);
    close(hh);
end
%%save out
save([outputdir,'outputPlotVariables.mat']);