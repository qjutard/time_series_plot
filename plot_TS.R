#############################################################################
# This script does the time series plot
#############################################################################

plot_TS <- function(M, PARAM_NAME, plot_name, zoom_pres=NULL, zoom_param=NULL, date_axis=FALSE, interactive_plot=FALSE) {

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
	param_units = rep(NA, n_prof)
	profile_id = array(NA, c(n_depth, n_prof))
	
	for (i in seq(1,n_prof)) {
	
		n_pres_i = length(M[,i]$PRES)
	
		pres[1:n_pres_i, i] = M[,i]$PRES 
		param[1:n_pres_i, i] = M[,i]$PARAM 
		param_qc[1:n_pres_i, i] = M[,i]$PARAM_QC 
		juld[1:n_pres_i, i] = rep(M[,i]$JULD, n_pres_i)
		profile_id[1:n_pres_i, i] = rep(M[,i]$profile_id, n_pres_i)
		
	    param_units[i] = M[,i]$param_units

	}
	
	# transform to vector
	pres = as.vector(pres)
	param = as.vector(param)
	param_qc = as.vector(param_qc)
	juld = as.vector(juld)
	profile_id = as.vector(profile_id)
	
	if (!is.null(zoom_pres)) {
	    pres[which( pres<zoom_pres[1] | pres>zoom_pres[2] )] = NA
	}
	if (!is.null(zoom_param)) {
	    param[which( param<zoom_param[1] )] = zoom_param[1]   
	    param[which( param>zoom_param[2] )] = zoom_param[2]  
	}
	
	not_na_axis = which( !is.na(pres) & !is.na(param) )
	profile_id = profile_id[not_na_axis]
	juld = juld[not_na_axis]
	param_qc = param_qc[not_na_axis]
	param = param[not_na_axis]
	pres = pres[not_na_axis]
	
	# define labeling parameters
	dates = as.Date(juld, origin='1950-01-01')
	param_units = unique(param_units[which(!is.na(param_units))])
	if (date_axis) {
	    Xaxis = dates
	    Xlabel = "Time"
	} else {
	    Xaxis = profile_id
	    Xlabel = "Profile number"
	}
		
	colors = colormap(param, zlim=c(min(param), max(param)))
	
	
	
	
	if (interactive_plot) {
	    
	    require(plotly)
	    require(htmlwidgets)
	    
	    d = data.frame(x=Xaxis, y=pres, param=param)
	    p <- plot_ly( type = 'scatter',
	        data = d, x = ~x, y = ~y,
	        color = ~param
	    )
	    
	    saveWidget(p, file=plot_name)
	    
	} else {
	    
	    png(plot_name, width = 800, height = 400)
	    
    	layout(t(1:2), widths=c(10,1))	
    	
    	par(mar=c(5,4,4,0.5))
    	plot(Xaxis, pres, col=colors$zcol, pch=16, cex=0.5, ylim=rev(range(pres, na.rm=T)), xlab=Xlabel, ylab="Pressure (decibar)")
    	title(main=PARAM_NAME)
    	#image.plot(juld,pres,param)
        
    	# colorbar
    	par(mar=c(5,1,4,2.5))
    	image(y=colors$breaks, z=t(colors$breaks), col=colors$col, axes=FALSE)	
    	axis(4, cex.axis=0.8, mgp=c(0,0.5,0))
    	title(main=param_units)
    	
    	dev.off()
	
	}

	return(0)
}
