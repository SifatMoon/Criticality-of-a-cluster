graphfile=$1
prefix=$2
k=$3
t=$4

java -jar ~/pcst-color-coding/jars/scan-statistic.jar run-parametric $graphfile  "$prefix" $k $t

