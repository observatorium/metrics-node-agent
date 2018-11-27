#!/usr/bin/env bash

prometheus_version=2.5.0
node_exporter_version=0.17.0-rc.0

rm -rf tmp
mkdir tmp
curl -L https://github.com/prometheus/node_exporter/releases/download/v${node_exporter_version}/node_exporter-${node_exporter_version}.linux-amd64.tar.gz > tmp/node_exporter-${node_exporter_version}.linux-amd64.tar.gz
curl -L https://github.com/prometheus/prometheus/releases/download/v${prometheus_version}/prometheus-${prometheus_version}.linux-amd64.tar.gz > tmp/prometheus-${prometheus_version}.linux-amd64.tar.gz

tar -C tmp/ -zxvf tmp/node_exporter-${node_exporter_version}.linux-amd64.tar.gz
tar -C tmp/ -zxvf tmp/prometheus-${prometheus_version}.linux-amd64.tar.gz

mv tmp/node_exporter-${node_exporter_version}.linux-amd64 tmp/node_exporter
mv tmp/prometheus-${prometheus_version}.linux-amd64 tmp/prometheus

docker build -t quay.io/gosip/metrics-node-agent .
