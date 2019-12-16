#############################################################################
# This script calls the different steps of the plot (opening, plotting...)
# It should later be called from bash
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

WMO = "6901524"
PARAM_NAME = "CHLA"
zoom_pres = c(0,300)
zoom_param = c(0,15)

### Build list of file names from WMO and argo_index

index_ifremer = read.table(path_to_index_ifremer, skip=9, sep = ",")

name_list = file_names(index_ifremer, path_to_netcdf_before_WMO, WMO, path_to_netcdf_after_WMO)


### Get a list with information on all profiles
#index_greylist = read.csv(path_to_index_greylist, sep = ",") # if greylist is useful at some point

numCores = detectCores()
M = mcmapply(open_profiles, name_list, MoreArgs=list(PARAM_NAME), mc.cores=numCores, USE.NAMES=FALSE)


### TODO
### plot

ret = plot_TS(M, zoom_pres=zoom_pres, zoom_param=zoom_param)
