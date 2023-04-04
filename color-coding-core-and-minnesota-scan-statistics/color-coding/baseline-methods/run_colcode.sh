prefix=$1
k=$2
t=$3

java -jar ~/pcst-color-coding/jars/scan-statistic.jar run-partition "$prefix"_1.apdm "$prefix"_1 $k $t > /dev/null &
java -jar ~/pcst-color-coding/jars/scan-statistic.jar run-partition "$prefix"_2.apdm "$prefix"_2 $k $t > /dev/null &

wait
