#!/bin/bash

usage() { 
	echo "Usage: $0 -W <WMO_number> -P <PARAM_NAME> [-z <zoom_pres>] [-c <zoom_param>] [-dh]
Do '$0 -h' for help" 1>&2
	exit 1 
}
helprint() {
	echo "
#########################################################################################

BGTS does a time series plot of a BGC-ARGO parameter from a chosen float.

Usage: $0 -W <WMO_number> -P <PARAM_NAME> [-z <zoom_pres>] [-c <zoom_param>] [-dh]

### Options

-W <WMO_number> : 7 digits WMO number of the float to consider.
-P <PARAM_NAME> : Name of the parameter to plot, should be consistent with BGC-ARGO
                  variable names.
[-z <zoom_pres>] : Specify a pressure interval, should be formatted as 'MIN.min;MAX.max'
                   with the single quotation marks.
[-c <zoom_param>] : Specify a parameter interval for the colorbar, should be formatted 
                    as 'MIN.min;MAX.max' with the single quotation marks.
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

while getopts W:P:z:c:dh option
do
case "${option}"
in
W) WMO=${OPTARG};;
P) PARAM_NAME=${OPTARG};;
z) zoom_pres=${OPTARG};;
c) zoom_param=${OPTARG};;
d) date_axis=TRUE;;
h) helprint;;
*) usage;;
esac
done


Rscript ~/Documents/time_series/time_series_plot/start_TS.R $WMO $PARAM_NAME $zoom_pres $zoom_param $date_axis
