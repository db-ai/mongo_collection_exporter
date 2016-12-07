module Exporter
  class Source
    # This metrics are based on implementation of the getReplicationInfo and
    # printSlaveReplicationInfo functions of the mongoshell (db.js)
    #
    # See: https://git.io/vXHSJ
    class ReplicaSet < Exporter::Source
      metrics do
        # This are comming from Collector::ReplicaSet

        gauge 'oplog_used_bytes'
        gauge 'oplog_max_bytes'
        gauge 'oplog_window_seconds'
        gauge 'oplog_count'

        ignore 'set', 'date', 'ok', '$gleStats'

        gauge 'heartbeatIntervalMillis', as: 'rs_heartbit_interval_ms'
        gauge 'myState', as: 'rs_state'
        gauge 'term', as: 'rs_election_term'

        gauge! 'rs_syncing', 1, to: extract('syncingTo') if key? 'syncingTo'

        members = value('members', [])
        primary = members.find { |member| member['state'] == 1 }
        me = members.find { |member| member['self'] }
        others = members - [me]

        if me
          if primary
            # If there primary, then replication lag is against it
            current_oplog = primary['optimeDate']
          else
            # If there no primary, then replication las is against most recent
            # oplogDate
            current_oplog = members.map { |member| member['optimeDate'] }.max
          end

          lag = me['optimeDate'] - current_oplog
          gauge! 'rs_lag_seconds', lag

          others.each do |member|
            gauge! 'rs_ping_ms', member['pingMs'], to: member['name']
          end
        else
          gauge! 'rs_no_self', 1
        end
      end
    end
  end
end
