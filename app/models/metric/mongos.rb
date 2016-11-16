class Metric
  class Mongos < Metric
    metrics do
      ignore 'host', 'advisoryHostFQDNs', 'version', 'process', 'pid', 'uptime',
             'uptimeMillis', 'uptimeEstimate', 'localTime', 'extra_info',
             'sharding'

      inside 'asserts' do
        counter 'rollovers'

        iterate do |key, value|
          counter! 'asserts', value, type: key
        end
      end

      inside 'opcounters' do
        iterate do |key, value|
          counter! 'opcounters', value, type: key
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
            gauge 'noTimeout', as: 'no_timeout'
            gauge 'pinned'
            gauge 'total'
            gauge 'singleTarget'
            gauge 'multiTarget'
          end
        end

        inside 'commands' do
          counter "<UNKNOWN>", as: "unknown"

          iterate do |key, value|
            counter! "command_failed", value['failed'], cmd: key
            counter! "command_total", value['total'], cmd: key
          end
        end
      end

      gauge 'ok', as: 'metrics_is_ok'
    end
  end
end
