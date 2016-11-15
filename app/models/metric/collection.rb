class Metric
  class Collection < Metric
    metrics do
      ignore 'ns', 'capped', '$gleStats'

      counter 'count', as: 'collection_count'

      gauge 'size', as: 'collection_size_bytes'
      gauge 'storageSize', as: 'collection_storage_size_bytes'
      gauge 'avgObjSize', as: 'collection_avg_size_bytes'
      gauge 'nindexes', as: 'collection_indexes_count'

      # Ignore index stats, as we will get them from WT cache info
      ignore 'totalIndexSize', 'indexSizes'

      inside 'wiredTiger' do
        ignore 'uri', 'type', 'creationString'

        inside 'metadata' do
          gauge 'formatVersion', as: 'format_version'
        end

        inside 'LSM' do
          counter 'bloom filter false positives',
                  as: "bloom_filer_false_positives"
          counter 'bloom filter hits',
                  as: "bloom_filer_hits"
          counter 'bloom filter misses',
                  as: 'bloom_filter_misses'

          counter 'bloom filter pages evicted from cache',
                  as: 'bloom_filter_cache_evicted_pages'
          counter 'bloom filter pages read into cache',
                  as: 'bloom_filter_cache_read_pages'

          counter 'bloom filters in the LSM tree',
                  as: 'bloom_filter_count'
          counter 'chunks in the LSM tree',
                  as: 'chunks'

          gauge 'highest merge generation in the LSM tree',
                as: 'merge_generation_max'

          counter 'queries that could have benefited from a Bloom filter that did not exist',
                  as: 'bloom_filter_query_misses'

          gauge 'sleep for LSM checkpoint throttle', {task: 'checkpoint'},
                as: 'throttle_sleep'

          gauge 'sleep for LSM merge throttle', {task: 'merge'},
                as: 'merge_throttle_sleep'

          counter 'total size of bloom filters',
                  as: 'filter_total_size_bytes'
        end
   #
   #      # inside "async" do
   #      #   gauge 'current work queue length',
   #      #         as: 'work_queue_length_current'
   #      #   gauge 'maximum work queue length',
   #      #         as: 'work_queue_length_max'
   #      #
   #      #   # More likely to be a counter
   #      #   counter 'number of allocation state races',
   #      #            as: 'allocation_state_races'
   #      #   counter 'number of flush calls',
   #      #            as: 'flush_calls'
   #      #   counter 'number of operation slots viewed for allocation',
   #      #            as: 'slots_viewed_for_allocation'
   #      #   counter 'number of times operation allocation failed',
   #      #            as: 'operation_allocation_failed'
   #      #   counter 'number of times worker found no work',
   #      #            as: 'worker_work_not_found'
   #      #
   #      #   counter 'total allocations',
   #      #         as: 'allocations_total'
   #      #
   #      #   counter 'total compact calls', {type: 'compact'},
   #      #           as: 'calls_total'
   #      #   counter 'total insert calls', {type: 'insert'},
   #      #           as: 'calls_total'
   #      #   counter 'total remove calls', {type: 'remove'},
   #      #           as: 'calls_total'
   #      #   counter 'total search calls', {type: 'search'},
   #      #           as: 'calls_total'
   #      #   counter 'total update calls', {type: 'update'},
   #      #           as: 'calls_total'
   #      # end
   #
   #      inside 'block-manager' do
   #        counter 'blocks pre-loaded',
   #                as: 'preloaded_blocks'
   #
   #        counter 'blocks read',
   #                as: 'read_blocks'
   #
   #        counter 'blocks written',
   #                as: 'written_blocks'
   #
   #        counter 'bytes read',
   #                as: 'read_bytes'
   #
   #        counter 'bytes written',
   #                as: 'written_bytes'
   #
   #        counter 'bytes written for checkpoint',
   #                as: 'checkpoint_written_bytes'
   #
   #        counter 'mapped blocks read',
   #                as: 'read_mapped_blocks'
   #
   #        counter 'mapped bytes read',
   #                as: 'read_mapped_bytes'
   #      end
   #
   #      # inside 'connection' do
   # #        counter 'auto adjusting condition resets',
   # #                as: 'adjusting_resets'
   # #
   # #        counter 'auto adjusting condition wait calls',
   # #                as: 'adjusting_wait_calls'
   # #
   # #        counter 'files currently open',
   # #                as: 'files_open'
   # #
   # #        counter 'memory allocations',
   # #                as: 'mem_allocations'
   # #        counter 'memory frees',
   # #                as: 'mem_frees'
   # #        counter 'memory re-allocations',
   # #                as: 'mem_realloc'
   # #
   # #        counter 'pthread mutex condition wait calls',
   # #                as: 'mutex_condition_wait_calls'
   # #
   # #        counter 'pthread mutex shared lock read-lock calls',
   # #                as: 'mutex_shared_lock_read_calls'
   # #
   # #        counter 'pthread mutex shared lock write-lock calls',
   # #                as: 'mutex_shared_lock_write_calls'
   # #
   # #        counter 'total fsync I/Os',
   # #              as: 'fsync_io_total'
   # #        counter 'total read I/Os',
   # #              as: 'read_io_total'
   # #        counter 'total write I/Os',
   # #              as: 'write_io_total'
   # #      end
   # #
   # #      inside 'concurrentTransactions' do
   # #        inside 'read' do
   # #          gauge 'out'
   # #          gauge 'available'
   # #          gauge 'totalTickets', as: 'tickets_total'
   # #        end
   # #
   # #        inside 'write' do
   # #          gauge 'out'
   # #          gauge 'available'
   # #          gauge 'totalTickets', as: 'tickets_total'
   # #        end
   # #      end
   #
   #      inside 'cache' do
   #        ignore 'bytes belonging to page images in the cache',
   #               'bytes currently in the cache',
   #               'bytes not belonging to page images in the cache',
   #               'bytes read into cache',
   #               'bytes written from cache',
   #               'checkpoint blocked page eviction',
   #               'eviction calls to get a page',
   #               'eviction calls to get a page found queue empty',
   #               'eviction calls to get a page found queue empty after locking',
   #               'eviction currently operating in aggressive mode',
   #               'eviction empty score',
   #               'eviction server candidate queue empty when topping up',
   #               'eviction server candidate queue not empty when topping up',
   #               'eviction server evicting pages',
   #               'eviction server slept, because we did not make progress with eviction',
   #               'eviction server unable to reach eviction goal',
   #               'eviction state',
   #               'eviction walks abandoned',
   #               'eviction worker thread evicting pages',
   #               'failed eviction of pages that exceeded the in-memory maximum',
   #               'files with active eviction walks',
   #               'files with new eviction walks started',
   #               'hazard pointer blocked page eviction',
   #               'hazard pointer check calls',
   #               'hazard pointer check entries walked',
   #               'hazard pointer maximum array length',
   #               'in-memory page passed criteria to be split',
   #               'in-memory page splits',
   #               'internal pages evicted',
   #               'internal pages split during eviction',
   #               'leaf pages split during eviction',
   #               'lookaside table insert calls',
   #               'lookaside table remove calls',
   #               'maximum bytes configured',
   #               'maximum page size at eviction',
   #               'modified pages evicted',
   #               'modified pages evicted by application threads',
   #               'overflow pages read into cache',
   #               'overflow values cached in memory',
   #               'page split during eviction deepened the tree',
   #               'page written requiring lookaside records',
   #               'pages currently held in the cache',
   #               'pages evicted because they exceeded the in-memory maximum',
   #               'pages evicted because they had chains of deleted items',
   #               'pages evicted by application threads',
   #               'pages queued for eviction',
   #               'pages queued for urgent eviction',
   #               'pages queued for urgent eviction during walk',
   #               'pages read into cache',
   #               'pages read into cache requiring lookaside entries',
   #               'pages requested from the cache',
   #               'pages seen by eviction walk',
   #               'pages selected for eviction unable to be evicted',
   #               'pages walked for eviction',
   #               'pages written from cache',
   #               'pages written requiring in-memory restoration',
   #               'percentage overhead',
   #               'tracked bytes belonging to internal pages in the cache',
   #               'tracked bytes belonging to leaf pages in the cache',
   #               'tracked dirty bytes in the cache',
   #               'tracked dirty pages in the cache',
   #               'unmodified pages evicted'
   #      end
   #
   #      inside 'cursor' do
   #        counter 'cursor create calls',      {type: 'create'}, as: 'calls'
   #        counter 'cursor insert calls',      {type: 'insert'}, as: 'calls'
   #        counter 'cursor next calls',        {type: 'next'}, as: 'calls'
   #        counter 'cursor prev calls',        {type: 'prev'}, as: 'calls'
   #        counter 'cursor remove calls',      {type: 'remove'}, as: 'calls'
   #        counter 'cursor reset calls',       {type: 'reset'}, as: 'calls'
   #        counter 'cursor restarted searches',{type: 'restarted'}, as: 'calls'
   #        counter 'cursor search calls',      {type: 'search'}, as: 'calls'
   #        counter 'cursor search near calls', {type: 'search_near'}, as: 'calls'
   #        counter 'cursor update calls',      {type: 'update'}, as: 'calls'
   #        counter 'truncate calls',           as: 'truncate_calls'
   #      end
   #
   #      # TODO: Investigate need of this metrics?
   #      inside 'thread-state' do
   #        ignore 'active filesystem fsync calls',
   #               'active filesystem read calls',
   #               'active filesystem write calls'
   #      end
   #
   #      inside 'thread-yield' do
   #        ignore 'page acquire busy blocked',
   #               'page acquire eviction blocked',
   #               'page acquire locked blocked',
   #               'page acquire read blocked',
   #               'page acquire time sleeping (usecs)'
   #      end
   #
   #      inside 'data-handle' do
   #        ignore 'connection data handles currently active',
   #               'connection sweep candidate became referenced',
   #               'connection sweep dhandles closed',
   #               'connection sweep dhandles removed from hash list',
   #               'connection sweep time-of-death sets',
   #               'connection sweeps',
   #               'session dhandles swept',
   #               'session sweep attempts'
   #      end
   #
   #      inside 'reconciliation' do
   #        ignore 'fast-path pages deleted',
   #               'page reconciliation calls',
   #               'page reconciliation calls for eviction',
   #               'pages deleted',
   #               'split bytes currently awaiting free',
   #               'split objects currently awaiting free'
   #      end
   #
   #      inside 'transaction' do
   #        ignore 'number of named snapshots created',
   #               'number of named snapshots dropped',
   #               'transaction begins',
   #               'transaction checkpoint currently running',
   #               'transaction checkpoint generation',
   #               'transaction checkpoint max time (msecs)',
   #               'transaction checkpoint min time (msecs)',
   #               'transaction checkpoint most recent time (msecs)',
   #               'transaction checkpoint scrub dirty target',
   #               'transaction checkpoint scrub time (msecs)',
   #               'transaction checkpoint total time (msecs)',
   #               'transaction checkpoints',
   #               'transaction failures due to cache overflow',
   #               'transaction fsync calls for checkpoint after allocating the transaction ID',
   #               'transaction fsync duration for checkpoint after allocating the transaction ID (usecs)',
   #               'transaction range of IDs currently pinned',
   #               'transaction range of IDs currently pinned by a checkpoint',
   #               'transaction range of IDs currently pinned by named snapshots',
   #               'transaction sync calls',
   #               'transactions committed',
   #               'transactions rolled back'
   #      end
   #
   #      inside 'session' do
   #        ignore 'open cursor count',
   #               'open session count',
   #               'table compact failed calls',
   #               'table compact successful calls',
   #               'table create failed calls',
   #               'table create successful calls',
   #               'table drop failed calls',
   #               'table drop successful calls',
   #               'table rebalance failed calls',
   #               'table rebalance successful calls',
   #               'table rename failed calls',
   #               'table rename successful calls',
   #               'table salvage failed calls',
   #               'table salvage successful calls',
   #               'table truncate failed calls',
   #               'table truncate successful calls',
   #               'table verify failed calls',
   #               'table verify successful calls'
   #      end
   #
   #      inside 'log' do
   #        ignore 'busy returns attempting to switch slots',
   #               'consolidated slot closures',
   #               'consolidated slot join races',
   #               'consolidated slot join transitions',
   #               'consolidated slot joins',
   #               'consolidated slot unbuffered writes',
   #               'log bytes of payload data',
   #               'log bytes written',
   #               'log files manually zero-filled',
   #               'log flush operations',
   #               'log force write operations',
   #               'log force write operations skipped',
   #               'log records compressed',
   #               'log records not compressed',
   #               'log records too small to compress',
   #               'log release advances write LSN',
   #               'log scan operations',
   #               'log scan records requiring two reads',
   #               'log server thread advances write LSN',
   #               'log server thread write LSN walk skipped',
   #               'log sync operations',
   #               'log sync time duration (usecs)',
   #               'log sync_dir operations',
   #               'log sync_dir time duration (usecs)',
   #               'log write operations',
   #               'logging bytes consolidated',
   #               'maximum log file size',
   #               'number of pre-allocated log files to create',
   #               'pre-allocated log files not ready and missed',
   #               'pre-allocated log files prepared',
   #               'pre-allocated log files used',
   #               'records processed by log scan',
   #               'total in-memory size of compressed records',
   #               'total log buffer size',
   #               'total size of compressed records',
   #               'written slots coalesced',
   #               'yields waiting for previous log file close'
   #      end
        inside 'block-manager' do
          ignore 'file magic number',
                 'file major version number',
                 'minor version number'

          counter 'allocations requiring file extension',
                  as: 'allocation_with_extension'

          counter 'blocks allocated',
                  as: 'allocated_blocks'

          counter 'blocks freed',
                  as: 'freed_blocks'

          gauge 'checkpoint size',
                as: 'checkpoint_size'

          gauge 'file allocation unit size',
                as: 'file_allocation_unit_size_bytes'

          gauge 'file bytes available for reuse',
                as: 'file_reusable_bytes'

          gauge 'file size in bytes',
                 as: 'file_size_bytes'
        end

        inside 'compression' do
          counter 'compressed pages read',
                  as: 'read_pages'
          counter 'compressed pages written',
                  as: 'written_pages'
          counter 'page written failed to compress',
                  as: 'failed_to_compress_written_pages'
          counter 'page written was too small to compress',
                  as: 'too_small_to_compress_written_pages'

          counter 'raw compression call failed, additional data available',
                  as: 'raw_failed_with_data_calls'
          counter 'raw compression call failed, no additional data available',
                  as: 'raw_failed_without_data_calls'
          counter 'raw compression call succeeded',
                  as: 'raw_success_calls'
        end

        inside 'cursor' do
          counter 'cursor-insert key and value bytes inserted',
                  as: 'insert_key_value_bytes'
          counter 'cursor-remove key bytes removed',
                  as: 'remove_key_bytes'
          counter 'cursor-update value bytes updated',
                  as: 'update_value_bytes'

          counter 'restarted searches',
                   as: 'restarted_searches'

          # Not sure about that one
          counter 'bulk-loaded cursor-insert calls', {type: 'bulk_load_insert'},
                   as: 'calls'

          counter 'create calls',      {type: 'create'}, as: 'calls'
          counter 'insert calls',      {type: 'insert'}, as: 'calls'
          counter 'next calls',        {type: 'next'}, as: 'calls'
          counter 'prev calls',        {type: 'prev'}, as: 'calls'
          counter 'remove calls',      {type: 'remove'}, as: 'calls'
          counter 'reset calls',       {type: 'reset'}, as: 'calls'
          counter 'search calls',      {type: 'search'}, as: 'calls'
          counter 'search near calls', {type: 'search_near'}, as: 'calls'
          counter 'truncate calls',    {type: 'truncate'}, as: 'calls'
          counter 'update calls',      {type: 'update'}, as: 'calls'
        end

      end

      gauge 'ok', as: 'metrics_is_ok'
    end
  end
end
