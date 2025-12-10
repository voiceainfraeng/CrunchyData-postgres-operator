#!/bin/bash

GOLANG_URL="https://go.dev/dl/go1.25.5.linux-amd64.tar.gz"
CONTAINER_ID=$(docker run -it -d \
    -u 0:0 \
    -e GOROOT=/usr/local/go \
    -e PATH=/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    -v $PWD:$PWD \
    -w $PWD \
    --platform linux/amd64 \
    ubuntu:22.04 \
    cat)

docker exec ${CONTAINER_ID} bash -c 'apt-get update && apt-get install -yqq build-essential wget git buildah'
docker exec ${CONTAINER_ID} bash -c "wget -O /tmp/go.tar.gz ${GOLANG_URL} && mkdir -p /usr/local/go && tar -xvf /tmp/go.tar.gz -C /usr/local/go --strip-components 1"

docker exec ${CONTAINER_ID} go mod tidy
docker exec ${CONTAINER_ID} make setup
docker exec ${CONTAINER_ID} make check

# this takes awhile to complete, but good to run occasionally
# docker exec ${CONTAINER_ID} make check-envtest
