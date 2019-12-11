#############################################################################
# This script does the time series plot
#############################################################################

plot_TS <- function(M) {

	### find array dimensions
	n_prof = dim(M)[2]
	N_DEPTH = rep(NA, n_prof)
	for (i in seq(1,n_prof)) {
		N_DEPTH[i] = length(M[,i]$PRES)
	}
	n_depth = max(N_DEPTH)

	### build arrays from M
	pres = array(NA, c(n_depth, n_prof))
	param = array(NA, c(n_depth, n_prof))
	param_qc = array(NA, c(n_depth, n_prof))
	juld = array(NA, c(n_depth, n_prof))
	
	for (i in seq(1,n_prof)) {
	
		n_pres_i = length(M[,i]$PRES)
	
		pres[1:n_pres_i, i] = M[,i]$PRES 
		param[1:n_pres_i, i] = M[,i]$PARAM 
		param_qc[1:n_pres_i, i] = M[,i]$PARAM_QC 
		juld[1:n_pres_i, i] = rep(M[,i]$JULD, n_pres_i) 

	}
	
	# transform to vector
	pres = as.vector(pres)
	param = as.vector(param)
	param_qc = as.vector(param_qc)
	juld = as.vector(juld)
	
	juld = juld[which(!is.na(pres))]
	param_qc = param_qc[which(!is.na(pres))]
	param = param[which(!is.na(pres))]
	pres = pres[which(!is.na(pres))]
		
	#dev.new(width=600, height=400, unit="px")	
	plot(juld, pres, col=colormap(param)$zcol, pch=16, cex=0.5,ylim=rev(range(pres, na.rm=T)))
	#image.plot(juld,pres,param)	

	return(0)
}
