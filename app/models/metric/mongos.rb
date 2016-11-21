class Metric
  # Metrics extacted from db.serverStatus() on `mongos` nodes
  class Mongos < Metric
    metrics do
      ignore 'host', 'advisoryHostFQDNs', 'version', 'process', 'pid',
             'uptimeMillis', 'uptimeEstimate', 'localTime',
             'sharding'

      gauge 'uptime', as: 'uptime_seconds'

      inside 'extra_info' do
        ignore 'note'

        gauge 'heap_usage_bytes'
        gauge 'page_faults'
      end

      inside 'asserts' do
        counter 'rollovers'

        iterate do |key, value|
          counter! 'asserts', value, type: key
        end
      end

      inside 'opcounters' do
        iterate do |key, value|
          counter! 'opcounters', value, op: key, src: 'self'
        end
      end

      inside 'connections' do
        gauge 'current'
        gauge 'available'
        counter 'totalCreated', as: 'created_total'
      end

      inside 'network' do
        counter 'bytesIn', as: 'in_bytes'
        gauge 'bytesOut', as: 'out_bytes'
        counter 'numRequests', as: 'requests_total'
      end

      inside 'mem' do
        ignore 'bits', 'supported'

        gauge 'resident', as: 'resident_mbytes'
        gauge 'virtual', as: 'virtual_mbytes'
      end

      inside 'metrics' do
        ignore 'getLastError'

        inside 'cursor' do
          inside 'open' do
            ignore 'total'

            iterate do |key, value|
              gauge! 'metric_cursors_open', value, type: key
            end
          end
        end

        inside 'commands' do
          counter '<UNKNOWN>', as: 'unknown'

          iterate do |key, value|
            counter! 'command_failed', value['failed'], cmd: key
            counter! 'command_total', value['total'], cmd: key
          end
        end
      end

      gauge 'ok', as: 'scrape_ok'
    end
  end
end
