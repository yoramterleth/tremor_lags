function [specific_lag,specific_wcoh, fns] = get_lags(ref_station, date) 

%% get_lags
% this function is called in the lags_wrapper. It computes the lags for all stations relative to one single reference station. 


%% script parameters 

ref_station_dist = 15 ; % [km]

show_date= date ;

% provide oscillation periodicity of the GHT signal you are interested in, in days and between 1/2 day
% and 13 days. 
show_period = 4 ; 

% turn on to show the velocities along the individual gaps between the
% stations. 
indiv_velocities = 0 ; 


%% load in the GHT data 
[matrix, ref_st, t_plot, fns, fns_loc] = get_lags_dataload(ref_station) ; 

%% the for loop that goes through all the stations 

for i = 1:length(fns)
    
    %% cross wavelet anaylsis between ref and current station 
    [wcoh,wcs,period,coi] = wcoherence(ref_st, matrix(:,i), hours(.5),'phasedisplaythreshold',0.5,'PeriodLimits',[hours(24*0.5) hours(24*14)]); 
    
    % convert the time scales to days 
    period=days(period) ;
    coi = days(coi); 
    
    % obtain the angle of the arrows, representing phase lag 
    theta = angle(wcs) ; 
    
    % set the threshold of covariation at .7, and discard values belwo that
    % threshold 
    mc = .7; 
    theta(wcoh< mc) = NaN;
    
    % calculate the actual delay between the two signals (in days)
    lag = (theta.*period)./(2*pi) ; 
    
    % get the coherence level 
    w_coherence = wcoh ; 
    
    %% selection of specific date and period for current station 
    % (in two steps in case we want to hold on to all lags later on)
    
    % select time 
    specific_lags(:,i) = lag(:,t_plot == show_date) ; 
    specific_wcohs(:,i) = w_coherence(:,t_plot == show_date) ; 

    % select specific period: +- one day. 
    show_period_min = show_period - 1 ;
    show_period_max = show_period + 1 ; 
    [~,idx_min] = min(abs(period-show_period_min)) ;
    [~,idx_max] = min(abs(period-show_period_max)) ;

    % take median of those time chunks 
    specific_lag(i) = median(specific_lags(idx_min:idx_max,i),'omitnan') ; 
    specific_wcoh(i) = max(specific_wcohs(idx_min:idx_max,i));  
        
end 
    


