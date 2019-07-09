function [] = ViewpointFigMode3(dirname,excel,needTotalBoxBool,rowBool,vpWake,...
                                vpSleep,vpTime,vpBoxdata,rowLabels,...
                                d2n,n2d,outputdir,threehrBool,oneDayBool)
%% 2 separate experiments in one dish

%Wake
vpConWake1 = vpWake(:,1:6);
vpTestWake1 = vpWake(:,7:12);
vpConWake2 = vpWake(:,13:18);
vpTestWake2 = vpWake(:,19:24);
%Sleep
vpConSleep1 = vpSleep(:,1:6);
vpTestSleep1 = vpSleep(:,7:12);
vpConSleep2 = vpSleep(:,13:18);
vpTestSleep2 = vpSleep(:,19:24);

%Mean,SD and SEM 4 condition
%Wake
vpConWake1M = nanmean(vpConWake1,2);
vpTestWake1M = nanmean(vpTestWake1,2);
vpConWake2M = nanmean(vpConWake2,2);
vpTestWake2M = nanmean(vpTestWake2,2);
std_3 = nanstd(vpConWake1')';
std_4 = nanstd(vpTestWake1')';
std_5 = nanstd(vpConWake2')';
std_6 = nanstd(vpTestWake2')';
vpConWake1S = std_3./sqrt(size(vpConWake1,2));
vpTestWake1S = std_4./sqrt(size(vpTestWake1,2));
vpConWake2S = std_5./sqrt(size(vpConWake2,2));
vpTestWake2S = std_6./sqrt(size(vpTestWake2,2));
%zscore
vpConWake1Z = bsxfun(@rdivide, bsxfun(@minus, vpConWake1, nanmean(vpConWake1,1)), nanstd(vpConWake1,0,1));
vpTestWake1Z = bsxfun(@rdivide, bsxfun(@minus, vpTestWake1, nanmean(vpTestWake1,1)), nanstd(vpTestWake1,0,1));
vpConWake2Z = bsxfun(@rdivide, bsxfun(@minus, vpConWake2, nanmean(vpConWake2,1)), nanstd(vpConWake2,0,1));
vpTestWake2Z = bsxfun(@rdivide, bsxfun(@minus, vpTestWake2, nanmean(vpTestWake2,1)), nanstd(vpTestWake2,0,1));

vpConWake1ZM = nanmean(vpConWake1Z,2);
vpTestWake1ZM = nanmean(vpTestWake1Z,2);
vpConWake2ZM = nanmean(vpConWake2Z,2);
vpTestWake2ZM = nanmean(vpTestWake2Z,2);

%Sleep
vpConSleep1M = nanmean(vpConSleep1,2);
vpTestSleep1M = nanmean(vpTestSleep1,2);
vpConSleep2M = nanmean(vpConSleep2,2);
vpTestSleep2M = nanmean(vpTestSleep2,2);
std_7 = nanstd(vpConSleep1')';
std_8 = nanstd(vpTestSleep1')';
std_9 = nanstd(vpConSleep2')';
std_10 = nanstd(vpTestSleep2')';
vpConSleep1S = std_7./sqrt(size(vpConSleep1,2));
vpTestSleep1S = std_8./sqrt(size(vpTestSleep1,2));
vpConSleep2S = std_9./sqrt(size(vpConSleep2,2));
vpTestSleep2S = std_10./sqrt(size(vpTestSleep2,2));
%zscore
vpConSleep1Z = bsxfun(@rdivide, bsxfun(@minus, vpConSleep1, nanmean(vpConSleep1,1)), nanstd(vpConSleep1,0,1));
vpTestSleep1Z = bsxfun(@rdivide, bsxfun(@minus, vpTestSleep1, nanmean(vpTestSleep1,1)), nanstd(vpTestSleep1,0,1));
vpConSleep2Z = bsxfun(@rdivide, bsxfun(@minus, vpConSleep2, nanmean(vpConSleep2,1)), nanstd(vpConSleep2,0,1));
vpTestSleep2Z = bsxfun(@rdivide, bsxfun(@minus, vpTestSleep2, nanmean(vpTestSleep2,1)), nanstd(vpTestSleep2,0,1));

vpConSleep1ZM = nanmean(vpConSleep1Z,2);
vpTestSleep1ZM = nanmean(vpTestSleep1Z,2);
vpConSleep2ZM = nanmean(vpConSleep2Z,2);
vpTestSleep2ZM = nanmean(vpTestSleep2Z,2);

%% Row Colors
%wake
rowColors{1,1} = [0, 0, 0];
%Sleep
rowColors{1,2} = [0, 0, 0];
%wake
rowColors{2,1} = [0.0, 0.0, 0.5];
%Sleep
rowColors{2,2} = [0.7,0.0,0.0];
%wake
rowColors{3,1} = [0,0,0];
%Sleep
rowColors{3,2} = [0,0,0];
%wake
rowColors{4,1} = [0.0, 0.0, 0.5];
%Sleep
rowColors{4,2} = [0.7,0.0,0.0];
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

subplot(6,4,1) %boxplot control wake
b1 = boxplot(vpConWake1);

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
set(gca,'FontSize',8)
axis(gca,[0 (size(vpConWake1,2)+1) 0 yscale])
ylabel('Activity (sec/min)')
boxtitle = strcat(rowLabels(1,1),' Activity');
title(boxtitle)

subplot(6,4,2) %boxplot test 2 wake
b2 = boxplot(vpTestWake1);
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
set(gca,'FontSize',8)
axis(gca,[0 (size(vpTestWake1,2)+1) 0 yscale])
ylabel('Activity (sec/min)')
boxtitle2 = strcat(rowLabels(1,2),' Activity');
title(boxtitle2)

subplot(6,4,3)
[~,condVal,~] = fileparts(excel);
text(0,0.5,{dirname,condVal});
axis off


subplot(6,4,5) %boxplot Control Sleep
%remove zeros from boxplot for sleep so you can see variation whenever
%sleep is actually counted
nanviewpointData1 = vpConSleep1;
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
set(gca,'FontSize',8)
axis(gca,[0 (size(vpConSleep1,2)+1) 0 yscale2])
ylabel('Sleep (min/10min)')
boxtitle5 = strcat(rowLabels(1,1),' Sleep Duration');
title(boxtitle5)

subplot(6,4,6) %boxplot Test 2 Sleep
nanviewpointData2 = vpTestSleep1;
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
set(gca,'FontSize',8)
axis(gca,[0 (size(vpTestSleep1,2)+1) 0 yscale2])
ylabel('Sleep (min/10min)')
boxtitle5 = strcat(rowLabels(1,2),' Sleep Duration');
title(boxtitle5)

%% Shaded graphs
if threehrBool == 1;
    subplot(6,4,9)
elseif (oneDayBool == 1)
    subplot(6,4,9)
else
    subplot(6,4,[9,10])
end

%catch cases where there is only one column/sample
if (vpConWake1S==std_3)
    plot(vpConWake1M,'linewidth',0.5, 'color', 'k');
else
    shadedErrorBar([],vpConWake1M',vpConWake1S,'-k',0);
end
hold on

if (vpTestWake1S==std_4)
    plot(vpTestWake1M,'linewidth',0.5, 'color', rowColors{2,1});
else
    shadedErrorBar([],vpTestWake1M',vpTestWake1S,{'linestyle','-','color', rowColors{2,1}},0);
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
set(gca,'FontSize',8)
axis(gca, [0 inf 0 yscale])
%lx5 = legend (rowLabels(1,1:4),'Location','northeast');
%set(lx5,'FontSize',4)
%legend('boxoff');
ylabel('Abs. Activity (sec/10min)')

if threehrBool == 1;
    subplot(6,4,11)
elseif (oneDayBool == 1)
    subplot(6,4,11)
else
    subplot(6,4,[11,12])
end

if (vpConSleep1S==std_7)
    plot(vpConSleep1M,'linewidth',0.5, 'color', 'k');
else
    shadedErrorBar([],vpConSleep1M',vpConSleep1S,'-k',0);
end
hold on

if (vpTestSleep1S==std_8)
    plot(vpTestSleep1M,'linewidth',0.5, 'color', rowColors{2,2}); %'r'
else
    shadedErrorBar([],vpTestSleep1M',vpTestSleep1S,{'linestyle','-','color', rowColors{2,2}},0);
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
set(gca,'FontSize',8)
axis(gca, [0 inf 0 yscale2])
%lx6 = legend (rowLabels(1,1:4),'Location','northeast');
%set(lx6,'FontSize',4)
%legend('boxoff');
ylabel('Abs. Sleep (min/10min)')

%%Combined plot
if threehrBool == 1;
    subplot(6,4,13)
else
    subplot(6,4,[13,14])
end

plot(vpConWake1M,'linewidth',0.75, 'color', 'k');
hold on;
plot(vpTestWake1M,'linewidth',0.75, 'color', rowColors{2,1});
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

plot(vpConWake1ZM,'linewidth',0.75, 'color', 'k');
hold on;
plot(vpTestWake1ZM,'linewidth',0.75, 'color', rowColors{2,1});
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
set(gca,'FontSize',8)
axis(gca, [0 inf -2 5])
lx2 = legend (rowLabels(1,1:2),'Location','northeast');
set(lx2,'FontSize',4)
legend('boxoff');
ylabel('Norm. Activity (Std devs)');
%title(deepestFolder)
if threehrBool == 1;
    subplot(6,4,15)
else
    subplot(6,4,[15,16])
end

plot(vpConSleep1M,'linewidth',0.75, 'color', 'k');
hold on;
plot(vpTestSleep1M,'linewidth',0.75, 'color', rowColors{2,2});
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
set(gca,'FontSize',8)
axis(gca, [0 inf 0 yscale2])
lx3 = legend (rowLabels(1,1:2),'Location','northeast');
set(lx3,'FontSize',4)
legend('boxoff');
ylabel('Abs. Sleep (min/10min)')
if threehrBool == 1;
    subplot(6,4,19)
else
    subplot(6,4,[19,20])
end

plot(vpConSleep1ZM,'linewidth',0.75, 'color', 'k');
hold on;
plot(vpTestSleep1ZM,'linewidth',0.75, 'color', rowColors{2,2});
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
set(gca,'FontSize',8)
axis(gca, [0 inf -2 5])
lx4 = legend (rowLabels(1,1:2),'Location','northeast');
set(lx4,'FontSize',4)
legend('boxoff');
ylabel('Norm. Sleep (Std devs)');

%% Boxplots of total wake and total sleep

%If 2separate experiments
%Day activity
vpBoxarranged(1:6,1) = vpBoxdata(1:6,1);
vpBoxarranged(1:6,2) = vpBoxdata(7:12,1);

%Day Sleep
vpBoxarranged(1:6,3) = vpBoxdata(1:6,2);
vpBoxarranged(1:6,4) = vpBoxdata(7:12,2);

%Night Activity
vpBoxarranged(1:6,5) = vpBoxdata(1:6,3);
vpBoxarranged(1:6,6) = vpBoxdata(7:12,3);

%Night Sleep
vpBoxarranged(1:6,7) = vpBoxdata(1:6,4);
vpBoxarranged(1:6,8) = vpBoxdata(7:12,4);


rowBool = 2;
%% calculate if 2 or 3 condition comparison box:
if (needTotalBoxBool)
    startRow = rowBool-rowBool+1;
    endRow = rowBool;
    subplot(6,4,21)
    b9 = boxplot(vpBoxarranged(:,startRow:endRow),'Labels',{rowLabels(1,1:2)});
    %boxplot properties
    set(b9(1,:),'LineStyle','-','Color',rowColors{1,1}); %set the top line to color of row
    set(b9(2,:),'LineStyle','-','Color',rowColors{1,1}); %set the top line to color of row
    set(b9(3,:),'Color',rowColors{1,1}); %Top line color
    set(b9(4,:),'Color',rowColors{1,1}); %Bottom line color - TODO - can box be filled?
    set(b9(5,:),'Color',rowColors{1,1}); %Box line color
    set(b9(6,:),'Color',rowColors{2,1}); %median line color
    set(b9(7,:),'Visible','off'); %Turn off outliers
    %ax properties
    set(findobj(gca,'Type','text'),'FontSize',7) 
    %boxplot(vpBoxarranged(:,startRow:endRow)); %,'BoxStyle','filled');
    %set(gca,'XTickLabel',{rowLabels(1,1:4)});    % {'Control','Test'})
    
    set(gca,'XTick',[])
    set(gca,'XColor','w')
    set(gca,'FontSize',8)
    %set(gca,'XTickLabel',{' '})
    ylabel('Day Activity (sec/min)')
    title('Day Activity')
    
    %plot mean as black asterisk
    hold on
    m1 = nanmean(vpBoxarranged(:,startRow:endRow));
    plot(m1,'*b')
    hold off
    
    startRow1 = startRow+rowBool;
    endRow1 = endRow+rowBool;
    
    subplot(6,4,22)
    %boxplot(vpBoxarranged(:,startRow1:endRow1));
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
    %set(gca,'XTickLabel',{'Sibling Control','NPVFepNTR'})
    ylabel('Day Sleep (min/hr)')
    title('Day Sleep')
    
    %plot mean as black asterisk
    hold on
    m2 = nanmean(vpBoxarranged(:,startRow1:endRow1));
    plot(m2,'*b')
    hold off
    
    startRow2 = startRow1+rowBool;
    endRow2 = endRow1+rowBool;
    
    subplot(6,4,23)
    %boxplot(vpBoxarranged(:,startRow2:endRow2));
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
    plot(m3,'*b')
    hold off
    
    startRow3 = startRow2+rowBool;
    endRow3 = endRow2+rowBool;
    
    subplot(6,4,24)
    %boxplot(vpBoxarranged(:,startRow3:endRow3));
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
    ylabel('Night Sleep (min/hr)')
    title('Night Sleep')
    
    %plot mean as black asterisk
    hold on
    m4 = nanmean(vpBoxarranged(:,startRow3:endRow3));
    plot(m4,'*b')
    hold off
    
    %Export figure hh
    set(hh, 'color', 'w');
    firstFilename = cell2mat(strcat('Plate_',rowLabels(1,1),' vs',{' '},rowLabels(1,2),'.tif'));
    export_fig([outputdir,firstFilename], '-r500','-nocrop','-a2');
    fileName2 = cell2mat(strcat('Plate_',rowLabels(1,1),' vs',{' '},rowLabels(1,2),'.eps'));
    print('-depsc','-r300',[outputdir,filesep,fileName2]);
    close(hh);
else
    set(hh, 'color', 'w');
    firstFilename = cell2mat(strcat('Plate_',rowLabels(1,1),' vs',{' '},rowLabels(1,2),'.tif'));
    export_fig([outputdir,firstFilename], '-r500','-nocrop','-a2'); 
    fileName2 = cell2mat(strcat('Plate_',rowLabels(1,1),' vs',{' '},rowLabels(1,2),'.eps'));
    print('-depsc','-r300',[outputdir,filesep,fileName2]);
    close(hh);
end

%% Second experiment
hh2 = figure('Position', [10, 10, 1500, 1500]);
subplot(6,4,1)
b3 = boxplot(vpConWake2);
%boxplot properties
set(b3(1,:),'LineStyle','-','Color',rowColors{3,1}); %set the top line to color of row
set(b3(2,:),'LineStyle','-','Color',rowColors{3,1}); %set the top line to color of row
set(b3(3,:),'Color',rowColors{3,1}); %Top line color
set(b3(4,:),'Color',rowColors{3,1}); %Bottom line color
set(b3(5,:),'Color',rowColors{3,1}); %Box line color
set(b3(6,:),'Color',rowColors{3,1}); %median line color
set(b3(7,:),'Visible','off'); %Turn off outliers
%ax properties
bb3 = findobj(gca,'Tag','Box');
for j=1:length(bb3)
    patch(get(bb3(j),'XData'),get(bb3(j),'YData'),rowColors{3,1},'FaceAlpha',.3);
end
set(gca,'XTick',[])
set(gca,'XColor','w')
set(gca,'XTickLabel',{' '})
set(gca,'FontSize',8)
axis(gca,[0 (size(vpConWake2,2)+1) 0 yscale])
ylabel('Activity (sec/min)')
boxtitle3 = strcat(rowLabels(1,3),' Activity');
title(boxtitle3)

subplot(6,4,2)
b4 = boxplot(vpTestWake2);
%boxplot properties
set(b4(1,:),'LineStyle','-','Color',rowColors{4,1}); %set the top line to color of row
set(b4(2,:),'LineStyle','-','Color',rowColors{4,1}); %set the top line to color of row
set(b4(3,:),'Color',rowColors{4,1}); %Top line color
set(b4(4,:),'Color',rowColors{4,1}); %Bottom line color 
set(b4(5,:),'Color',rowColors{4,1}); %Box line color
set(b4(6,:),'Color',rowColors{4,1}); %median line color
set(b4(7,:),'Visible','off'); %Turn off outliers
%ax properties
bb4 = findobj(gca,'Tag','Box');
for j=1:length(bb4)
    patch(get(bb4(j),'XData'),get(bb4(j),'YData'),rowColors{4,1},'FaceAlpha',.3);
end
set(gca,'XTick',[])
set(gca,'XColor','w')
set(gca,'XTickLabel',{' '})
set(gca,'FontSize',8)
axis(gca,[0 (size(vpTestWake2,2)+1) 0 yscale])
ylabel('Activity (sec/min)')
boxtitle4 = strcat(rowLabels(1,4),' Activity');
title(boxtitle4)

subplot(6,4,3)
[~,condVal,~] = fileparts(excel);
text(0,0.5,{dirname,condVal});
axis off

subplot(6,4,5)
nanviewpointData3 = vpConSleep2;
nanviewpointData3(nanviewpointData3==0) = nan;
b7 = boxplot(nanviewpointData3);
%boxplot properties
set(b7(1,:),'LineStyle','-','Color',rowColors{3,2}); %set the top line to color of row
set(b7(2,:),'LineStyle','-','Color',rowColors{3,2}); %set the top line to color of row
set(b7(3,:),'Color',rowColors{3,2}); %Top line color
set(b7(4,:),'Color',rowColors{3,2}); %Bottom line color
set(b7(5,:),'Color',rowColors{3,2}); %Box line color
set(b7(6,:),'Color',rowColors{3,2}); %median line color
set(b7(7,:),'Visible','off'); %Turn off outliers
%ax properties
bb7 = findobj(gca,'Tag','Box');
for j=1:length(bb7)
    patch(get(bb7(j),'XData'),get(bb7(j),'YData'),rowColors{3,2},'FaceAlpha',.3);
end
set(gca,'XTick',[])
set(gca,'XColor','w')
set(gca,'XTickLabel',{' '})
set(gca,'FontSize',8)
axis(gca,[0 (size(vpConSleep2,2)+1) 0 yscale2])
ylabel('Sleep (min/10min)')
boxtitle6 = strcat(rowLabels(1,3),' Sleep Duration');
title(boxtitle6)

subplot(6,4,6)
nanviewpointData4 = vpTestSleep2;
nanviewpointData4(nanviewpointData4==0) = nan;
b8 = boxplot(nanviewpointData4);
%boxplot properties
set(b8(1,:),'LineStyle','-','Color',rowColors{4,2}); %set the top line to color of row
set(b8(2,:),'LineStyle','-','Color',rowColors{4,2}); %set the top line to color of row
set(b8(3,:),'Color',rowColors{4,2}); %Top line color
set(b8(4,:),'Color',rowColors{4,2}); %Bottom line color
set(b8(5,:),'Color',rowColors{4,2}); %Box line color
set(b8(6,:),'Color',rowColors{4,2}); %median line color
set(b8(7,:),'Visible','off'); %Turn off outliers
%ax properties
bb8 = findobj(gca,'Tag','Box');
for j=1:length(bb8)
    patch(get(bb8(j),'XData'),get(bb8(j),'YData'),rowColors{4,2},'FaceAlpha',.3);
end
set(gca,'XTick',[])
set(gca,'XColor','w')
set(gca,'XTickLabel',{' '})
set(gca,'FontSize',8)
axis(gca,[0 (size(vpTestSleep2,2)+1) 0 yscale2])
ylabel('Sleep (min/10min)')
boxtitle7 = strcat(rowLabels(1,4),' Sleep Duration');
title(boxtitle7)

%% Shaded graphs
if threehrBool == 1;
    subplot(6,4,9)
else
    subplot(6,4,[9,10])
end

%catch cases where there is only one column/sample
if (vpConWake2S==std_5)
    plot(vpConWake2M,'linewidth',0.5, 'color', rowColors{3,1});
else
    shadedErrorBar([],vpConWake2M',vpConWake2S,{'linestyle','-','color', rowColors{3,1}},0);
end

hold on

if (vpTestWake2S==std_6)
    plot(vpTestWake2M,'linewidth',0.5, 'color', rowColors{4,1});
else
    shadedErrorBar([],vpTestWake2M',vpTestWake2S,{'linestyle','-','color', rowColors{4,1}},0);
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
set(gca,'FontSize',8)
axis(gca, [0 inf 0 yscale])
ylabel('Abs. Activity (sec/10min)')
if threehrBool == 1;
    subplot(6,4,11)
else
    subplot(6,4,[11,12])
end

if (vpConSleep2S==std_9)
    plot(vpConSleep2M,'linewidth',0.5, 'color', rowColors{3,2}); %'r'
else
    shadedErrorBar([],vpConSleep2M',vpConSleep2S,{'linestyle','-','color', rowColors{3,2}},0);
end
hold on

if (vpTestSleep2S==std_10)
    plot(vpTestSleep2M,'linewidth',0.5, 'color', rowColors{4,2}); %'r'
else
    shadedErrorBar([],vpTestSleep2M',vpTestSleep2S,{'linestyle','-','color', rowColors{4,2}},0);
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
set(gca,'FontSize',8)
axis(gca, [0 inf 0 yscale2])
ylabel('Abs. Sleep (min/10min)')

%%Combined plot
if threehrBool == 1;
    subplot(6,4,13)
else
    subplot(6,4,[13,14])
end
plot(vpConWake2M,'linewidth',0.75, 'color', rowColors{3,1});
hold on;
plot(vpTestWake2M,'linewidth',0.75, 'color', rowColors{4,1});
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
set(gca,'FontSize',8)
axis(gca, [0 inf 0 yscale])
lx1 = legend (rowLabels(1,3:4),'Location','northeast');
set(lx1,'FontSize',4)
legend('boxoff');
ylabel('Abs. Activity (sec/10min)')
%title(deepestFolder)
if threehrBool == 1;
    subplot(6,4,17)
else
    subplot(6,4,[17,18])
end
plot(vpConWake2ZM,'linewidth',0.75, 'color', rowColors{3,1});
hold on;
plot(vpTestWake2ZM,'linewidth',0.75, 'color', rowColors{4,1});
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
set(gca,'FontSize',8)
axis(gca, [0 inf -2 5])
lx2 = legend (rowLabels(1,3:4),'Location','northeast');
set(lx2,'FontSize',4)
legend('boxoff');
ylabel('Norm. Activity (Std devs)');
%title(deepestFolder)
if threehrBool == 1;
    subplot(6,4,15)
else
    subplot(6,4,[15,16])
end
plot(vpConSleep2M,'linewidth',0.75, 'color', rowColors{3,2});
hold on;
plot(vpTestSleep2M,'linewidth',0.75, 'color', rowColors{4,2});
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
set(gca,'FontSize',8)
axis(gca, [0 inf 0 yscale2])
lx3 = legend (rowLabels(1,3:4),'Location','northeast');
set(lx3,'FontSize',4)
legend('boxoff');
ylabel('Abs. Sleep (min/10min)')
if threehrBool == 1;
    subplot(6,4,19)
else
    subplot(6,4,[19,20])
end
plot(vpConSleep2ZM,'linewidth',0.75, 'color', rowColors{3,2});
hold on;
plot(vpTestSleep2ZM,'linewidth',0.75, 'color', rowColors{4,2});
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
set(gca,'FontSize',8)
axis(gca, [0 inf -2 5])
lx4 = legend (rowLabels(1,3:4),'Location','northeast');
set(lx4,'FontSize',4)
legend('boxoff');
ylabel('Norm. Sleep (Std devs)');

%If 2separate experiments

%Day activity
vpBoxarranged2(1:6,1) = vpBoxdata(13:18,1);
vpBoxarranged2(1:6,2) = vpBoxdata(19:24,1);
%Day Sleep
vpBoxarranged2(1:6,3) = vpBoxdata(13:18,2);
vpBoxarranged2(1:6,4) = vpBoxdata(19:24,2);
%Night Activity
vpBoxarranged2(1:6,5) = vpBoxdata(13:18,3);
vpBoxarranged2(1:6,6) = vpBoxdata(19:24,3);
%Night Sleep
vpBoxarranged2(1:6,7) = vpBoxdata(13:18,4);
vpBoxarranged2(1:6,8) = vpBoxdata(19:24,4);

rowBool = 2;
%% calculate if 2 or 3 condition comparison box:
if (needTotalBoxBool)
    startRow = rowBool-rowBool+1;
    endRow = rowBool;
    subplot(6,4,21)
    b9 = boxplot(vpBoxarranged2(:,startRow:endRow),'Labels',{rowLabels(1,3:4)});
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
    %boxplot(vpBoxarranged(:,startRow:endRow)); %,'BoxStyle','filled');
    %set(gca,'XTickLabel',{rowLabels(1,1:4)});    % {'Control','Test'})
    
    set(gca,'XTick',[])
    set(gca,'XColor','w')
    set(gca,'FontSize',8)
    %set(gca,'XTickLabel',{' '})
    ylabel('Day Activity (sec/min)')
    title('Day Activity')
    
    %plot mean as black asterisk
    hold on
    m5 = nanmean(vpBoxarranged2(:,startRow:endRow));
    plot(m5,'*b')
    hold off
    
    startRow1 = startRow+rowBool;
    endRow1 = endRow+rowBool;
    
    subplot(6,4,22)
    %boxplot(vpBoxarranged(:,startRow1:endRow1));
    b10 = boxplot(vpBoxarranged2(:,startRow1:endRow1),'Labels',{rowLabels(1,3:4)});
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
    %set(gca,'XTickLabel',{'Sibling Control','NPVFepNTR'})
    ylabel('Day Sleep (min/hr)')
    title('Day Sleep')
    
    %plot mean as black asterisk
    hold on
    m6 = nanmean(vpBoxarranged2(:,startRow1:endRow1));
    plot(m6,'*b')
    hold off
    
    startRow2 = startRow1+rowBool;
    endRow2 = endRow1+rowBool;
    
    subplot(6,4,23)
    %boxplot(vpBoxarranged(:,startRow2:endRow2));
    b11 = boxplot(vpBoxarranged2(:,startRow2:endRow2),'Labels',{rowLabels(1,3:4)});
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
    m7 = nanmean(vpBoxarranged2(:,startRow2:endRow2));
    plot(m7,'*b')
    hold off
    
    startRow3 = startRow2+rowBool;
    endRow3 = endRow2+rowBool;
    
    subplot(6,4,24)
    %boxplot(vpBoxarranged(:,startRow3:endRow3));
    b12 = boxplot(vpBoxarranged2(:,startRow3:endRow3),'Labels',{rowLabels(1,3:4)});
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
    ylabel('Night Sleep (min/hr)')
    title('Night Sleep')
    
    %plot mean as black asterisk
    hold on
    m8 = nanmean(vpBoxarranged2(:,startRow3:endRow3));
    plot(m8,'*b')
    hold off
    
    %Export figure hh
    set(hh2, 'color', 'w');
    secondFilename = cell2mat(strcat('Plate_',rowLabels(1,3),' vs',{' '},rowLabels(1,4),'.tif'));
    export_fig([outputdir,secondFilename], '-r500','-nocrop','-a2'); 
    fileName3 = cell2mat(strcat('Plate_',rowLabels(1,3),' vs',{' '},rowLabels(1,4),'.eps'));
    print('-depsc','-r300',[outputdir,filesep,fileName3]);
    close(hh2);
else
    set(hh2, 'color', 'w');
    secondFilename = cell2mat(strcat('Plate_',rowLabels(1,3),' vs',{' '},rowLabels(1,4),'.tif'));
    export_fig([outputdir,secondFilename], '-r500','-nocrop','-a2'); 
    fileName3 = cell2mat(strcat('Plate_',rowLabels(1,3),' vs',{' '},rowLabels(1,4),'.eps'));
    print('-depsc','-r300',[outputdir,filesep,fileName3]);
    close(hh2);
end
%%save out
save([outputdir,'outputPlotVariables.mat']);