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

WMO = "6901524"

### Build list of file names from WMO and argo_index
index_ifremer = read.table(path_to_index_ifremer, skip=9, sep = ",")

name_list = file_names(index_ifremer, path_to_necdf_before_WMO, WMO, path_to_netcdf_after_WMO)


### TODO
### do mcmapply(open_profiles) to get a table of profiles
index_greylist = read.csv(path_to_index_greylist, sep = ",")

### TODO
### plot
