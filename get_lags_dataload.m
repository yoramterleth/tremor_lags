% spatial variation: data loading fucntion, for tidiness puroposes 
function [matrix,ref_st,t_plot, fns, fns_loc,S] = get_lags_dataload(ref_station)


%% time parameters:
% we need the whole series to compute the cross wavelet 
s_time = datetime(2020,9,15);                                               
e_time = datetime(2022,8,5); 

%% load data 
%load(['C:/Users/Yoram/OneDrive - University of Idaho/Desktop/PhD pos/TURNER/seismic/GHT_matlab/mat_files/GHT_output_all[1.5_10Hz].mat'])
load(['C:/Users/Yoram/OneDrive - University of Idaho/Desktop/PhD pos/TURNER/seismic/GHT_matlab/mat_files/mat_file_all.mat']) ; 

stations = a{1,1} ; 
freq_range = a{1,2} ; 

% times
steps = length(stations.SE9.t); 
TIME = linspace(s_time,e_time,steps); 
fns = fieldnames(stations);
%fns = {'SW2','SW7','SE7','SE9','SE14','SW14','SE15'}; 
fns = {'SW2','SE7','SW7','SW8','SE9','SE12','SE14','SW14','SE15'}; 
%fns = {'SW2','SE9','SE14','SE15'}; 
%fns={'SW2'} ; 
%fns={'SE15','SE7','SW2'} ; 
time = datetime(stations.SE9.t,'ConvertFrom','posixtime'); % hours(stations.SE7.t(1))+ datetime(1970,01,01)

fns_loc = [2 7 7 9 14 14 15]; % the locations of the stations 

%% make array 
matrix = []; %zeros(length(time),length(fns)); 

for i = 1:length(fns)
    t = datetime(stations.(subsref(fns,substruct('{}',{i}))).t,'ConvertFrom','posixtime');
    cur_col = stations.(subsref(fns,substruct('{}',{i}))).powdB';
    cur_col = cur_col(t>s_time & t<e_time);
    norm_cur_col = cur_col ; %- nanmean(cur_col(:)); 
    
    %if length(matrix(:,1)) == length(norm_cur_col)
    matrix = [matrix,norm_cur_col];
    %matrix(isnan(matrix))=0 ; 
    %else print([fns(i) 'not correct length'])
end 


%% find the reference station and separate it out 
ref_station_idx = find(strcmp(fns,ref_station)); 
ref_st = matrix(:,ref_station_idx); 
ref_st(isnan(ref_st)) = mean(ref_st(:),'omitnan'); 

%% store main matrix and add. info
t_plot = t(t>s_time & t<e_time); 
norm_mat = matrix - mean(matrix,2,'omitnan'); 
matrix(isnan(matrix)) = mean(matrix(:),'omitnan'); 
norm_mat(isnan(norm_mat)) = mean(norm_mat(:),'omitnan'); 

%% store into a table for convenience
S = array2table(matrix,'VariableNames',fns);
end 
 
 