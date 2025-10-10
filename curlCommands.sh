#!/bin/sh
# A shell script to invoke some sample curl commands on a Linux/Mac machine 
# against a running container image of the app-specific Gilhari microservice 
# gilhari_example1:1.0
# 
# The responses are recorded in a log file (curl.log).
#
# Note that these curl commands use a mapped port number of 80
# even though the port number exposed by the app-specific 
# microservice may be different (e.g., 8081) inside the container shell.
# If you want to use these curl commands from inside the
# container shell on the host machine, you may have to use
# the exposed port number (e.g., 8081) instead.

#!/bin/sh

# Check if a port is provided as an argument, if not, use default port 80
if [ -z "$1" ]; then
    port=80
else
    port=$1
fi

# Log file where output will be saved
log_file="curl.log"

# Start logging
echo "** BEGIN OUTPUT **" > "$log_file"
echo "" >> "$log_file"

# Log port information
echo "Using PORT number $port" >> "$log_file"
echo "" >> "$log_file"

# ** GET summary of the underlying object model
echo "** GET summary of the underlying object model" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/getObjectModelSummary/now" >> "$log_file"
echo "" >> "$log_file"

# ** Delete all User objects to start fresh
echo "** Delete all User objects to start fresh" >> "$log_file"
curl -X DELETE "http://localhost:$port/gilhari/v1/User" >> "$log_file"
echo "" >> "$log_file"

# ** Insert one User object
echo "** Insert one User object" >> "$log_file"
curl -X POST "http://localhost:$port/gilhari/v1/User" -H "Content-Type: application/json" -d '{"entity":{"id":39,"name":"John39","age":39,"city":"San Francisco","state":"CA"}}' >> "$log_file"
echo "" >> "$log_file"

# ** Query all User objects
echo "** Query all User objects" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/User" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"

# ** Insert multiple (two) User objects
echo "** Insert multiple (two) User objects" >> "$log_file"
curl -X POST "http://localhost:$port/gilhari/v1/User" -H "Content-Type: application/json" -d '{"entity":[{"id":40,"name":"Mike40","age":40,"city":"New York","state":"NY"},{"id":41,"name":"Mary41","age":41,"city":"Austin","state":"TX"}]}' >> "$log_file"
echo "" >> "$log_file"

# ** Insert a few more (two) User objects
echo "** Insert a few more (two) User objects" >> "$log_file"
curl -X POST "http://localhost:$port/gilhari/v1/User" -H "Content-Type: application/json" -d '{"entity":[{"id":50,"name":"Mike50","age":50,"city":"San Jose","state":"CA"},{"id":51,"name":"Mary51","age":51,"city":"San Francisco","state":"CA"}]}' >> "$log_file"
echo "" >> "$log_file"

# ** Query all User objects
echo "** Query all User objects" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/User" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"

# ** Query User objects with "age > 40"
echo "** Query User objects with 'age > 40'" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/User?filter=age>40" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"

# ** Query the count of Users living in California
echo "** Query the count of Users living in California" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/User/getAggregate?attribute=id&aggregateType=COUNT&filter=state='CA'" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"

# ** Get average age of all Users living in California
echo "** Get average age of all Users living in California" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/User/getAggregate?attribute=age&aggregateType=AVG&filter=state='CA'" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"

# ** Delete all User objects with "age > 40"
echo "** Delete all User objects with 'age > 40'" >> "$log_file"
curl -X DELETE "http://localhost:$port/gilhari/v1/User?filter=age>40" >> "$log_file"
echo "" >> "$log_file"

# ** Delete all User objects
echo "** Delete all User objects" >> "$log_file"
curl -X DELETE "http://localhost:$port/gilhari/v1/User" >> "$log_file"
echo "" >> "$log_file"

# ** Query the count of all User objects
echo "** Query the count of all User objects" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/User/getAggregate?attribute=id&aggregateType=COUNT" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"

# End logging
echo "** END OUTPUT **" >> "$log_file"
echo "" >> "$log_file"

# Display the log content
cat "$log_file"
