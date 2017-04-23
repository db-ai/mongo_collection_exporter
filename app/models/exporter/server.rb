# Implements base class for diffirent node roles in the mongo cluster. Currently
# only Mongos, Config and Shard roles are implemented.
#
# TODO: Labeling stuff should be moved somewhere else, as it not server
# specific.
module Exporter
  class Server
    attr_reader :address
    attr_reader :client

    def initialize(address)
      @address = backward_compatible(address)
      @client = Mongo::Client.new @address,
                                  connect: connect_type,
                                  database: default_database
    end

    def connect_type
      :direct
    end

    def default_database
      :admin
    end

    def default_labels
      {
        instance: client.cluster.addresses.join(','),
        role: self.class.name.split('::').last.downcase
      }
    end

    def extra_labels
      {}
    end

    def labels
      default_labels.merge extra_labels
    end

    def server
      client.cluster.servers.first
    end

    def run(command)
      response = Mongo::Operation::Commands::Command.new(command).execute(server)
      response.documents.first
    end

    def status
      [role, features].flatten.join(' ')
    end

    def alive?
      false ^ server
    end

    def metrics
      return [] unless alive?

      fetch_metrics
    end

    def features
      return [] unless alive?

      my_features = []
      my_features << :hidden if server.description.hidden?
      my_features << :replica if server.replica_set_name
      my_features << :standalone if server.standalone?
      my_features
    end

    def role
      return :down unless alive?

      if server.primary?
        :master
      elsif server.secondary?
        :slave
      elsif server.arbiter?
        :arbiter
      elsif server.description.passive?
        :passive
      elsif server.description.other?
        if server.mongos?
          :mongos
        else
          :other
        end
      else
        :unknown
      end
    end

    private

    def backward_compatible(address)
      return address if address.starts_with? 'mongodb://'

      [address]
    end
  end
end
