class Metric
  class Mongod < Metric
    LocksStatsToMetrics = {
      'acquireCount' => 'lock_acquire_count',
      'acquireWaitCount' => 'lock_acquire_wait_count',
      'timeAcquiringMicros' => 'time_acquiring_us'
    }.freeze

    LockModesToNames = {
      'R' => 's',
      'W' => 'x',
      'r' => 'is',
      'w' => 'ix'
    }

    metrics do
      ignore 'host',
             'advisoryHostFQDNs',
             'version',
             'process',
             'pid',
             'uptimeMillis',
             'uptimeEstimate',
             'localTime',
             'sharding',
             'writeBacksQueued',
             'storageEngine',
             '$gleStats'

      gauge 'uptime', as: 'uptime_seconds'

      inside 'extra_info' do
        gauge 'heap_usage_bytes'
        gauge 'page_faults'
      end

      inside 'repl' do
        ignore 'rbid', 'setName', 'primary', 'secondary', 'me', 'electionId'

        gauge 'setVersion', as: 'set_version'

        gauge! 'is_master', extract('ismaster') ? 1 : 0
        gauge! 'visible_hosts', (extract('hosts') || []).size
      end

      inside 'globalLock', as: 'global_lock' do
        gauge 'totalTime', as: 'total_time_us'

        inside 'currentQueue' do
          ignore 'total'

          iterate do |key, value|
            gauge! 'global_lock', value, queue: key
          end
        end

        inside 'activeClients' do
          ignore 'total'

          iterate do |key, value|
            gauge! 'global_lock', value, client: key
          end
        end
      end

      inside 'locks' do
        # Type: Global | Database | Collection | Metadata | oplog
        iterate do |lock_type, lock_data|
          # Metric: acquireCount | acquireWaitCount | timeAcquiringMicros
          lock_data.each do |metric_name, metric_data|
            # Mode: R | r | W | w
            metric_data.each do |mode_name, value|
              counter! LocksStatsToMetrics[metric_name], value,
                       type: lock_type, mode: LockModesToNames[mode_name]
            end
          end
        end
      end

      inside 'wiredTiger', as: 'wt' do
        use WiredTigerDatabaseHelper
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

      inside 'opcountersRepl' do
        iterate do |key, value|
          counter! 'opcounters', value, op: key, src: 'repl'
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
        ignore 'mapped', 'mappedWithJournal' # MMAPv1 (mem)

        gauge 'resident', as: 'resident_mbytes'
        gauge 'virtual', as: 'virtual_mbytes'
      end

      inside 'metrics' do
        ignore 'getLastError'
        ignore 'record' # MMAPv1 (count of on disk moves)

        inside 'document' do
          counter 'deleted'
          counter 'inserted'
          counter 'returned'
          counter 'updated'
        end

        inside 'operation' do
          iterate do |key, value|
            counter! "special_operation", value, type: key
          end
        end

        inside 'queryExecutor' do
          counter! 'query_index_scanned_total', extract('scanned')
          counter! 'query_documents_scanned_total', extract('scannedObjects')
        end

        inside 'ttl' do
          counter 'deletedDocuments', as: 'documents_deleted_total'
          counter 'passes', as: 'passes_total'
        end

        inside 'cursor' do
          counter 'timedOut', as: 'timed_out_total'

          inside 'open' do
            ignore 'total'

            iterate do |key, value|
              gauge! 'metric_cursors_open', value, type: key
            end
          end
        end

        inside 'storage' do
          inside 'freelist' do
            inside 'search' do
              counter 'bucketExhausted', as: 'bucket_exhausted'
              counter 'requests'
              counter 'scanned'
            end
          end
        end

        ignore 'repl'

        inside 'commands' do
          counter "<UNKNOWN>", as: "unknown"

          iterate do |key, value|
            counter! "command_failed", value['failed'], cmd: key
            counter! "command_total", value['total'], cmd: key
          end
        end
      end

      gauge 'ok', as: 'scrape_ok'
    end
  end
end
