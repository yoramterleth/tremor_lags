% spatial variation: data loading fucntion: simply pulls the infromation
% from the .mat file. 
% Yoram Terleth, Jan 2024
function [matrix,t_plot, fns, S] = dataload_adjacent_stations(filepath, fns, dates)


%% time parameters:
% we need the whole series to compute the cross wavelet 
s_time = dates(1);                                               
e_time = dates(end); 


load(filepath) ;

stations = a{1,1} ; 

%% make array 
matrix = []; %zeros(length(time),length(fns)); 

for i = 1:length(fns)
    t = datetime(stations.(subsref(fns,substruct('{}',{i}))).t,'ConvertFrom','posixtime');
    cur_col = stations.(subsref(fns,substruct('{}',{i}))).powdB';
    cur_col = cur_col(t>s_time & t<e_time);
    
    matrix = [matrix,cur_col];
    
end 


%% store main matrix and add. info
t_plot = t(t>s_time & t<e_time); 
matrix(isnan(matrix)) = mean(matrix(:),'omitnan'); 


%% store into a table for convenience
S = array2table(matrix,'VariableNames',fns);
end 
 
 