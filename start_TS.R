#############################################################################
# This script calls the different steps of the plot (opening, plotting...)
# It should be called from bash, specifically from BGTS.sh
#############################################################################

library(ncdf4)
library(oce)
library(MASS)
library(stringr)
library(parallel)
library(stringi)

source("~/Documents/time_series/time_series_plot/pathways.R")
source(paste(path_to_source, "file_names.R", sep=""))
source(paste(path_to_source, "open_profiles.R", sep=""))
source(paste(path_to_source, "plot_TS.R", sep=""))

### Get command arguments

uf = commandArgs(trailingOnly = TRUE)

WMO = uf[1]
PARAM_NAME = uf[2]
zoom_pres = uf[3]
zoom_param = uf[4]
date_axis = as.logical(uf[5])
plot_name = uf[6]
core_files = as.logical(uf[7])

if (WMO=="NA" | PARAM_NAME=="NA") {
    print("Please specify at least a WMO and a parameter name (see -h for help)")
    stop()
}

if (plot_name=="NA") {
    plot_name = paste("BGTS_", WMO, "_", PARAM_NAME, ".png", sep="")
}

# convert text inputs to usable data
if (zoom_pres=="NA") {
    zoom_pres = NULL
} else {
    zoom_pres = as.numeric(unlist(strsplit(zoom_pres, ";")))
}

if (zoom_param=="NA") {
    zoom_param = NULL
} else {
    zoom_param = as.numeric(unlist(strsplit(zoom_param, ";")))
}


### Build list of file names from WMO and argo_index

index_ifremer = read.table(path_to_index_ifremer, sep=",", header = T)
#index_greylist = read.csv(path_to_index_greylist, sep = ",") # if greylist is useful at some point

name_list = file_names(index_ifremer, path_to_netcdf, WMO, core_files)


### Get a list with information on all profiles
numCores = detectCores()
M = mcmapply(open_profiles, name_list, MoreArgs=list(PARAM_NAME, core_files), mc.cores=numCores, USE.NAMES=FALSE)


### plot
ret = plot_TS(M, PARAM_NAME=PARAM_NAME, plot_name=plot_name, zoom_pres=zoom_pres, zoom_param=zoom_param, date_axis=date_axis)
