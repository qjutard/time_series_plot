#!/bin/bash

usage() { 
	echo "Usage: $0 -W <WMO_number> -P <PARAM_NAME> [-c <zoom_param>] [-n <plot_name>] [-z <zoom_pres>] [-dh]
Do '$0 -h' for help" 1>&2
	exit 1 
}
helprint() {
	echo "
#########################################################################################

BGTS does a time series plot of a BGC-ARGO parameter from a chosen float.

Usage: $0 -W <WMO_number> -P <PARAM_NAME> [-c <zoom_param>] [-n <plot_name>] [-z <zoom_pres>] [-dh]

### Options

-W <WMO_number> : 7 digits WMO number of the float to consider.
-P <PARAM_NAME> : Name of the parameter to plot, should be consistent with BGC-ARGO
                  variable names.
[-c <zoom_param>] : Specify a parameter interval for the colorbar, should be formatted 
                    as 'MIN.min;MAX.max' with the single quotation marks.
[-n <plot_name>] : Specify a file name for the output (with pathway), if not specified
                   the default is 'BGTS_WMO_PARAM_NAME.png' where WMO is replaced by the
                   7 digit WMO number and PARAM_NAME by the variable name. Please use
                   a '.png' extension in your file name.
[-z <zoom_pres>] : Specify a pressure interval, should be formatted as 'MIN.min;MAX.max'
                   with the single quotation marks.
[-d] : Use dates as horizontal axis instead of profile index.
[-h] : help

#########################################################################################
" 1>&2
	exit 0
}

WMO=NA
PARAM_NAME=NA
zoom_pres=NA
zoom_param=NA
date_axis=FALSE
plot_name=NA

while getopts W:P:c:n:z:dh option
do
case "${option}"
in
W) WMO=${OPTARG};;
P) PARAM_NAME=${OPTARG};;
c) zoom_param=${OPTARG};;
n) plot_name=${OPTARG};;
z) zoom_pres=${OPTARG};;
d) date_axis=TRUE;;
h) helprint;;
*) usage;;
esac
done


Rscript ~/Documents/time_series/time_series_plot/start_TS.R $WMO $PARAM_NAME $zoom_pres $zoom_param $date_axis $plot_name
