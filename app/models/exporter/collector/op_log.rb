module Exporter
  class Collector
    # Collects informaton about Operation Log collection in the `local`
    # database.
    class OpLog
      OPLOG_COLL = 'oplog.rs'.freeze

      attr_reader :node, :db, :rs
      def initialize(node)
        @node = node

        @db = client.use(:local).database
        @coll = @db[OPLOG_COLL]
        @stats = stats
      end

      # TODO: Use delegators instead
      def server
        node.server
      end

      def client
        node.client
      end

      def stats
        node.run(selector: { collStats: OPLOG_COLL }, db_name: 'local')
      end

      def to_h
        {
          'oplog_used_bytes' => used,
          'oplog_max_bytes' => max_size,
          'oplog_window_seconds' => window,
          'oplog_count' => count
        }
      end

      def count
        @coll.count
      end

      def window
        first_block = { 'ts' => BSON::Timestamp.new(0, 0) }

        first = ordered_first(1) || first_block
        last = ordered_first(-1) || first

        last['ts'].seconds - first['ts'].seconds
      end

      def used
        @stats['size']
      end

      def max_size
        @stats['maxSize']
      end

      def ordered_first(order)
        @coll.find({}, 'sort' => { '$natural' => order }).limit(1).first
      end
    end
  end
end
