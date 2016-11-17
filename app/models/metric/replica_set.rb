# This metrics are based on implementation of the getReplicationInfo and
# printSlaveReplicationInfo functions of the mongoshell (db.js)
#
# See: https://git.io/vXHSJ
class Metric
  class ReplicaSet < Metric
    metrics do
      ignore 'set', 'date', 'ok', '$gleStats'

      gauge 'heartbeatIntervalMillis', as: 'rs_heartbit_interval_ms'
      gauge 'myState', as: 'rs_state'
      gauge 'term', as: 'rs_election_term'

      if key? 'syncingTo'
        gauge! 'rs_syncing', 1, {to: extract('syncingTo')}
      end

      members = extract('members', [])
      primary = members.find {|member| member['state'] == 1}
      me = members.find {|member| member['self']}
      others = members - [me]

      if me
        if primary
          # If there primary, then replication lag is against it
          current_oplog = primary['optimeDate']
        else
          # If there no primary, then replication las is against most recent
          # oplogDate
          current_oplog = members.map {|member| member['optimeDate']}.max
        end

        lag = current_oplog - me['optimeDate']
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
