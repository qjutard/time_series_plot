#############################################################################
# This script does the time series plot
#############################################################################

plot_TS <- function(M, zoom_pres=NULL, zoom_param=NULL) {

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
	
	if (!is.null(zoom_pres)) {
	    pres[which( pres<zoom_pres[1] | pres>zoom_pres[2] )] = NA
	}
	if (!is.null(zoom_param)) {
	    pres[which( param<zoom_param[1] | param>zoom_param[2] )] = NA   # pres is used as the reference to insert NA
	}
	
	
	juld = juld[which(!is.na(pres))]
	param_qc = param_qc[which(!is.na(pres))]
	param = param[which(!is.na(pres))]
	pres = pres[which(!is.na(pres))]
	
	dates = as.Date(juld, origin='1950-01-01')
		
	colors = colormap(param, zlim=c(min(param), max(param)))
	x11(width=14, height=8)
	layout(t(1:2), widths=c(10,1))	
	
	#dev.new(width=600, height=400, unit="px")	
	par(mar=c(5,4,4,0.5))
	plot(dates, pres, col=colors$zcol, pch=16, cex=0.5,ylim=rev(range(pres, na.rm=T)))
	#image.plot(juld,pres,param)

	par(mar=c(5,1,4,2.5))
	image(y=colors$breaks, z=t(colors$breaks), col=colors$col, axes=FALSE)	
	axis(4, cex.axis=0.8, mgp=c(0,0.5,0))

	return(0)
}
