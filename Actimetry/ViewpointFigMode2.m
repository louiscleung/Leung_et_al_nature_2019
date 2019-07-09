function [] = ViewpointFigMode2(dirname,excel,needTotalBoxBool,rowBool,vpWake,...
                                vpSleep,vpTime,vpBoxdata,rowLabels,...
                                d2n,n2d,outputdir,threehrBool,oneDayBool)
%%Stats

%2 separate conditions
vpConWake = horzcat(vpWake(:,1:6),vpWake(:,13:18));
vpTestWake = horzcat(vpWake(:,7:12),vpWake(:,19:24));
vpConSleep = horzcat(vpSleep(:,1:6),vpSleep(:,13:18));
vpTestSleep = horzcat(vpSleep(:,7:12),vpSleep(:,19:24));

%Mean,SD and SEM 2 condition
%2 separate conditions
vpConWakeM = nanmean(vpConWake,2);
vpTestWakeM = nanmean(vpTestWake,2);
vpConSleepM = nanmean(vpConSleep,2);
vpTestSleepM = nanmean(vpTestSleep,2);
std_11 = nanstd(vpConWake')';
std_12 = nanstd(vpTestWake')';
std_13 = nanstd(vpConSleep')';
std_14 = nanstd(vpTestSleep')';
vpConWakeS = std_11./sqrt(size(vpConWake,2));
vpTestWakeS = std_12./sqrt(size(vpTestWake,2));
vpConSleepS = std_13./sqrt(size(vpConSleep,2));
vpTestSleepS = std_14./sqrt(size(vpTestSleep,2));
%zscore
vpConWakeZ = bsxfun(@rdivide, bsxfun(@minus, vpConWake, nanmean(vpConWake,1)), nanstd(vpConWake,0,1));
vpTestWakeZ = bsxfun(@rdivide, bsxfun(@minus, vpTestWake, nanmean(vpTestWake,1)), nanstd(vpTestWake,0,1));
vpConSleepZ = bsxfun(@rdivide, bsxfun(@minus, vpConSleep, nanmean(vpConSleep,1)), nanstd(vpConSleep,0,1));
vpTestSleepZ = bsxfun(@rdivide, bsxfun(@minus, vpTestSleep, nanmean(vpTestSleep,1)), nanstd(vpTestSleep,0,1));
%meanzscore
vpConWakeZM = nanmean(vpConWakeZ,2);
vpTestWakeZM = nanmean(vpTestWakeZ,2);
vpConSleepZM = nanmean(vpConSleepZ,2);
vpTestSleepZM = nanmean(vpTestSleepZ,2);
%Control is row 1 and 3 and test is row 2 and 4
%control
vpBoxarranged(1:6,[1,3,5,7]) = vpBoxdata(1:6,:);
vpBoxarranged(7:12,[1,3,5,7]) = vpBoxdata(13:18,:);
%test
vpBoxarranged(1:6,[2,4,6,8]) = vpBoxdata(7:12,:);
vpBoxarranged(7:12,[2,4,6,8]) = vpBoxdata(19:24,:);

%% Row Colors
%wake
rowColors{1,1} = [0, 0, 0];
%Sleep
rowColors{1,2} = [0, 0, 0];
%wake
rowColors{2,1} = [0.0, 0.0, 0.5];
%Sleep
rowColors{2,2} = [0.7,0.0,0.0];

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

%% One big combined figure
hh = figure('Position', [10, 10, 1500, 1500]);
[~,condVal,~] = fileparts(excel);
%text(1,1,deepestFolder);
%change size

subplot(6,4,1) %boxplot control wake
b1 = boxplot(vpConWake);
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
axis(gca,[0 (size(vpConWake,2)+1) 0 yscale])
ylabel('Activity (sec/min)')
boxtitle = strcat(rowLabels(1,1),' Activity');
title(boxtitle)

   
subplot(6,4,2) %boxplot test 2 wake
b2 = boxplot(vpTestWake);
%boxplot properties
set(b2(1,:),'LineStyle','-','Color',rowColors{2,1}); %set the top line to color of row
set(b2(2,:),'LineStyle','-','Color',rowColors{2,1}); %set the top line to color of row
set(b2(3,:),'Color',rowColors{2,1}); %Top line color
set(b2(4,:),'Color',rowColors{2,1}); %Bottom line color
set(b2(5,:),'Color',rowColors{2,1}); %Box line color
set(b2(6,:),'Color',rowColors{2,1}); %median line color
set(b2(7,:),'Visible','off'); %Turn off outliers
%ax properties
bb2 = findobj(gca,'Tag','Box');
for j=1:length(bb2)
    patch(get(bb2(j),'XData'),get(bb2(j),'YData'),rowColors{2,1},'FaceAlpha',.3);
end
set(gca,'XTick',[])
set(gca,'XColor','w')
set(gca,'XTickLabel',{' '})
axis(gca,[0 (size(vpTestWake,2)+1) 0 yscale])
ylabel('Activity (sec/min)')
boxtitle2 = strcat(rowLabels(1,2),' Activity');
title(boxtitle2)


subplot(6,4,3)
text(0,0.5,{dirname,condVal});
axis off
%add the date in empty subplot
subplot(6,4,4)
%text(0.5,0.5,'Empty');
%text(0.5,0.5,deepestFolder);
axis off

subplot(6,4,5) %boxplot Control Sleep
%remove zeros from boxplot for sleep so you can see variation whenever
%sleep is actually counted
nanviewpointData1 = vpConSleep;
nanviewpointData1(nanviewpointData1==0) = nan;
b5 = boxplot(nanviewpointData1);
%boxplot properties
set(b5(1,:),'LineStyle','-','Color',rowColors{1,2}); %set the top line to color of row
set(b5(2,:),'LineStyle','-','Color',rowColors{1,2}); %set the top line to color of row
set(b5(3,:),'Color',rowColors{1,2}); %Top line color
set(b5(4,:),'Color',rowColors{1,2}); %Bottom line color
set(b5(5,:),'Color',rowColors{1,2}); %Box line color
set(b5(6,:),'Color',rowColors{1,2}); %median line color
set(b5(7,:),'Visible','off'); %Turn off outliers
%ax properties
bb5 = findobj(gca,'Tag','Box');
for j=1:length(bb5)
    patch(get(bb5(j),'XData'),get(bb5(j),'YData'),rowColors{1,2},'FaceAlpha',.3);
end
set(gca,'XTick',[])
set(gca,'XColor','w')
set(gca,'XTickLabel',{' '})
axis(gca,[0 (size(vpConSleep,2)+1) 0 yscale2])
ylabel('Sleep (min/10min)')
boxtitle5 = strcat(rowLabels(1,1),' Sleep Duration');
title(boxtitle5)

subplot(6,4,6) %boxplot Test 2 Sleep
nanviewpointData2 = vpTestSleep;
nanviewpointData2(nanviewpointData2==0) = nan;
b6 = boxplot(nanviewpointData2);
%boxplot properties
set(b6(1,:),'LineStyle','-','Color',rowColors{2,2}); %set the top line to color of row
set(b6(2,:),'LineStyle','-','Color',rowColors{2,2}); %set the top line to color of row
set(b6(3,:),'Color',rowColors{2,2}); %Top line color
set(b6(4,:),'Color',rowColors{2,2}); %Bottom line color
set(b6(5,:),'Color',rowColors{2,2}); %Box line color
set(b6(6,:),'Color',rowColors{2,2}); %median line color
set(b6(7,:),'Visible','off'); %Turn off outliers
%ax properties
bb6 = findobj(gca,'Tag','Box');
for j=1:length(bb6)
    patch(get(bb6(j),'XData'),get(bb6(j),'YData'),rowColors{2,2},'FaceAlpha',.3);
end
set(gca,'XTick',[])
set(gca,'XColor','w')
set(gca,'XTickLabel',{' '})
axis(gca,[0 (size(vpTestSleep,2)+1) 0 yscale2])
ylabel('Sleep (min/10min)')
boxtitle5 = strcat(rowLabels(1,2),' Sleep Duration');
title(boxtitle5)

subplot(6,4,7)
%text(0.5,0.5,'Empty');
axis off

%% Shaded graphs
%subplot(6,4,9) %24hr stretched [9,10])
if threehrBool == 1;
    subplot(6,4,9)
elseif (oneDayBool == 1)
    subplot(6,4,9)
else
    subplot(6,4,[9,10])
end

%catch cases where there is only one column/sample
if (vpConWakeS==std_11)
    plot(vpConWakeM,'linewidth',0.5, 'color', 'k');
else
    shadedErrorBar([],vpConWakeM',vpConWakeS,'-k',0);
end
hold on

if (vpTestWakeS==std_12)
    plot(vpTestWakeM,'linewidth',0.5, 'color', rowColors{2,1});
else
    shadedErrorBar([],vpTestWakeM',vpTestWakeS,{'linestyle','-','color', rowColors{2,1}},0);
end
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
% shadedErrorBar([],a',sem1,'-k',0);
% hold on;
% shadedErrorBar([],b',sem2,'-b',0);
%plot triangle for treatment in a 3hr drug
if threehrBool == 1;
    plot(60, yscale, 'v','color','r','MarkerFaceColor','r');
end
set(gca,'XTick',[])
set(gca,'XColor','w') %how do i do 'none'?
set(gca,'FontSize',8)
axis(gca, [0 inf 0 yscale])
%adjust aspect ratio to length of the acquisition
%daspect(gca,[1,1,1])
ylabel('Abs. Activity (sec/10min)')
% l1=legend(deepestFolder,'Location','northeast');
% l2 = get(l1,'children') ; % the symbol and the text are children of
% delete(l2(1)) ;
% legend('boxoff')

% subplot(6,4,11) %24 stretched [11,12])
if threehrBool == 1;
    subplot(6,4,11)
elseif (oneDayBool == 1)
    subplot(6,4,11)
else
    subplot(6,4,[11,12])
end

if (vpConSleepS==std_13)
    plot(vpConSleepM,'linewidth',0.5, 'color', 'k');
else
    shadedErrorBar([],vpConSleepM',vpConSleepS,'-k',0);
end
hold on


if (vpTestSleepS==std_14)
    plot(vpTestSleepM,'linewidth',0.5, 'color', rowColors{2,2}); %'r'
else
    shadedErrorBar([],vpTestSleepM',vpTestSleepS,{'linestyle','-','color', rowColors{2,2}},0);
end
if ~isempty(startTreat2)
    hold on
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
% shadedErrorBar([],c',sem3,'-k',0);
% hold on;
% shadedErrorBar([],d',sem4,'-r',0);

%plot triangle for treatment in a 3hr drug
if threehrBool == 1;
    plot(60, yscale2, 'v','color','r','MarkerFaceColor','r');
end
set(gca,'XTick',[])
set(gca,'XColor','w')
set(gca,'FontSize',8)
axis(gca, [0 inf 0 yscale2])
ylabel('Abs. Sleep (min/10min)')

% l2=legend(deepestFolder,'Location','northeast');
% l3 = get(l2,'children') ; % the symbol and the text are children of
% delete(l3(1)) ;
% legend('boxoff')

%%Combined plot
if threehrBool == 1;
    subplot(6,4,13)
else
    subplot(6,4,[13,14])
end

plot(vpConWakeM,'linewidth',0.75, 'color', 'k');
hold on;

plot(vpTestWakeM,'linewidth',0.75, 'color', rowColors{2,1});
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
set(gca,'FontSize',8)
axis(gca, [0 inf 0 yscale])
lx1 = legend (rowLabels(1,1:2),'Location','northeast');
set(lx1,'FontSize',4)
legend('boxoff');
ylabel('Abs. Activity (sec/10min)')
%title(deepestFolder)

if threehrBool == 1;
    subplot(6,4,17)
else
    subplot(6,4,[17,18])
end

plot(vpConWakeZM,'linewidth',0.75, 'color', 'k');
hold on;
plot(vpTestWakeZM,'linewidth',0.75, 'color', rowColors{2,1});
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
set(gca,'FontSize',8)
axis(gca, [0 inf -2 5])
lx2 = legend (rowLabels(1,1:2),'Location','northeast');
set(lx2,'FontSize',4)
legend('boxoff');
ylabel('Norm. Activity (Std devs)');
% title(deepestFolder)

if threehrBool == 1;
    subplot(6,4,15)
else
    subplot(6,4,[15,16])
end

plot(vpConSleepM,'linewidth',0.75, 'color', 'k');
hold on;
plot(vpTestSleepM,'linewidth',0.75, 'color', rowColors{2,2});
if ~isempty(startTreat2)
    patch('Faces',[1 2 3 4],'Vertices',[startTreat2 0; endTreat2 0; endTreat2 yscale2; startTreat2 yscale2],...
          'FaceColor',patchColor, 'EdgeColor',patchColor,'FaceAlpha',0.3);
end
% plot empty triangle for day and filled for night
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
set(gca,'FontSize',8)
axis(gca, [0 inf 0 yscale2])
lx3 = legend (rowLabels(1,1:2),'Location','northeast');
set(lx3,'FontSize',4)
legend('boxoff');
ylabel('Abs. Sleep (min/10min)')
% title(deepestFolder)

if threehrBool == 1;
    subplot(6,4,19)
else
    subplot(6,4,[19,20])
end

plot(vpConSleepZM,'linewidth',0.75, 'color', 'k');
hold on;
plot(vpTestSleepZM,'linewidth',0.75, 'color', rowColors{2,2});
if ~isempty(startTreat2)
    patch('Faces',[1 2 3 4],'Vertices',[startTreat2 -2; endTreat2 -2; endTreat2 5; startTreat2 5],...
          'FaceColor',patchColor, 'EdgeColor',patchColor,'FaceAlpha',0.3);
end
% plot empty triangle for day and filled for night
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
set(gca,'FontSize',8)
axis(gca, [0 inf -2 5])
lx4 = legend (rowLabels(1,1:2),'Location','northeast');
set(lx4,'FontSize',4)
legend('boxoff');
ylabel('Norm. Sleep (Std devs)');

%% Boxplots of total wake and total sleep
% calculate if 2 or 3 condition comparison box:
if (needTotalBoxBool)
    startRow = rowBool-rowBool+1;
    endRow = rowBool;
    subplot(6,4,21)
    b9 = boxplot(vpBoxarranged(:,startRow:endRow),'Labels',{rowLabels(1,1:2)}); %,'BoxStyle','filled');
    %boxplot properties
    set(b9(1,:),'LineStyle','-','Color',rowColors{1,1}); %set the top line to color of row
    set(b9(2,:),'LineStyle','-','Color',rowColors{1,1}); %set the top line to color of row
    set(b9(3,:),'Color',rowColors{1,1}); %Top line color
    set(b9(4,:),'Color',rowColors{1,1}); %Bottom line color
    set(b9(5,:),'Color',rowColors{1,1}); %Box line color
    set(b9(6,:),'Color',rowColors{2,1}); %median line color
    set(b9(7,:),'Visible','off'); %Turn off outliers
    %ax properties
    set(findobj(gca,'Type','text'),'FontSize',7) 
    set(gca,'XTick',[])
    set(gca,'XColor','w')
    set(gca,'FontSize',8)
    %set(gca,'XTickLabel',{' '}) 
    ylabel('Day Activity (sec/min)')
    title('Day Activity')
    
    %plot mean as black asterisk
    hold on
    m1 = nanmean(vpBoxarranged(:,startRow:endRow));
    plot(m1,'*k')
    hold off
    
    startRow1 = startRow+rowBool;
    endRow1 = endRow+rowBool;
    
    subplot(6,4,22)
    b10 = boxplot(vpBoxarranged(:,startRow1:endRow1),'Labels',{rowLabels(1,1:2)});
    %boxplot properties
    set(b10(1,:),'LineStyle','-','Color',rowColors{1,1}); %set the top line to color of row
    set(b10(2,:),'LineStyle','-','Color',rowColors{1,1}); %set the top line to color of row
    set(b10(3,:),'Color',rowColors{1,1}); %Top line color
    set(b10(4,:),'Color',rowColors{1,1}); %Bottom line color
    set(b10(5,:),'Color',rowColors{1,1}); %Box line color
    set(b10(6,:),'Color',rowColors{2,1}); %median line color
    set(b10(7,:),'Visible','off'); %Turn off outliers    
    %ax properties
    set(findobj(gca,'Type','text'),'FontSize',7) 
    set(gca,'XTick',[])
    set(gca,'XColor','w')
    set(gca,'FontSize',8)
    %set(gca,'XTickLabel',{' '})
    %set(gca,'XTickLabel',{'Control','Test'})
    ylabel('Day Sleep(min/hr)')
    title('Day Sleep')
    
    %plot mean as black asterisk
    hold on
    m2 = nanmean(vpBoxarranged(:,startRow1:endRow1));
    plot(m2,'*k')
    hold off
    
    startRow2 = startRow1+rowBool;
    endRow2 = endRow1+rowBool;
    
    subplot(6,4,23)
    b11 = boxplot(vpBoxarranged(:,startRow2:endRow2),'Labels',{rowLabels(1,1:2)});
    %boxplot properties
    set(b11(1,:),'LineStyle','-','Color',rowColors{1,1}); %set the top line to color of row
    set(b11(2,:),'LineStyle','-','Color',rowColors{1,1}); %set the top line to color of row
    set(b11(3,:),'Color',rowColors{1,1}); %Top line color
    set(b11(4,:),'Color',rowColors{1,1}); %Bottom line color
    set(b11(5,:),'Color',rowColors{1,1}); %Box line color
    set(b11(6,:),'Color',rowColors{2,1}); %median line color
    set(b11(7,:),'Visible','off'); %Turn off outliers
    %ax properties
    set(findobj(gca,'Type','text'),'FontSize',7) 
    set(gca,'XTick',[])
    set(gca,'XColor','w')
    set(gca,'FontSize',8)
    %set(gca,'XTickLabel',{' '})
    ylabel('Night Activity (sec/min)')
    title('Night Activity')
    
    %plot mean as black asterisk
    hold on 
    m3 = nanmean(vpBoxarranged(:,startRow2:endRow2));
    plot(m3,'*k')
    hold off
    
    startRow3 = startRow2+rowBool;
    endRow3 = endRow2+rowBool;
    
    subplot(6,4,24)
    b12 = boxplot(vpBoxarranged(:,startRow3:endRow3),'Labels',{rowLabels(1,1:2)});
    %boxplot properties
    set(b12(1,:),'LineStyle','-','Color',rowColors{1,1}); %set the top line to color of row
    set(b12(2,:),'LineStyle','-','Color',rowColors{1,1}); %set the top line to color of row
    set(b12(3,:),'Color',rowColors{1,1}); %Top line color
    set(b12(4,:),'Color',rowColors{1,1}); %Bottom line color
    set(b12(5,:),'Color',rowColors{1,1}); %Box line color
    set(b12(6,:),'Color',rowColors{2,1}); %median line color
    set(b12(7,:),'Visible','off'); %Turn off outliers
    %ax properties
    set(findobj(gca,'Type','text'),'FontSize',7)
    set(gca,'XTick',[])
    set(gca,'XColor','w')
    set(gca,'FontSize',8)
    %set(gca,'XTickLabel',{' '})
    ylabel('Night Sleep(min/hr)')
    title('Night Sleep')
    
    %plot mean as black asterisk
    hold on
    m4 = nanmean(vpBoxarranged(:,startRow3:endRow3));
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