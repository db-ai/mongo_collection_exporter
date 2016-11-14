### This is work in progress. Do not use.

# Mongo Collection Exporter

Exports all metrics from MongoDB collections (including indexes) to Prometheus
for in-depth analysis and monitoring.

## What nodes are exported?

Currently only following nodes are supported:

  * mongos
  * configuration servers
  * sharded replica sets
