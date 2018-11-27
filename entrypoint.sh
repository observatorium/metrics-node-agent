#!/bin/sh

endpoint=$1
hostname=$2

prom_config=/tmp/prometheus.yml

# Generate Prometheus configuration to use.
cat <<-EOF > ${prom_config}
global:
  external_labels:
    hostname: "${hostname}"

scrape_configs:
- job_name: 'node'
  static_configs:
  - targets: ['localhost:9100']

remote_write:
- url: "${endpoint}"
EOF

cat ${prom_config}

# Start the node-exporter process
node_exporter --path.rootfs /host &
status=$?
if [ $status -ne 0 ]; then
    echo "Failed to start node-exporter: $status"
    exit $status
fi

# Start the Prometheus process
prometheus --config.file=${prom_config} &
status=$?
if [ $status -ne 0 ]; then
    echo "Failed to start Prometheus: $status"
    exit $status
fi

# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container exits with an error
# if it detects that either of the processes has exited.
# Otherwise it loops forever, waking up every 60 seconds

while sleep 60; do
    ps aux |grep node_exporter |grep -q -v grep
    PROCESS_1_STATUS=$?
    ps aux |grep prometheus |grep -q -v grep
    PROCESS_2_STATUS=$?
    # If the greps above find anything, they exit with 0 status
    # If they are not both 0, then something is wrong
    if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
        echo "One of the processes has already exited."
        exit 1
    fi
done
