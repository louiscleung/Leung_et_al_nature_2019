% RASTERPLOT.M Display spike rasters.
%   RASTERPLOT(T,N,L) Plots the rasters of spiketimes (T in samples) for N trials, each of length
%   L samples, Sampling rate = 1kHz. Spiketimes are hashed by the trial length.
% 
%   RASTERPLOT(T,N,L,H) Plots the rasters in the axis handle H
%
%   RASTERPLOT(T,N,L,H,FS) Plots the rasters in the axis handle H. Uses sampling rate of FS (Hz)
%
%   Example:
%          t=[10 250 9000 1300,1600,2405,2900];
%          rasterplot(t,3,1000)
%

% Rajiv Narayan
% askrajiv@gmail.com
% Boston University, Boston, MA

function rasterplot_LL(times,numtrials,triallen, varargin)

nin=nargin;

%%%%%%%%%%%%%% Plot variables %%%%%%%%%%%%%%
plotwidth=0.1;     % spike thickness changed from 1 -> 0.1
plotcolor='k';   % spike color
trialgap=1;    % distance between trials, changed from 1.5. use 1 for lines and 0.2 for marker
defaultfs=2;  % default sampling rate
showtimescale=1; % display timescale
showlabels=1;    % display x and y labels

%%%%%%%%% Code Begins %%%%%%%%%%%%
switch nin
 case 3 %no handle so plot in a separate figure
  figure;
  hresp=gca;
  fs=defaultfs;
 case 4 %handle supplied
  hresp=varargin{1};
  if (~ishandle(hresp))
    error('Invalid handle');
  end
  fs=defaultfs;
 case 5 %fs supplied
  hresp=varargin{1};
  if (~ishandle(hresp))
    error('Invalid handle');
  end
  fs = varargin{2};        
 otherwise
  error ('Invalid Arguments');
end


 % plot spikes

  trials=ceil(times/triallen);
  reltimes=mod(times,triallen);
  reltimes(~reltimes)=triallen;
  numspikes=length(times);
  xx=ones(3*numspikes,1)*nan;
  yy=ones(3*numspikes,1)*nan;

  yy(1:3:3*numspikes)=(trials-1)*trialgap;
  yy(2:3:3*numspikes)=yy(1:3:3*numspikes)+1;
  %scale yy
  %yy=yy/2; %I added this so it is optional
  
  %scale the time axis to ms
  xx(1:3:3*numspikes)=reltimes*1000/fs;
  xx(2:3:3*numspikes)=reltimes*1000/fs;
  xlim=[1,triallen*1000/fs];

  axes(hresp);
  h=plot(xx, yy, plotcolor, 'linewidth',plotwidth);
  %h2=plot(xx, yy, plotcolor, 'linestyle', 'none','Marker','.','MarkerSize',1);
  axis ([xlim,0,numtrials]); 
  axis off %turn axis off
  
  if (showtimescale)
    set(hresp,'tickdir','out');        
  else
    set(hresp,'ytick',[],'xtick',[]);
  end
  
  if (showlabels)
    xlabel('Time(mins)');
    ylabel('Neuron ROIs');
  end
  
  
