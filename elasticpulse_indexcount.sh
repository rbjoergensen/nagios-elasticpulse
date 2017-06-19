#!/bin/bash

eshost="default"
timeback="15m" # eg. 3s, 77s, 15m, 120m, 1d, 50d, 1m, 22m, 1y, 44y
credentials="user:pass"
indexname="default"
datatype="default"

while getopts H:t:u:i:d: option
do
 case "${option}"
 in
 H) eshost=${OPTARG};;
 t) timeback=${OPTARG};;
 u) credentials=${OPTARG};;
 i) indexname=${OPTARG};;
 d) datatype=${OPTARG};;
 esac
done

echo $eshost
echo $timeback
echo $credentials
echo $indexname
echo $datatype

index_count=`curl -s -XGET -u $credentials $eshost'/'$indexname'/'$datatype'/_search' \
             -H 'Content-Type: application/json' -d '{"query": { "range" : { "indexdate" : { "gte" : "now-'$timeback'", "lt" : "now"}}}}' | \
             python -c "import sys, json; print json.load(sys.stdin)['hits']['total']"`

#echo "Index Count: $index_count"

#Debug value if you should need to check functionality.
#index_count=-11

if ((5<=$index_count))
then
    echo "OK - Index count is $index_count."
    exit 0
elif ((1<=$index_count && $index_count<=4))
then
    echo "WARNING - Index count is $index_count."
    exit 1
elif ((0==$index_count))
then
    echo "CRITICAL - Index count is $index_count."
    exit 2
else
    echo "UNKNOWN - Index count is $index_count."
    exit 3
fi