function [] = wellMatrix(vpWake, vpSleep, dirname,...
                        deletedWellIdx,d2n,n2d,outputdir,threehrBool);

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

hh = figure('Position', [10, 10, 1500, 1500]);
title('Wake Matrix')
for ii = 1:size(vpWake,2)
	vpWakeROI = vpWake(:,ii);
    %subplot(4,6,ii)
	subplot(4,12,2*ii-1:2*ii)
    %subplot(4,18,3*ii-2:3*ii)
    if ismember(ii,deletedWellIdx)
    %if any(deletedWellIdx(:)==ii)
    	text(0.2,0.5,'User removed Well');
    else
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
        %plot triangle for treatment in a 3hr drug
        if threehrBool == 1;
            plot(60, yscale, 'v','color','r','MarkerFaceColor','r');
        end
		set(gca,'XTick',[])
		%set(gca,'XColor','w')
		set(gca,'FontSize', 8)
		axis(gca, [0 inf 0 yscale])
		leg = sprintf('Well %d',ii);
% 		lx1 = legend (leg,'Location','northeast');
% 		set(lx1,'FontSize',8)
% 		legend('boxoff');
    	xlabel(leg)
    	if ii==1 || ii==7 || ii==13 || ii==19
        	ylabel('Abs. Activity (sec/10min)')
    	end
    end
end
%Export figure hh
set(hh, 'color', 'w');
wakeFilename = 'wakeMatrix.tif';
export_fig([outputdir,wakeFilename], '-r500','-nocrop','-a2'); 
close(hh);

hh2 = figure('Position', [10, 10, 1500, 1500]);
for jj = 1:size(vpSleep,2)
	vpSleepROI = vpSleep(:,jj);
    %subplot(4,6,jj)
	subplot(4,12,2*jj-1:2*jj)
    %subplot(4,18,3*jj-2:3*jj)
    if ismember(jj,deletedWellIdx)
    	text(0.2,0.5,'User removed Well');
    else
		plot(vpSleepROI,'linewidth',0.5, 'color', rowColors{1,2});
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
		%set(gca,'XColor','w')
		set(gca,'FontSize', 8)
		axis(gca, [0 inf 0 yscale2])
		leg2 = sprintf('Well %d',jj);
% 		lx2 = legend (leg2,'Location','northeast');
% 		set(lx2,'FontSize',8)
% 		legend('boxoff');
    	xlabel(leg2)
    	if jj==1 || jj==7 || jj==13 || jj==19
    		ylabel('Abs. Sleep (min/10min)')
    	end
    end
end
%Export figure hh
set(hh2, 'color', 'w');
sleepFilename = 'sleepMatrix.tif';
export_fig([outputdir,sleepFilename], '-r500','-nocrop','-a2'); 
close(hh2);
