%% get_lags_adjacent_stations: 
% this function runs through the station pairs and computes the lags for them using wcoherence
% Yoram Terleth Jan 2024
function [lags,wcohs,periods, fns_combo] = getlags_adjacent_stations(matrix,fns,mc) 

% pad the matrix with the outermost values stations  
padded_matrix = [matrix(:,1),matrix,matrix(:,end)] ; 
padded_fns = [fns(1), fns, fns(end)]; 
fns_combo = padded_fns; 


% the for loop that goes through all the stations 
for i = length(fns):-1:1
    
    % cross wavelet anaylsis between ref and current station 
    [wcoh,wcs,period,coi] = wcoherence(padded_matrix(:,i), padded_matrix(:,i+1), hours(.5),'phasedisplaythreshold',0.5,'PeriodLimits',[hours(24*0.5) hours(24*14)]); 
    fns_temp = [padded_fns(i),'-',padded_fns(i+1)]; 
    fns_combo(i) =  {[fns_temp{:}]}; 
    
    % convert the time scales to days 
    period=days(period) ;
    coi = days(coi); 
    
    % obtain the angle of the arrows, representing phase lag 
    theta = angle(wcs) ; 
    
    % discard values below the threshold of covariance 
    % threshold 
    theta(wcoh < mc) = NaN;
    
    
    % calculate the actual delay between the two signals (in days)
    lag = (theta.*period)./(2*pi) ; 

    % record values 
    wcohs(:,:,i) = wcoh ; 
    lags(:,:,i) = lag ;
    periods(:,:,i) = period ; 
    
    
   
end 
   
