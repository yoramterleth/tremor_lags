%% LAG plot 
%% to avoid confusion, this script incorporates the full pipeline to get at the lags in relation to adjacent stations, and plots them

%% clean up
close all
clear all
clc

% add path to helpers for plotting 
addpath 'C:/Users/Yoram/OneDrive - University of Idaho/Desktop/matlab_helpers/' 

%% input parameters

ref_station = 'SE15' ; 

dates = [datetime(2020,09,16):datetime(2022,08,01)]; 

% intialise fns, to get length
%fns_init =  {'SW2','SW7','SE7','SE9','SE14','SW14','SE15'}; 
%fns_init = {'SW2','SE9','SE14','SE15'}; 
fns_init = {'SE15','SE7','SW2'} ; 

% initialise input array 
lag_array = nan(length(fns_init), length(dates)) ; 
coh_array = nan(length(fns_init), length(dates)) ;

%% get lags 
disp('Computing lags...')


for ii = 1:length(dates)
    disp(['Working on ' datestr(dates(ii))])
    
   % load the lag for each station at this timestep
   [lags,coh,fns,fns_combo] = get_lags_adjacent_stations(dates(ii),ref_station); 
  
   
   % add these to array 
   lag_array(:,ii) = lags' ; 
   coh_array(:,ii) = coh' ; 
   
end 

%% save the lags matrix 
save('lag_array_simplified_long_4.mat', 'lag_array','coh_array', 'fns','fns_combo', 'dates')


%% make a corrected matrix, that exlcudes neg and very small values 
threshold = 1 /24 ; % lags smaller than one hour likely reflect moments with a signle source mechanism... 

% load the lags 
load([pwd,'/lag_array_simplified_long_4.mat']) ; 

% replace values below lag trheshold with nan
coh_array(lag_array<threshold)=nan ; 
lag_array(lag_array<threshold)=nan ; 


save('lag_array_corrected_long_4.mat', 'lag_array','coh_array', 'fns','fns_combo', 'dates')


%% visualisation
load lag_array.mat
lag_array(lag_array>0)=nan ; 
figure, imagesc(lag_array)

%% 
figure 
plt = subplot(1,1,1) ; 
pcolor(dates, [1:length(fns_init)], -flipud(lag_array*24)), shading flat

yticks([1.5:1:8]) ;
%yticklabels(fns_combo);
%yticklabels({'S15-SE14','SE14-SE9','SE9-SW2'})
%yticklabels({'SE15-SW14','SW14-SE14','SE14-SE9','SE9-SE7','SE7-SW7','SW7-SW2'})
c = colorbar ; 
ylabel(c,'hours','fontweight','bold') 
title('Adjacent lags')
set(plt,'fontweight','bold')
cmap = flipud(abs(cbrewer('div','RdBu',128,'spline')));
cmap = abs(cbrewer('seq','Reds',128,'spline'));
cmap(cmap>1)=1; 
colormap(cmap)
caxis([0,8])

grid on

ax = gca ; 
ax.Layer = 'top' ; 

%%
figure
linecolors = plasma(256); 
linecolor_step = [1:floor(length(linecolors)/length(fns_init)):256]; 
hold on 
for p = 1:length(fns_init)
    plot(dates, lag_array(p,:)*24,'linewidth',1.2) %, 'color', linecolors(linecolor_step(p),:))
end 
grid on 
ylabel('Lag (hours)')
legend(fns_combo)
title('Adjacent lags')

%% select out the 3 long distance ones 
% lags_select = lag_array([2,4,5],:)
% figure, imagesc(lags_select)

mean(-lag_array,2,'omitnan').*(24*3600) ./ [1; 5000; 1000; 3000; 5000; 100; 1000]
