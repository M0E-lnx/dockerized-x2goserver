#!/usr/bin/env bash

cname="x2golight"

docker rm $cname || docker stop $cname; docker rm $cname
docker run \
  -v /path/to/persistent/home/data:/home/x2gouser \
  -v /etc/localtime:/etc/localtime:ro \
  -p 56:22 \
  -p 8080-8085:8080-8085 \
  --name $cname \
  --hostname $cname \
  -id m0elnx/x2golight

