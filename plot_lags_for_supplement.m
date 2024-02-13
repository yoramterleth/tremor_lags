%% lag plot for supplement 
% this script was used to generate the figure in the supplementary information. 

close all
clearvars 
clc

addpath 'C:\Users\Yoram\OneDrive - University of Idaho\Desktop\PhD pos\TURNER\seismic\GHT_matlab\'

%% load the lag array 

lgs = load('lag_array_simplified_long_4.mat') ; 

%%

% set linewidth 
lw = 1.2 ; 
% set times
times = [datetime(2020,09,15),datetime(2022,08,01)] ; 

fig = figure  ; 

%% plot the wavelet coehrence at specific times to explain the low lags  

 % define colormap 
cmap = flipud(abs(cbrewer('div','RdBu',128,'spline')));
cmap(cmap>1)=1; 
color_upper = cmap(end-10,:) ; 
color_lower = cmap(10,:) ; 
fa_patch = 0.2 ; 

 % part one 
 time_window1 = [datetime(2021,3,10),datetime(2021,4,10)] ; 
 color_w_1 = rgb('emerald') ; 
 WC = com_wavelet_coherence(time_window1,{'SE7','SW2'}) ; 
 
sept1 = subplot(4,2,1) ;
plot(WC.time, WC.data(:,1),'-',LineWidth=lw,color=color_upper), hold on 
plot(WC.time, WC.data(:,2),'-',LineWidth=lw,color=color_lower) 
xlim(time_window1)
grid on 
sept1.XAxis.Visible = 'off' ; 
ylabel({'Seismic power'; '3-10 Hz (dB)'})
legend('SE7','SW2','Location','SouthEast')
set(sept1,'YColor',color_w_1)
box(sept1,"on",'color',color_w_1)

sept2 =  subplot(4,2,3) ; 
h=pcolor(WC.time,WC.period,WC.lag*24); hold on 
shading flat 
colormap(cmap)
%plot(WC.t_plot,(coi),'k--','linewidth',2)
ylabel('Period (days)')
h.EdgeColor = 'none';
set(gca,'Yscale','log')
yticks([1,2,5,10,14])
c1 = colorbar('color',color_w_1);
c1.Position = [0.47,0.57,0.01,0.12] ; 
clim([-10,10] );  % -max(abs(WC.lag(:)*24)); max(abs(WC.lag(:)*24))])
ylabel(c1, 'Phase lag (hours)') 
grid on 
box(sept2,"on",'color',color_w_1)
set(gca,'layer','top')
set(sept2,'YColor',color_w_1)
set(sept2,'XColor',color_w_1)
xlim(time_window1)
yline(3,'--',LineWidth=lw+.5,Color=color_w_1)
yline(5,'--',LineWidth=lw+.5,Color=color_w_1)

% part two 
 time_window2 = [datetime(2022,06,01),datetime(2022,08,01)] ; 
 color_w_2 = rgb('pinkish purple') ; 
 WC = com_wavelet_coherence(time_window2,{'SE15','SE7'}) ; 
 
sept2 = subplot(4,2,2) ;
plot(WC.time, WC.data(:,1),'-',LineWidth=lw,color=color_upper), hold on 
plot(WC.time, WC.data(:,2),'-',LineWidth=lw,color=color_lower) 
grid on 
sept2.XAxis.Visible = 'off' ; 
ylabel({'Seismic power'; '3-10 Hz (dB)'})
legend('SE15','SE7','Location','SouthEast')
set(sept2,'YColor',color_w_2)
box(sept2,"on",'color',color_w_2)
xlim(time_window2)
sept2 =  subplot(4,2,4) ; 
h=pcolor(WC.time,WC.period,WC.lag*24); hold on 
shading flat 
colormap(cmap)
%plot(WC.t_plot,(coi),'k--','linewidth',2)
ylabel('Period (days)')
h.EdgeColor = 'none';
set(gca,'Yscale','log')
yticks([1,2,5,10,14])
c2 = colorbar('color',color_w_2);
c2.Position = [0.91,0.57,0.01,0.12] ; 
clim([-max(abs(WC.lag(:)*24)); max(abs(WC.lag(:)*24))])
ylabel(c2, 'Phase lag (hours)')
grid on 
box(sept2,"on",'color',color_w_2)
set(gca,'layer','top')
set(sept2,'YColor',color_w_2)
set(sept2,'XColor',color_w_2)
xlim(time_window2)
yline(3,'--',LineWidth=lw+.5,Color=color_w_2)
yline(5,'--',LineWidth=lw+.5,Color=color_w_2)

%% now delete lags that are below the coherence threshold value 
lag_highco = lgs.lag_array ; 
lag_highco(lgs.coh_array < 0.7) = nan ; 

LAGS_H = subplot(4,2,[5,6]) ; 

    scatter(lgs.dates, lag_highco(2,:).*24,'linewidth',lw,'MarkerEdgeColor','k','MarkerFaceColor',rgb('bluey purple')), hold on
    scatter(lgs.dates, lag_highco(3,:).*24,'linewidth',lw,'MarkerEdgeColor','k','MarkerFaceColor',rgb('faded red'))
    %legend(lgs.fns_combo{2:end})
    set(LAGS_H, 'box','off')
    set(LAGS_H,'YColor',	rgb('bluey purple')) ; 
    set(LAGS_H,'fontweight','bold')
    xlim([times(1),times(2)]);
    %set(LAGS, 'XTickLabel',[], 'xtick', []);
    LAGS_H.XAxis.Visible='off' ;
    ylim([-15,25]); 
    LAGS_H.XGrid = 'on';   
    LAGS_H.YGrid = 'on';
    ylabel({'High coherence phase lag';' between station pairs (hours)'})
    LAGS_H.YAxisLocation = 'left'; 
    %xticks(ticks)
    yline(0,LineWidth=2,Color=rgb('bluey purple'))

    vfill(time_window1,color_w_1,'FaceAlpha',fa_patch, 'EdgeColor', 'none')
    vfill(time_window2,color_w_2,'FaceAlpha',fa_patch, 'EdgeColor', 'none')

%% now delete lags that are lower than ~ 1hour 
lag_final = lag_highco ; 
lag_final(lag_highco<(0/24))=nan ; 

LAGS_E = subplot(4,2,[7,8]) ; 

    scatter(lgs.dates, lag_final(2,:).*24,'linewidth',lw,'MarkerEdgeColor','k','MarkerFaceColor',rgb('bluey purple')), hold on
    scatter(lgs.dates, lag_final(3,:).*24,'linewidth',lw,'MarkerEdgeColor','k','MarkerFaceColor',rgb('faded red'))
    %legend(lgs.fns_combo{2:end})
    set(LAGS_E, 'box','off')
    set(LAGS_E,'YColor',	rgb('bluey purple')) ; 
    set(LAGS_E,'fontweight','bold')
    xlim([times(1),times(2)]);
    %set(LAGS, 'XTickLabel',[], 'xtick', []);
    LAGS_E.XAxis.Visible='on' ;
    ylim([-2,25]); 
    LAGS_E.XGrid = 'on';   
    LAGS_E.YGrid = 'on';
    ylabel({'Positive high coherence phase lag'; 'between station pairs (hours)'})
    LAGS_E.YAxisLocation = 'right'; 
    yline(0,LineWidth=2,Color=rgb('bluey purple'))
    %xticks(ticks)
    
    legend('SE15 - SE7','SE7 - SW2')

AddLetters2Plots(fig, {'(a)','(b)','(c)','(d)','(e)','(f)'},'VShift', -0.005,'Location','NorthWest', 'Direction','LeftRight')
 
%% plot all the lags relative to sE15 

lgs = load('lag_array_2020_2022_rel_to_SE15_2.mat') ; 
% set linewidth 
lw = 1.2 ; 
% set times
times = [datetime(2020,09,15),datetime(2022,08,01)] ; 

fig = figure  ; 
LAGS = subplot(3,1,1) ; 
hold on 
for p = 1:length(lgs.lag_array(:,1))-1
    scatter(lgs.dates, lgs.lag_array(p,:).*24)%,'linewidth',lw,'MarkerEdgeColor','k') %,'MarkerFaceColor',rgb('bluey purple')), hold on
end 
    set(LAGS, 'box','off')
    set(LAGS,'YColor',	rgb('bluey purple')) ; 
    set(LAGS,'fontweight','bold')
    xlim([times(1),times(2)]);
    %set(LAGS, 'XTickLabel',[], 'xtick', []);
    LAGS.XAxis.Visible='off' ;
    ylim([-17,17]); 
    LAGS.XGrid = 'on';   
    LAGS.YGrid = 'on';
    ylabel({'Raw time lag between', 'station pairs (hours)'})
    legend(lgs.fns)
    LAGS.YAxisLocation = 'left'; 

%% now delete lags that are below the coherence threshold value 
lag_highco = lgs.lag_array ; 
lag_highco(lgs.coh_array < 0.7) = nan ; 

LAGS_H = subplot(3,1,2) ; 
hold on 
for p = 1:length(lgs.lag_array(:,1))-1
    scatter(lgs.dates, lag_highco(p,:).*24)%,'linewidth',lw,'MarkerEdgeColor','k') %,'MarkerFaceColor',rgb('bluey purple')), hold on
end 
    set(LAGS_H, 'box','off')
    set(LAGS_H,'YColor',	rgb('bluey purple')) ; 
    set(LAGS_H,'fontweight','bold')
    xlim([times(1),times(2)]);
    %set(LAGS, 'XTickLabel',[], 'xtick', []);
    LAGS_H.XAxis.Visible='off' ;
    ylim([-17,17]); 
    LAGS_H.XGrid = 'on';   
    LAGS_H.YGrid = 'on';
    ylabel({'High coherence time lag between', 'station pairs (hours)'})
    LAGS_H.YAxisLocation = 'left'; 
    %xticks(ticks)

%% now delete lags that are lower than ~ 1hour 
lag_final = lag_highco ; 
lag_final(lag_highco<(0/24))=nan ; 

LAGS_E = subplot(3,1,3) ; 
hold on 
for p = 1:length(lgs.lag_array(:,1))-1
    scatter(lgs.dates, lag_final(p,:).*24)%,'linewidth',lw,'MarkerEdgeColor','k') %,'MarkerFaceColor',rgb('bluey purple')), hold on
end 
    %legend(lgs.fns_combo{2:end})
    set(LAGS_E, 'box','off')
    set(LAGS_E,'YColor',	rgb('bluey purple')) ; 
    set(LAGS_E,'fontweight','bold')
    xlim([times(1),times(2)]);
    %set(LAGS, 'XTickLabel',[], 'xtick', []);
    LAGS_E.XAxis.Visible='on' ;
    ylim([-2,15]); 
    LAGS_E.XGrid = 'on';   
    LAGS_E.YGrid = 'on';
    ylabel({'Positive high coherence time lag'; 'between station pairs (hours)'})
    LAGS_E.YAxisLocation = 'left'; 
    %xticks(ticks)



    %% 
    lag_highco = lgs.lag_array ; 
    lag_highco(lgs.coh_array < 0.7) = nan ; 
    figure 
    LAGS_E = subplot(1,1,1) ; 
hold on 

colors=flipud(plasma(length(lgs.lag_array(:,1))-1)); 

for p = length(lgs.lag_array(:,1))-1:-1:1
    %scatter(lgs.dates, lag_final(p,:).*24,'linewidth',lw,'MarkerEdgeColor','k','MarkerFaceColor',colors(p,:)), hold on
    scatter(lgs.dates, lag_highco(p,:).*24,'linewidth',lw,'MarkerEdgeColor','k','MarkerFaceColor',colors(p,:)), hold on
end 
    %legend(lgs.fns_combo{2:end})
    set(LAGS_E, 'box','off')
    set(LAGS_E,'YColor',	rgb('bluey purple')) ; 
    set(LAGS_E,'fontweight','bold')
    xlim([times(1),times(2)]);
    %set(LAGS, 'XTickLabel',[], 'xtick', []);
    LAGS_E.XAxis.Visible='on' ;
    ylim([-13,28]) ; % max(lgs.lag_array(:))*24+1]); 
    LAGS_E.XGrid = 'on';   
    LAGS_E.YGrid = 'on';
    ylabel({'Positive high coherence time lag'; 'relative to SE15 (hours)'})
    LAGS_E.YAxisLocation = 'left'; 
    yline(0,'--k')
    legend(fliplr(lgs.fns(1:end-1)))
    
    %xticks(ticks)

    %% lags highco to csv 
    matrix =  lag_highco'.*24 ; 
    lags_GHT = array2table(matrix,VariableNames=lgs.fns) ; 
    lags_GHT.time = lgs.dates' ; 

   % Save Table as CSV
    writetable(lags_GHT, 'SK_lags_GHT.csv');
