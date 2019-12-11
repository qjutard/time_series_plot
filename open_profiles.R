#############################################################################
# This script defines the open_profiles() function which returns a parameter, 
# its pressure axis, its QC, and its date.
#############################################################################

require(ncdf4)
require(MASS)
require(stringr)
require(stringi)

open_profiles <- function(profile_name, PARAM_NAME) {
	# profile_name is a full path to the file, PARAM_NAME is consistent
	# with bgc-argo denomination

    filenc = nc_open(profile_name, readunlim=FALSE, write=FALSE)
	
	### find the profile index	
    parameters = ncvar_get(filenc,"STATION_PARAMETERS")
	param_name_padded = str_pad(PARAM_NAME, 64, "right")
	id_prof = which(parameters==param_name_padded, arr.ind=TRUE)[2]
	
	### get the parameter
	PARAM = ncvar_get(filenc, PARAM_NAME)
	PARAM = PARAM[,id_prof]

	### get the pressure
	PRES = ncvar_get(filenc, "PRES")	
	PRES = PRES[,id_prof]

	### get the QC
	PARAM_NAME_QC = paste(PARAM_NAME, "_QC", sep="")
	PARAM_QC = ncvar_get(filenc, PARAM_NAME_QC)
	PARAM_QC = PARAM_QC[id_prof]
	PARAM_QC = unlist(strsplit(PARAM_QC, ""))

	### get the date (JULD)
	JULD = ncvar_get(filenc, "JULD")
	JULD = JULD[id_prof]

	nc_close(filenc)
	
	return(list("PARAM"=PARAM, "PRES"=PRES, "PARAM_QC"=PARAM_QC, "JULD"=JULD))
}

