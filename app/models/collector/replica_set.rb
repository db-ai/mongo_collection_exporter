class Collector
  class ReplicaSet
    OPLOG_COLL = 'oplog.rs'.freeze

    attr_reader :node, :server, :client, :db, :rs
    def initialize(node)
      @node = node
      @server = node.server
      @client = node.client

      @db = client.use(:local).database
      @coll = @db[OPLOG_COLL]
      @stats = stats
    end

    def stats
      node.run(selector: { collStats: OPLOG_COLL}, db_name: 'local')
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
      fbk = {"ts": BSON::Timestamp.new(0,0)}

      first = @coll.find({}, {"sort": {"$natural": 1}}).limit(1).first || fbk
      last = @coll.find({}, {"sort": {"$natural": -1}}).limit(1).first || first

      last['ts'].seconds - first['ts'].seconds
    end

    def used
      @stats['size']
    end

    def max_size
      @stats['maxSize']
    end
  end
end
