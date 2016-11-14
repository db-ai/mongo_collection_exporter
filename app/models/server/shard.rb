class Server
  class Shard < Server
    def metrics
      Metric::Shard.new(raw_metrics, labels)
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
          raw_collection_metrics database_name, name
        end
      end.flatten
    end

    def raw_collection_metrics(database, name)
      raw_data = run(selector: { collStats: name }, db_name: database)
      collection_labels = labels.merge ns: [database, name].join('.')

      Metric::Collection.new(raw_data, collection_labels)
    end

    def extra_labels
      { rs: replica_name }
    end
  end
end
