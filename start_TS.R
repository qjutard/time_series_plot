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

source("pathways.R")
source("file_names.R")
source("open_profiles.R")
source("plot_TS.R")

### Get command arguments

uf = commandArgs(trailingOnly = TRUE)

WMO = uf[1]
PARAM_NAME = uf[2]
zoom_pres = uf[3]
zoom_param = uf[4]
date_axis = as.logical(uf[5])

if (WMO=="NA" | PARAM_NAME=="NA") {
    print("Please specify at least a WMO and a parameter name (see -h for help)")
    stop()
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

index_ifremer = read.table(path_to_index_ifremer, skip=9, sep = ",")

name_list = file_names(index_ifremer, path_to_netcdf_before_WMO, WMO, path_to_netcdf_after_WMO)


### Get a list with information on all profiles
#index_greylist = read.csv(path_to_index_greylist, sep = ",") # if greylist is useful at some point

numCores = detectCores()
M = mcmapply(open_profiles, name_list, MoreArgs=list(PARAM_NAME), mc.cores=numCores, USE.NAMES=FALSE)


### plot

ret = plot_TS(M, PARAM_NAME=PARAM_NAME, zoom_pres=zoom_pres, zoom_param=zoom_param, date_axis=date_axis)
