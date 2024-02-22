# tremor_lags

This code repository accompanies a manuscript submitted to *Journal of Glaciology*. 

Code repository for the compution of lag times between coherent glacio-hydraulic tremor series acquired through a network of independent seismic stations. Utilizes the matlab wavelet coherence tools (https://www.mathworks.com/help/wavelet/ug/compare-time-frequency-content-in-signals-with-wavelet-coherence.html) Can be used to process the output of the med_spec scripts collection (https://github.com/tbartholomaus/med_spec). 

These scripts are meant to take the glaciohydraulic tremor timeseries produced with med_spec (https://github.com/tbartholomaus/med_spec). 

The main script is "wrapper_adjacent_stations.m", which calls the other functions. Here there are number of user specificied parameters, explained further in the script. Three functions are called: 
- data_load_adjacent_stations: data loading function that simply pulls the infromation from the .mat file.
- get_lags_adjacent_stations: this function runs through the station pairs and computes the lags for them using wcoherence.
- retrieve_specific_lags_adjacent_stations: this function takes the lag arrays and computes the median lag for a certain periodicity.

Finally, there is also com_wavelet_coherence.m, which is legacy and is left up because it shows the process of calcutlating lags quite well, and plot_lags_for_supplement.m, which was used to produce detailed lag plots. 
