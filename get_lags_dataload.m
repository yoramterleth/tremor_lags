function [matrix, ref_st, t_plot, fns, fns_loc, S] = get_lags_dataload(ref_station)

% this function compiles glaciohydraulic tremor time series from a mat file and formats 
% them correctly for the next processing steps. 

%% Time parameters:
% Define start and end times
s_time = datetime(2020, 9, 15);
e_time = datetime(2022, 8, 5);

%% Load data 
load('C:/Users/Yoram/OneDrive - University of Idaho/Desktop/PhD pos/TURNER/seismic/GHT_matlab/mat_files/mat_file_all.mat');

% Extract data from loaded mat file
stations = a{1, 1};
freq_range = a{1, 2};

% Compute the time steps
steps = length(stations.SE9.t);
TIME = linspace(s_time, e_time, steps);

% Define station names
fns = {'SW2', 'SE7', 'SW7', 'SW8', 'SE9', 'SE12', 'SE14', 'SW14', 'SE15'};
fns_loc = [2, 7, 7, 9, 14, 14, 15]; % Station locations

%% Create data matrix
matrix = [];
for i = 1:length(fns)
    t = datetime(stations.(fns{i}).t, 'ConvertFrom', 'posixtime');
    cur_col = stations.(fns{i}).powdB';
    cur_col = cur_col(t > s_time & t < e_time);
    norm_cur_col = cur_col; %- nanmean(cur_col(:));
    matrix = [matrix, norm_cur_col];
end

%% Find the reference station and separate it out 
ref_station_idx = find(strcmp(fns, ref_station));
ref_st = matrix(:, ref_station_idx);
ref_st(isnan(ref_st)) = mean(ref_st(:), 'omitnan');

%% Store main matrix and additional info
t_plot = t(t > s_time & t < e_time);
norm_mat = matrix - mean(matrix, 2, 'omitnan');
matrix(isnan(matrix)) = mean(matrix(:), 'omitnan');
norm_mat(isnan(norm_mat)) = mean(norm_mat(:), 'omitnan');

%% Store data into a table for convenience
S = array2table(matrix, 'VariableNames', fns);
end
