function [] = ViewpointFigModeSingle(dirname,excel,needTotalBoxBool,...
									vpWake,vpSleep,vpTime,vpBoxdata,rowLabels,...
									d2n,n2d,outputdir,threehrBool,oneDayBool);

%Row Colors
%wake
rowColors{1,1} = [0.0, 0.0, 0.5];
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

yy = 1;
while yy == 1
    prompt4 = {'Selected well for creating figure: '};
    dlg_title4 = 'Set time of treatment';
    num_lines4 = 1;
    default4 = {'1'};
    answer4 = inputdlg(prompt4,dlg_title4,num_lines4,default4);
    viewpointROI = str2double(cell2mat(answer4(1)));
    %reassign data sets
    vpWakeROI = vpWake(:,viewpointROI);
    vpSleepROI = vpSleep(:,viewpointROI);
    %stats
    vpWakeM = nanmean(vpWakeROI,2);
    vpSleepM = nanmean(vpSleepROI,2);
    std_1 = nanstd(vpWakeROI')';
    std_2 = nanstd(vpSleepROI')';
    vpWakeS = std_1./sqrt(size(vpWakeROI,2));
    vpSleepS = std_2./sqrt(size(vpSleepROI,2));
    %zscore
    vpWakeZ = bsxfun(@rdivide, bsxfun(@minus, vpWakeROI, nanmean(vpWakeROI,1)), nanstd(vpWakeROI,0,1));
    vpSleepZ = bsxfun(@rdivide, bsxfun(@minus, vpSleepROI, nanmean(vpSleepROI,1)), nanstd(vpSleepROI,0,1));

    %% One big combined figure
	hh = figure('Position', [10, 10, 800, 800]);
	[~,condVal,~] = fileparts(excel);

	subplot(4,6,1:2)
		b1 = boxplot(vpWakeROI);
		%boxplot properties
		set(b1(1,:),'LineStyle','-','Color',rowColors{1,1}); %set the top line to color of row
		set(b1(2,:),'LineStyle','-','Color',rowColors{1,1}); %set the top line to color of row
		set(b1(3,:),'Color',rowColors{1,1}); %Top line color
		set(b1(4,:),'Color',rowColors{1,1}); %Bottom line color - TODO - can box be filled?
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
		axis(gca,[0 (size(vpWakeROI,2)+1) 0 yscale])
		ylabel('Activity (sec/min)')
		boxtitle = sprintf('Well %d Actvity',viewpointROI);
		title(boxtitle)

	subplot(4,6,3:4)
		b2 = boxplot(vpSleepROI);
		%boxplot properties
		set(b2(1,:),'LineStyle','-','Color',rowColors{1,2}); %set the top line to color of row
		set(b2(2,:),'LineStyle','-','Color',rowColors{1,2}); %set the top line to color of row
		set(b2(3,:),'Color',rowColors{1,2}); %Top line color
		set(b2(4,:),'Color',rowColors{1,2}); %Bottom line color - TODO - can box be filled?
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
		set(gca,'FontSize',8)
		axis(gca,[0 (size(vpSleepROI,2)+1) 0 yscale2])
		ylabel('Sleep (min/10min)')
		boxtitle2 = sprintf('Well %d Sleep Duration',viewpointROI);
		title(boxtitle2)
	subplot(4,6,5)
		text(0,0.5,rowLabels(1,1:4))
		axis off
	subplot(4,6,[7:12])
		plot(vpWakeROI,'linewidth',0.5, 'color', rowColors{1,1});
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
		set(gca,'XTick',[])
		set(gca,'XColor','w')
		set(gca,'FontSize', 8)
		axis(gca, [0 inf 0 yscale])
		leg1 = sprintf('Well %d',viewpointROI);
		lx1 = legend (leg1,'Location','northeast');
		set(lx1,'FontSize',8)
		legend('boxoff');
		ylabel('Abs. Activity (sec/10min)')

	subplot(4,6,[13:18])
		plot(vpSleepROI,'linewidth',0.5, 'color', rowColors{1,2})
		hold on
		if ~isempty(startTreat2)
    		patch('Faces',[1 2 3 4],'Vertices',[startTreat2 0; endTreat2 0; endTreat2 yscale2; startTreat2 yscale2],...
         		 'FaceColor',patchColor, 'EdgeColor',patchColor,'FaceAlpha',0.3);
		end
		%plot empty triangle for day and filled for night
		for aa = 1: size(d2n,1)
 		    plot(d2n(aa),10,'v','Color','k','MarkerFaceColor','k'); %filled night
		end
		for bb = 1:size(n2d,1)
  		    plot(n2d(bb),10,'v','Color','k'); %empty day
		end
		set(gca,'XTick',[])
		set(gca,'XColor','w')
		set(gca,'FontSize',8)
		axis(gca, [0 inf 0 yscale2])
		leg2 = sprintf('Well %d',viewpointROI);
		lx2 = legend (leg2,'Location','northeast');
		set(lx2,'FontSize',8)
		legend('boxoff');
		ylabel('Abs. Sleep (min/10min)')

	if (needTotalBoxBool)
		subplot(4,6,19)
			b3 = boxplot(vpBoxdata(viewpointROI,1));
			set(gca,'XTick',[])
    		set(gca,'XColor','w')
    		set(gca,'FontSize',8)
    		set(gca,'XTickLabel',{' '}) 
    		ylabel('Day Activity (sec/min)')
    		title('Total Day Activity')
		subplot(4,6,20)
			b4 = boxplot(vpBoxdata(viewpointROI,2));
			set(gca,'XTick',[])
    		set(gca,'XColor','w')
    		set(gca,'FontSize',8)
    		set(gca,'XTickLabel',{' '}) 
    		ylabel('Day Sleep (min/hr)')
    		title('Total Day Sleep')
		subplot(4,6,21)
			b5 = boxplot(vpBoxdata(viewpointROI,3));
			set(gca,'XTick',[])
    		set(gca,'XColor','w')
    		set(gca,'FontSize',8)
    		set(gca,'XTickLabel',{' '}) 
    		ylabel('Night Activity (sec/min)')
    		title('Total Night Activity')
		subplot(4,6,22)
			b6 = boxplot(vpBoxdata(viewpointROI,4));
			set(gca,'XTick',[])
    		set(gca,'XColor','w')
    		set(gca,'FontSize',8)
    		set(gca,'XTickLabel',{' '}) 
    		ylabel('Night Sleep (min/hr)')
    		title('Total Night Sleep')

		%Export figure hh
    	set(hh, 'color', 'w');
    	figureName = sprintf('Figure_Well_%d.tif',viewpointROI);
    	export_fig([outputdir,figureName], '-r500','-nocrop','-a2'); 
    	close(hh);
    else
    	%Export figure hh
    	set(hh, 'color', 'w');
    	figureName = sprintf('Figure_Well_%d.tif',viewpointROI);
    	export_fig([outputdir,figureName], '-r500','-nocrop','-a2'); 
    	close(hh);
    end
    %choose to end or do another well...
    choice = menu('Do you want to select another ROI?','Yes','No - Im done here!','position','center');
    if choice==1
    	matName = sprintf('supportingData_Well%d.mat',viewpointROI);
    	save([outputdir,matName]);
        yy = 1;
    else
       	yy = 0;
    end
end