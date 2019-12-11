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

### TODO
### Build list of file names from WMO and argo_index

### TODO
### mcmapply(open_profiles) to get a table of profiles

### TODO
### plot
