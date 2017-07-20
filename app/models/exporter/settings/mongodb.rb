module Exporter
  class Settings
    # Uses Settings::File to make a list of Server instances to collect metrics
    # from.
    class Mongodb
      ALLOWED_SSL_KEYS = %i{ssl_verify ssl_cert ssl_ca_cert}

      attr_reader :raw

      attr_reader :mongos, :configs, :shards

      def initialize(raw)
        @raw = raw

        validate_mode
        validate_ssl

        @mongos = list_mongos.map { |srv| Server::Mongos.new(srv, ssl) }
        @configs = list_configs.map { |srv| Server::Configuration.new(srv, ssl) }
        @shards = list_shards.map { |srv| Server::Shard.new(srv, ssl) }
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

      def ssl
        raw.fetch('ssl') { {} } || {}
      end

      def list_mongos
        raw.fetch('mongos') { [] } || []
      end

      def list_configs
        raw.fetch('configs') { [] } || []
      end

      def list_shards
        raw.fetch('shards') { [] } || []
      end

      def validate_mode
        raise "Unsupported mongo mode #{mode}" if mode != 'sharded'
      end

      def validate_ssl
        unknown_keys = ssl.keys.map(&:to_sym) - ALLOWED_SSL_KEYS

        if unknown_keys.any?
          raise "Unsupported ssl configuration options: #{unknown_keys}. " \
                "Only #{ALLOWED_SSL_KEYS} are allowed"
        end
      end
    end
  end
end
