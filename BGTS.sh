#!/bin/bash

usage() {
	echo "Usage: $0 -W <WMO_number> -P <PARAM_NAME> [-c <zoom_param>] [-n <plot_name>] [-p <full_path>] [-x <zoom_x>] [-z <zoom_pres>] [-Cdhl]
Do '$0 -h' for help" 1>&2
	exit 1
}
helprint() {
	echo "
#########################################################################################

BGTS does a time series plot of a BGC-ARGO parameter from a chosen float.

Usage: $0 -W <WMO_number> -P <PARAM_NAME> [-c <zoom_param>] [-n <plot_name>] [-p <full_path>] [-q <max_qc>] [-z <zoom_pres>] [-Cdhl]

### Options

-W <WMO_number> : 7 digits WMO number of the float to consider.
-P <PARAM_NAME> : Name of the parameter to plot, should be consistent with BGC-ARGO
                  variable names.
[-c <zoom_param>] : Specify limits for the plotted parameter, should be formatted as
                    'MIN.min;MAX.max' with the single quotation marks. Values outside
                    the limits are printed as equal to MIN.min or MAX.max.
[-n <plot_name>] : Specify a file name for the output (with pathway), if not specified
                   the default is 'BGTS_WMO_PARAM_NAME.png' where WMO is replaced by the
                   7 digit WMO number and PARAM_NAME by the variable name. Please use
                   a '.png' extension in your file name.
[-p <full_path>] : Bypass the path_to_netcdf from pathways.R and specify the directory
                   in which the netcdf files will be found, <full_paht> can be './' if
                   the current directory is correct.
[-q <max_qc>] : By default BGTS removes QC '3' and '4' data, which is equivalent to
                <max_qc>=2 use '-q 3' to accept data with QC='3' and '-q 4' to also
                accept QC='4', '-q 1' can also remove data with QC='2'.
[-z <zoom_pres>] : Specify a pressure interval, should be formatted as 'MIN.min;MAX.max'
                   with the single quotation marks.
[-x <zoom_x>] : Specify an interval for the x axis (either dates or cycle numbers),
								should be formatted as 'MIN.min;MAX.max' with the single quotation marks.
[-C] : Use core argo data from core argo files, to be used with a core argo PARAM_NAME
[-d] : Use dates as horizontal axis instead of profile index.
[-h] : help
[-l] : Plot with a logarithmic scale (log10).

#########################################################################################
" 1>&2
	exit 0
}

WMO=NA
PARAM_NAME=NA
zoom_pres=NA
zoom_param=NA
zoom_x=NA
date_axis=FALSE
plot_name=NA
core_files=FALSE
logscale=FALSE
full_path=NA
max_qc=NA

while getopts W:P:c:n:p:q:z:x:dClh option
do
case "${option}"
in
W) WMO=${OPTARG};;
P) PARAM_NAME=${OPTARG};;
c) zoom_param=${OPTARG};;
n) plot_name=${OPTARG};;
p) full_path=${OPTARG};;
q) max_qc=${OPTARG};;
z) zoom_pres=${OPTARG};;
x) zoom_x=${OPTARG};;
d) date_axis=TRUE;;
C) core_files=TRUE;;
l) logscale=TRUE;;
h) helprint;;
*) usage;;
esac
done


Rscript ~/Documents/time_series/time_series_plot/start_TS.R $WMO $PARAM_NAME $zoom_pres $zoom_param $date_axis $plot_name $core_files $logscale $full_path $zoom_x $max_qc
