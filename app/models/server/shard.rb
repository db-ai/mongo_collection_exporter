class Server
  class Shard < Server
    def metrics
      Metric::Mongod.new(raw_metrics, labels)
    end

    def raw_metrics
      run(selector: { serverStatus: 1 }, db_name: 'admin')
    end

    def replica_name
      server.replica_set_name
    end

    def databases
      client.database_names - ['local'.freeze]
    end

    def namespaces_metrics
      databases.collect do |database_name|
        client.use(database_name).database.collection_names.map do |name|
          collections_metrics database_name, name
        end
      end.flatten
    end

    def collections_metrics(database, name)
      collection_data = run(selector: { collStats: name }, db_name: database)
      index_data = collection_data.delete('indexDetails') { Hash.new }

      [
        indexes_metrics(database, name, index_data),
        collection_metric(database, name, collection_data)
      ]
    end

    def indexes_metrics(database, name, raw_data)
      raw_data.map do |index_name, index_raw_data|
        index_metric(database, name, index_name, index_raw_data)
      end
    end

    def collection_metric(database, name, raw_data)
      collection_labels = labels.merge db: database, coll: name

      Metric::Collection.new(raw_data, collection_labels)
    end

    def index_metric(database, name, index_name, index_raw_data)
      index_labels = labels.merge db: database, coll: name, idx: index_name

      Metric::Index.new(index_raw_data, index_labels)
    end

    def extra_labels
      { rs: replica_name }
    end
  end
end
