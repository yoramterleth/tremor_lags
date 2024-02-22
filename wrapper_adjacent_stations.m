%% wrapper adjacent stations
% 
% Yoram Terleth, Jan 2024
% 
% 
% this is the main script that calls the other functions. 
% provide .mat files made with med_spec_loop
% (https://github.com/tbartholomaus/med_spec)

% provide station names in that file. It is possible to provide anywhere
% between two, and the maximum ammount of station names contained in the
% mat file. 
%% clean up
close all
clear all
clc

% add path to helpers for plotting 
addpath 'C:/Users/Yoram/OneDrive - University of Idaho/Desktop/matlab_helpers/' 

%% input parameters

% filepath to mat file of GHT timeseries to draw from 
filepath = 'C:/Users/Yoram/OneDrive - University of Idaho/Desktop/PhD pos/TURNER/seismic/GHT_matlab/mat_files/mat_file[3, 10]all.mat' ; 

% date range to investigate 
startdate = datetime(2020,09,16,00,00,00); 
enddate = datetime(2023,08,01,00,00,00); 
interval = hours(24) ; 
dates = [startdate:interval: enddate]; 

%stations to investigate 
fns_init = {'SE15','SE9'} ; 

% period of oscillation at which to consider lags in days and between 1/2 day
% and 13 days.
show_period = 4 ; 

% covariance threshold below which we discard the lags 
mc = .7; 

% give a filename for saving the lag array (if empty no saving)
save_lags_name = [] ;  % '2024_lags.mat'

%% load in matrix of stations 
disp('Loading in data...')
[matrix,t_plot, fns, S] = dataload_adjacent_stations(filepath, fns_init, dates) ; 

% corect dates to make sure they fall on seismic data schedule
true_dates_start = t_plot(t_plot>startdate) ; 
true_dates_end = t_plot(t_plot<enddate) ; 
true_dates = true_dates_start(1):interval:true_dates_end(end) ; 

%% get lags 
disp('Computing lags...')
[lags,wcohs,periods, fns_combo] = getlags_adjacent_stations(matrix,fns,mc) ; 

%% pulling timeseries 
disp('Retrieving lag timeseries...')
[lag_array,coh_array,fns_out] = retrieve_specific_lags_adjacent_stations(fns,true_dates,show_period,lags,wcohs,periods,t_plot) ; 


%% plot the lags 
figure
hold on 
for j = 1:length(fns)
    scatter(true_dates,lag_array(j,:),'filled')
end 
legend(fns_combo)
ylabel('high coherence 3-5 day lags between tremor timeseries (days)')

%% save the lags matrix 
if ~isempty(save_lags_name) 
    save(save_lags_name, 'lag_array','coh_array', 'fns','fns_combo', 'true_dates')
    disp('Saved lag array')
end 

