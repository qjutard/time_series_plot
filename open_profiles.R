#############################################################################
# This script defines the open_profiles() function which returns a parameter, 
# its pressure axis, its QC, and its date.
#############################################################################

require(ncdf4)
require(MASS)
require(stringr)
require(stringi)

open_profiles <- function(profile_name, PARAM_NAME, core_files=FALSE) {
	# profile_name is a full path to the file, PARAM_NAME is consistent
	# with bgc-argo denomination

    filenc = nc_open(profile_name, readunlim=FALSE, write=FALSE)
	
	### find the profile index	
    parameters = ncvar_get(filenc,"STATION_PARAMETERS")
    if (core_files) {padding = 16} else {padding = 64}
	param_name_padded = str_pad(PARAM_NAME, padding, "right")
	id_prof_arr = which(parameters==param_name_padded, arr.ind=TRUE)
	if (is.null(dim(id_prof_arr))) { #if id_prof_arr is a vector, there is only one PARAM_NAME profile
	    id_prof = id_prof_arr[2]
	} else {
	    id_prof = id_prof_arr[1,2] #take the first profile
	    print(paste("Several profiles of", PARAM_NAME,"detected, only using the first one"))
	}
	if (is.na(id_prof))	{
		return(list("PARAM"=NA, "PRES"=NA, "PARAM_QC"=NA, "JULD"=NA, "param_units"=NA, "profile_id"=NA))
	}

	### get the parameter
	PARAM = ncvar_get(filenc, PARAM_NAME, start=c(1,id_prof), count=c(-1,1))
	#PARAM = PARAM[,id_prof]
	
	### get the pressure
	PRES = ncvar_get(filenc, "PRES", start=c(1,id_prof), count=c(-1,1))	
	#PRES = PRES[,id_prof]

	### get the QC
	PARAM_NAME_QC = paste(PARAM_NAME, "_QC", sep="")
	PARAM_QC = ncvar_get(filenc, PARAM_NAME_QC)
	PARAM_QC = PARAM_QC[id_prof]
	PARAM_QC = unlist(strsplit(PARAM_QC, ""))

	### get the date (JULD)
	JULD = ncvar_get(filenc, "JULD")
	JULD = JULD[id_prof]
	
	### get the units
	param_units = ncatt_get(filenc, PARAM_NAME, attname = "units")$value
	
	### get the profile index
	len = str_length(profile_name)
	profile_id = str_sub(profile_name, len-6, len-3) # extract 4 characters to '_000' or '000D'
	if (str_sub(profile_id,1,1)=="_") { # ascending profile
	    profile_id = as.numeric(str_sub(profile_id,2))
	} else {
	    profile_id = as.numeric(str_sub(profile_id,1,3)) - 0.5 # descending profiles are pur on half indices preceding the corresponding ascending profile
	}

	nc_close(filenc)
	
	return(list("PARAM"=PARAM, "PRES"=PRES, "PARAM_QC"=PARAM_QC, "JULD"=JULD, "param_units"=param_units, "profile_id"=profile_id))
}

