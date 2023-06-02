%% LAG plot 
%% to avoid confusion, this script incorporates the full pipeline to get at the lags in relation to a single reference station, and plots them

%% clean up
close all
clear all
clc

% add path to helpers for plotting 
addpath 'C:/Users/Yoram/OneDrive - University of Idaho/Desktop/matlab_helpers/' 

%% input parameters

ref_station = 'SE15' ; 

dates = [datetime(2020,09,20):datetime(2022,08,01)]; 

% intialise fns, to get length
fns_init = {'SW2','SE7','SW7','SW8','SE9','SE12','SE14','SW14','SE15'};  %  {'SW2','SW7','SE7','SE9','SE14','SW14','SE15'}; 
%fns_init = {'SE15','SE7','SW2'} ; 

% initialise input array 
lag_array = nan(length(fns_init), length(dates)) ; 
coh_array = nan(length(fns_init), length(dates)) ; 

%% get lags 
disp('Computing lags...')


for ii = 1:length(dates)
    disp(['Working on ' datestr(dates(ii))])
    
   % load the lag for each station at this timestep
   [lags,coh,fns] = get_lags(ref_station, dates(ii)); 
   
   
   % add these to array 
   lag_array(:,ii) = lags' ; 
   coh_array(:,ii) = coh' ; 
   
end 

%% save the lags matrix 
save('lag_array_2020_2022_rel_to_SE15_2.mat', 'lag_array','coh_array', 'fns', 'dates')

%% visualisation

figure, imagesc(lag_array)

%% 
figure 
pcolor(dates, [1:length(fns_init)], lag_array*24), shading flat

yticks([1.5:1:8]) ;
yticklabels(fns_init);
c = colorbar ; 
ylabel(c,'hours') 
title('Lags relative to SE15')

cmap = flipud(abs(cbrewer('div','RdBu',128,'spline')));
cmap(cmap>1)=1; 
colormap(cmap)
caxis([-7,7])

%%
figure
linecolors = plasma(256); 
linecolor_step = [1:floor(length(linecolors)/length(fns_init)):256]; 
hold on 
for p = 1:length(fns_init)
    plot(dates, lag_array(p,:)*24,'linewidth',1.2, 'color', linecolors(linecolor_step(p),:))
end 
grid on 
ylabel('Lag (hours)')
legend(fns_init)
title('Lags relative to SE15')

% 
