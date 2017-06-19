#!/bin/bash

index_count=`curl -s -XGET -u username:password 'elastic.hostname.com/insert_indexname/insert_type/_search' \
             -H 'Content-Type: application/json' -d '{"query": { "range" : { "indexdate" : { "gte" : "now-15m", "lt" : "now"}}}}' | \
             python -c "import sys, json; print json.load(sys.stdin)['hits']['total']"`
			 
echo "Index Count: $index_count"

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