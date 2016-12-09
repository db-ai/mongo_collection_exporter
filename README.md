### This is work in progress. Do not use.

# Mongo Collection Exporter

Exports all metrics from MongoDB collections (including indexes) to Prometheus
for in-depth analysis and monitoring.


## Usage

1. Get a copy of `settings.yml` and adjust it to your topology
2. Download latest release
3. Start exporter: `MONGO_EXPORT_CONF=/path/to/config.yml java -jar mongo_collection_exporter.jar`
4. It will start exporter on port `8080`. You can change port by adding
    `-p [num]` argument after `.jar`
5. Add new prometheus target
6. Import sample Grafana Dashboards from `vendor/grafana`
