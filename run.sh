#!/bin/bash

docker run --rm -it --init \
    --net="host" \
    --pid="host" \
    -v "/:/host:ro,rslave" \
    redhat-metrics-node-agent \
    "http://localhost:19292/receive" \
    "$(hostname)"
