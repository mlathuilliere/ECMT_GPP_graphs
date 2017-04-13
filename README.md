# ECMT_GPP_graphs_README

This code takes data obtained from eddy covariance towers in Mato Grosso and plots time series information to be presented at the next Eddy Covariance in Mato Grosso meeting

Please organise the data in a .csv file with the following headers and columns (assuming measurements every 30-min). All gaps should be replaced by "NA".

timestamp      organized as dd-mm-yy hh:mm (in Excel) in GMT (to be converted to AMT in the code)
Precip         Precipitation in mm/30-min (to be converted into mm/d in the code)
Ra             Extraterrestrial radiation in MJ/m2-30min (to be converted in W/m2 in the code)
Rs             Incoming shortware radiation in W/m2
GPP            Gross Primary Productivity in umol/m2s
VWC            Soil volumetric water content in m3/m3

Some of the code may be tweaked based on the input data.

