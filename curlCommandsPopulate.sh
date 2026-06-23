#!/bin/bash

# A script to invoke some sample curl commands on a Linux/Mac machine
# against a running container image of the app-specific Gilhari microservice 
# gilhari_example1:1.0.
#
# This scripts populates some data but does not delete them.
#
# The responses are recorded in a log file (curl.log).
#
# Note that these curl commands use a default mapped port number of 80
# even though the port number exposed by the app-specific
# microservice may be different (e.g., 8081) inside the container shell.
#
# You may optionally specify a non-default port number as the first 
# command line argument to this script. For example, to specify a 
# port number of 8899, use the following command:
#    ./curlCommandsUser.sh 8899

# Set port number - use first argument if provided, otherwise default to 80
if [ -z "$1" ]; then
    port=80
else
    port=$1
fi

echo "** BEGIN OUTPUT **" > curl.log
echo "" >> curl.log

echo "Using PORT number $port" >> curl.log
echo "" >> curl.log

echo "** Delete all User objects to start fresh" >> curl.log
curl -X DELETE "http://localhost:$port/gilhari/v1/User" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

echo "** Insert one User object" >> curl.log
curl -X POST "http://localhost:$port/gilhari/v1/User" -H "Content-Type: application/json" -d '{"entity":{"id":39,"name":"John39","age":39,"city":"San Francisco","state":"CA"}}' >> curl.log
echo "" >> curl.log
echo "" >> curl.log

echo "** Query all User objects" >> curl.log
curl -X GET "http://localhost:$port/gilhari/v1/User" -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

echo "** Insert multiple (two) User objects" >> curl.log
curl -X POST "http://localhost:$port/gilhari/v1/User" -H "Content-Type: application/json" -d '{"entity":[{"id":40,"name":"Mike40","age":40,"city":"New York","state":"NY"}, {"id":41,"name":"Mary41","age":41,"city":"Austin","state":"TX"}]}' >> curl.log
echo "" >> curl.log
echo "" >> curl.log

echo "** Insert a few more (two) User objects" >> curl.log
curl -X POST "http://localhost:$port/gilhari/v1/User" -H "Content-Type: application/json" -d '{"entity":[{"id":50,"name":"Mike50","age":50,"city":"San Jose","state":"CA"}, {"id":51,"name":"Mary51","age":51,"city":"San Francisco","state":"CA"}]}' >> curl.log
echo "" >> curl.log
echo "" >> curl.log

echo "** Insert a few more (two) User objects" >> curl.log
curl -X POST "http://localhost:$port/gilhari/v1/User" -H "Content-Type: application/json" -d '{"entity":[{"id":52,"name":"Mike52","age":52,"city":"San Francisco","state":"CA"}, {"id":53,"name":"Mary53","age":53,"city":"Chicago","state":"IL"}]}' >> curl.log
echo "" >> curl.log
echo "" >> curl.log

echo "** Insert a few more (two) User objects" >> curl.log
curl -X POST "http://localhost:$port/gilhari/v1/User" -H "Content-Type: application/json" -d '{"entity":[{"id":54,"name":"Mike54","age":54,"city":"New York","state":"NY"}, {"id":55,"name":"Mary55","age":55,"city":"Campbell","state":"CA"}]}' >> curl.log
echo "" >> curl.log
echo "" >> curl.log

echo "** Insert one more User object" >> curl.log
curl -X POST "http://localhost:$port/gilhari/v1/User" -H "Content-Type: application/json" -d '{"entity":{"id":56,"name":"Mike56","age":56,"city":"Boston","state":"MA"}}' >> curl.log
echo "" >> curl.log
echo "" >> curl.log

echo "** Get a count of all User objects" >> curl.log
curl -X GET "http://localhost:$port/gilhari/v1/User/getAggregate?attribute=id&aggregateType=COUNT" -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

echo "** Query User objects with \"age>=55\"" >> curl.log
curl -X GET "http://localhost:$port/gilhari/v1/User?filter=age>=55" -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

echo "** Get average age of all Users living in California" >> curl.log
curl -X GET "http://localhost:$port/gilhari/v1/User/getAggregate?attribute=age&aggregateType=AVG&filter=state='CA'" -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

echo "** Query all User objects with only id, name, and city attributes for users in the state of California (using projections operation type with operationDetails parameter)" >> curl.log
curl -G "http://localhost:$port/gilhari/v1/User" --data-urlencode "filter=state='CA'" --data-urlencode 'operationDetails=[{"opType": "projections", "projectionsDetails": [{"type": "User", "attribs": [ "id", "name", "city" ]}]}]' -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

echo "** END OUTPUT **" >> curl.log
echo "" >> curl.log

cat curl.log