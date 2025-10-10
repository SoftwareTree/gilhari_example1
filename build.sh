#!/bin/bash
# build.sh
# Conversion of build.cmd to a shell script.

docker build -t gilhari_example1:1.0 .
docker images