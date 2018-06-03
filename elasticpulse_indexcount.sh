#!/bin/bash

eshost="elastic.domain.com"
timeback="15m"
credentials="elastic:changeme"
indexname="default"
datatype="default"
datename="indexdate"

while getopts H:t:u:i:d:k: option
do
 case "${option}"
 in
 H) eshost=${OPTARG};;
 t) timeback=${OPTARG};;
 u) credentials=${OPTARG};;
 i) indexname=${OPTARG};;
 d) datatype=${OPTARG};;
 k) datename=${OPTARG};;
 esac
done

# Debug
#echo $eshost
#echo $timeback
#echo $credentials
#echo $indexname
#echo $datatype

index_count=`curl -s -XGET -u $credentials $eshost'/'$indexname'/'$datatype'/_search' \
             -H 'Content-Type: application/json' -d '{"query": { "range" : { "'$datename'" : { "gte" : "now-'$timeback'", "lt" : "now"}}}}' | \
             python -c "import sys, json; print json.load(sys.stdin)['hits']['total']"`

# echo "Index Count: $index_count"
# The echo message is "Status Information | Performance data"
# Split up by |

if ((5<=$index_count))
then
    echo "OK - Index count is $index_count in the last $timeback. | $index_count"
    exit 0
elif ((1<=$index_count && $index_count<=4))
then
    echo "WARNING - Index count is $index_count in the last $timeback. | $index_count"
    exit 1
elif ((0==$index_count))
then
    echo "CRITICAL - Index count is $index_count in the last $timeback. | $index_count"
    exit 2
else
    echo "UNKNOWN - Index count is $index_count in the last $timeback. | $index_count"
    exit 3
fi
