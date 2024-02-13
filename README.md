# tremor_lags

This code repository accompanies a manuscript submitted to *Journal of Glaciology*. 

Code repository for the compution of lag times between coherent glacio-hydraulic tremor series acquired through a network of independent seismic stations. Utilizes the matlab wavelet coherence tools (https://www.mathworks.com/help/wavelet/ug/compare-time-frequency-content-in-signals-with-wavelet-coherence.html) Can be used to process the output of the med_spec scripts collection (https://github.com/tbartholomaus/med_spec). 
A more detialed description is forthcoming. 

There are two approaches: 
- compute all lags relative to a single reference station, most likely the furthest upglacier one. For this use the script lags_wrapper.m. 
- compute lags relative to the adjacent station, in a user defined order. For this use the script lags_wrapper_adjacent_stations.m.
