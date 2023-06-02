%% plot individual lags plots 
function [WC] = com_wavelet_coherence(times,fns)

% time extent of interest 
s_time = times(1) ; % datetime(2021,07,01); 
e_time = times(2) ; % datetime(2021,8,25);

% apply moving mean to ght series?
smoothing = 1 ; % yes/no 
wdl = 12 ; % window length

normalise_data = 'none'  ;              % 'sqrt' or 'log10' or [] for no norm 

%% load data 
% load([pwd,'/mat_files/GHT_output_all[1.5_10Hz].mat'])
load('C:\Users\Yoram\OneDrive - University of Idaho\Desktop\PhD pos\TURNER\seismic\GHT_matlab\mat_files/mat_file_all.mat')

stations = a{1,1} ; 
freq_range = a{1,2} ; 

% times
steps = length(stations.SE7.t); 
TIME = linspace(s_time,e_time,steps); 
% fns = fieldnames(stations);

% here select the two station to compare:
% 1st is the reference to which lag of the second is computed: 
%fns = {'SE7','SW2'}  %,'SE7','SW7','SW8','SE9','SE14','SW14','SE15'}; 

% time = datetime(stations.SE7.t,'ConvertFrom','posixtime'); 

fns_loc = [2 7 7 8 9 14 14 15]; 
%% make array 
matrix = []; %zeros(length(time),length(fns)); 

for i = 1:length(fns)
    t = datetime(stations.(subsref(fns,substruct('{}',{i}))).t,'ConvertFrom','posixtime');
    cur_col = stations.(subsref(fns,substruct('{}',{i}))).powdB';
    cur_col = cur_col(t>s_time & t<e_time);
    
    %if length(matrix(:,1)) == length(norm_cur_col)
    matrix = [matrix,cur_col];
    %matrix(isnan(matrix))=0 ; 
    %else print([fns(i) 'not correct length'])
end 

t_plot = t(t>s_time & t<e_time); 
matrix(isnan(matrix)) = mean(matrix(:),'omitnan'); 
 

% apply movmean if requested 
 if smoothing 
     matrix(:,1) = movmean(matrix(:,1),wdl) ;
     matrix(:,2) = movmean(matrix(:,2),wdl) ;
 end 


 %% wavelet analysis
[wcoh,wcs,period,coi] = wcoherence(matrix(:,1),matrix(:,2),hours(.5),'phasedisplaythreshold',0.5,'PeriodLimits',[hours(24*0.5) hours(24*14)]); 
period=days(period) ;
coi = days(coi); 
theta = angle(wcs) ; 

%%%%%%%
% coherence threshold: show more or less of the lags on the plot
mc = .7; 
%%%%%%
theta(wcoh< mc) = NaN;

% what is the actual delay? (Grinsted et al) 
lag = (theta.*period)./(2*pi) ; 

% store data 
WC.lag = lag ; 
WC.data = matrix ; 
WC.period = period ; 
WC.time = t_plot ; 

end 

