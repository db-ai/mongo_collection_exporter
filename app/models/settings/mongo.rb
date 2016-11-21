class Settings
  # Uses Settings::File to make a list of Server instances to collect metrics
  # from.
  class Mongo
    attr_reader :raw

    attr_reader :mongos, :configs, :shards

    def initialize(raw)
      @raw = raw

      @mongos = list_mongos.map { |srv| Server::Mongos.new(srv) }
      @configs = list_configs.map { |srv| Server::Config.new(srv) }
      @shards = list_shards.map { |srv| Server::Shard.new(srv) }

      validate_mode
    end

    def mode
      raw['mode'.freeze]
    end

    def find(address)
      all.find { |srv| srv.address == address }
    end

    def all
      @mongos + @configs + @shards
    end

    def list_all
      list_mongos + list_configs + list_shards
    end

    private

    def list_mongos
      raw.fetch('mongos') { [] }
    end

    def list_configs
      raw.fetch('configs') { [] }
    end

    def list_shards
      raw.fetch('shards') { [] }
    end

    def validate_mode
      raise "Unsupported mongo mode #{mode}" if mode != 'sharded'
    end
  end
end
