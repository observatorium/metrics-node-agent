FROM quay.io/prometheus/busybox:glibc

COPY tmp/prometheus/prometheus /bin/prometheus
COPY tmp/node_exporter/node_exporter /bin/node_exporter

COPY entrypoint.sh /entrypoint.sh

VOLUME /tmp

ENTRYPOINT ["/entrypoint.sh"]
