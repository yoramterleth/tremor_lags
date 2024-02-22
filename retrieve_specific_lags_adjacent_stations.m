%% retrieve_specific_lags_adjacent_stations:
% this function takes the lag arrays and computes the median lag for a
% certain periodicity. 
% Yoram Terleth, Jan 2024
function [lag_array,coh_array,fns_out] = retrieve_specific_lags_adjacent_stations(fns,dates,show_period,lags,wcohs,periods,t_plot)

    % loop over all the dates in our querry date array 
    for ii = 1:length(dates)
        disp(['Working on ' datestr(dates(ii))])
    
        show_date = dates(ii) ; 
        
        
        % loop over the stations
        for i = length(fns):-1:1

            % select station combo
            lag = lags(:,:,i) ;
            wcoh = wcohs(:,:,i) ; 
            period = periods(:,:,i) ; 
    
            % select time 
            specific_lags = lag(:,t_plot == show_date) ; 
            specific_wcohs = wcoh(:,t_plot == show_date) ; 
        
            % select specific period: +- one day. 
            show_period_min = show_period - 1 ;
            show_period_max = show_period + 1 ; 
            [~,idx_min] = min(abs(period-show_period_min)) ;
            [~,idx_max] = min(abs(period-show_period_max)) ;
        
            % take median of those time chunks 
            specific_lag(i) = median(specific_lags(idx_min:idx_max),'omitnan') ; 
            specific_wcoh(i) = max(specific_wcohs(idx_min:idx_max));  
        end 
    
        
       % add these to array 
       lag_array(:,ii) = specific_lag' ; 
       coh_array(:,ii) = specific_wcoh' ; 

    end 

    % record the fns sequence we used 
    fns_out = [] ; 
    for i2 = length(fns):-1:1
        fns_out = [fns_out,fns(i2)] ; 
    end 
end       