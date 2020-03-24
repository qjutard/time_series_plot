#############################################################################
# Function to build a list of profile file names from the argo index, a WMO,
# and the local path to the files
#############################################################################

require(stringr)
require(stringi)

file_names <- function(index_ifremer, path_to_netcdf, WMO, core_files=FALSE, full_path=NULL) {
	
    files = as.character(index_ifremer$file) #retrieve the path of each netcfd file
    ident = strsplit(files,"/") #separate the different roots of the files paths
    ident = matrix(unlist(ident), ncol=4, byrow=TRUE)
    dac = ident[,1]
    wod = ident[,2] #retrieve the WMO of all profiles as a vector
    prof_B = ident[,4] #retrieve all profiles  name as a vector
	
	if (is.null(full_path)) {
		full_path_to_netcdf = paste(path_to_netcdf, dac, "/", WMO , "/profiles/", sep="")
		full_path_to_netcdf = full_path_to_netcdf[which(wod == WMO)]
	} else {
		full_path_to_netcdf = full_path
	}

	if (!core_files) {
	    
	    name_list = paste(full_path_to_netcdf, prof_B[which(wod == WMO)], sep="")
	    
	} else {
	    
    	# build file names with '?'
    	prof_id = str_sub(prof_B, 3) # remove 'MD'
        prefix = "?"
    	prof_id = paste(full_path_to_netcdf, prefix, prof_id[which(wod == WMO)], sep="")
    	
    	# identify R or D file
    	name_list = rep(NA, length(prof_id))
    	for (i in 1:length(prof_id)) {
    	    ls_match = system2("ls", prof_id[i], stdout=TRUE) 
    	    if (length(ls_match) == 2) { # if both R and D files exist
    	        name_list[i] = ls_match[1] # use the D file which is first in alphabetical order
    	    } else {
    	        name_list[i] = ls_match
    	    }
    	}
	}
	
	return(name_list)
}
