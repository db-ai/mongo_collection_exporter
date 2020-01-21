# No longer supported

This project is no longer supported

# Mongo Collection Exporter

[![Build Status](https://travis-ci.org/y8/mongo_collection_exporter.svg?branch=master)](https://travis-ci.org/y8/mongo_collection_exporter) [![](https://images.microbadger.com/badges/image/yopp/mongo_collection_exporter.svg)](https://hub.docker.com/r/yopp/mongo_collection_exporter)

Exports all metrics from MongoDB collections (including indexes) to Prometheus
for in-depth analysis and monitoring.

## Requirements

1. Docker 1.7+ or Java 8+

## Start with docker

1. Get a copy of `settings.yml` and adjust it to your topology
2. Make sure that hostnames or IP addresses are accessible from docker container
3. `docker run -tdi --restart=always yopp/mongo_collection_exporter:latest -e MONGO_EXPORT_CONF=/path/to/config.yml`

## Start with java

1. Get a copy of `settings.yml` and adjust it to your topology
2. Download [latest build](https://github.com/y8/mongo_collection_exporter/releases)
3. Start exporter: `MONGO_EXPORT_CONF=/path/to/config.yml java -jar mongo_collection_exporter.war`
4. It will start exporter on port `8080`.
5. Add new prometheus target.
6. Import sample Grafana Dashboards from `vendor/grafana`
