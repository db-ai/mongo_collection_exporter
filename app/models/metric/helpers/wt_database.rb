class WiredTigerDatabaseHelper < DSL::Helper
  # Thats a huge one. We are begin very specific on this metrics, to
  # spot the diffirence between server-level and collection level metrics.
  metrics do
    ignore 'uri'

    inside 'LSM', as: 'lsm' do
      gauge 'application work units currently queued', {type: 'app'},
            as: 'work_units_queued'

      gauge 'merge work units currently queued', {type: 'merge'},
            as: 'work_units_queued'

      gauge 'switch work units currently queued', {type: 'switch'},
            as: 'work_units_queued'

      # Or gauge?
      counter 'rows merged in an LSM tree',
               as: 'tree_rows_merged'

      gauge 'sleep for LSM checkpoint throttle', {task: 'checkpoint'},
            as: 'throttle_sleep'

      gauge 'sleep for LSM merge throttle', {task: 'merge'},
            as: 'merge_throttle_sleep'

      gauge 'tree maintenance operations discarded', {type: 'discarded'},
            as: 'tree_maintanace_ops'

      gauge 'tree maintenance operations executed', {type: 'executed'},
            as: 'tree_maintanace_ops'

      gauge 'tree maintenance operations scheduled', {type: 'scheduled'},
            as: 'tree_maintanace_ops'

      gauge 'tree queue hit maximum',
            as: 'tree_queue_hit_max'
    end

    inside "async" do
      gauge 'current work queue length',
            as: 'work_queue_length_current'
      gauge 'maximum work queue length',
            as: 'work_queue_length_max'

      # More likely to be a counter
      counter 'number of allocation state races',
               as: 'allocation_state_races'
      counter 'number of flush calls',
               as: 'flush_calls'
      counter 'number of operation slots viewed for allocation',
               as: 'slots_viewed_for_allocation'
      counter 'number of times operation allocation failed',
               as: 'operation_allocation_failed'
      counter 'number of times worker found no work',
               as: 'worker_work_not_found'

      counter 'total allocations',
            as: 'allocations_total'

      counter 'total compact calls', {type: 'compact'},
              as: 'calls_total'
      counter 'total insert calls', {type: 'insert'},
              as: 'calls_total'
      counter 'total remove calls', {type: 'remove'},
              as: 'calls_total'
      counter 'total search calls', {type: 'search'},
              as: 'calls_total'
      counter 'total update calls', {type: 'update'},
              as: 'calls_total'
    end

    inside 'block-manager', as: 'block_manager' do
      counter 'blocks pre-loaded',
              as: 'preloaded_blocks'

      counter 'blocks read',
              as: 'read_blocks'

      counter 'blocks written',
              as: 'written_blocks'

      counter 'bytes read',
              as: 'read_bytes'

      counter 'bytes written',
              as: 'written_bytes'

      counter 'bytes written for checkpoint',
              as: 'checkpoint_written_bytes'

      counter 'mapped blocks read',
              as: 'read_mapped_blocks'

      counter 'mapped bytes read',
              as: 'read_mapped_bytes'
    end

    inside 'connection' do
      counter 'auto adjusting condition resets',
              as: 'adjusting_resets'

      counter 'auto adjusting condition wait calls',
              as: 'adjusting_wait_calls'

      counter 'files currently open',
              as: 'files_open'

      counter 'memory allocations',
              as: 'mem_allocations'
      counter 'memory frees',
              as: 'mem_frees'
      counter 'memory re-allocations',
              as: 'mem_realloc'

      counter 'pthread mutex condition wait calls',
              as: 'mutex_condition_wait_calls'

      counter 'pthread mutex shared lock read-lock calls',
              as: 'mutex_shared_lock_read_calls'

      counter 'pthread mutex shared lock write-lock calls',
              as: 'mutex_shared_lock_write_calls'

      counter 'total fsync I/Os',
            as: 'fsync_io_total'
      counter 'total read I/Os',
            as: 'read_io_total'
      counter 'total write I/Os',
            as: 'write_io_total'
    end

    inside 'concurrentTransactions', as: 'concurrent_transactions' do
      inside 'read' do
        gauge 'out'
        gauge 'available'
        gauge 'totalTickets', as: 'tickets_total'
      end

      inside 'write' do
        gauge 'out'
        gauge 'available'
        gauge 'totalTickets', as: 'tickets_total'
      end
    end

    inside 'cache' do
      ignore 'bytes belonging to page images in the cache',
             'bytes not belonging to page images in the cache',
             'checkpoint blocked page eviction',
             'eviction calls to get a page',
             'eviction calls to get a page found queue empty',
             'eviction calls to get a page found queue empty after locking',
             'eviction currently operating in aggressive mode',
             'eviction empty score',
             'eviction server candidate queue empty when topping up',
             'eviction server candidate queue not empty when topping up',
             'eviction server evicting pages',
             'eviction server slept, because we did not make progress with eviction',
             'eviction server unable to reach eviction goal',
             'eviction state',
             'eviction walks abandoned',
             'eviction worker thread evicting pages',
             'failed eviction of pages that exceeded the in-memory maximum',
             'files with active eviction walks',
             'files with new eviction walks started',
             'hazard pointer blocked page eviction',
             'hazard pointer check calls',
             'hazard pointer check entries walked',
             'hazard pointer maximum array length',
             'in-memory page passed criteria to be split',
             'in-memory page splits',
             'internal pages evicted',
             'internal pages split during eviction',
             'leaf pages split during eviction',
             'lookaside table insert calls',
             'lookaside table remove calls',
             'maximum bytes configured',
             'maximum page size at eviction',
             'modified pages evicted',
             'modified pages evicted by application threads',
             'overflow pages read into cache',
             'overflow values cached in memory',
             'page split during eviction deepened the tree',
             'page written requiring lookaside records',
             'pages currently held in the cache',
             'pages evicted because they exceeded the in-memory maximum',
             'pages evicted because they had chains of deleted items',
             'pages evicted by application threads',
             'pages queued for eviction',
             'pages queued for urgent eviction',
             'pages queued for urgent eviction during walk',
             'pages read into cache',
             'pages read into cache requiring lookaside entries',
             'pages requested from the cache',
             'pages seen by eviction walk',
             'pages selected for eviction unable to be evicted',
             'pages walked for eviction',
             'pages written from cache',
             'pages written requiring in-memory restoration',
             'percentage overhead',
             'tracked bytes belonging to internal pages in the cache',
             'tracked bytes belonging to leaf pages in the cache',
             'tracked dirty bytes in the cache',
             'tracked dirty pages in the cache',
             'unmodified pages evicted'

      gauge 'bytes currently in the cache',
            as: 'used_bytes'

      counter 'bytes read into cache',
            as: 'read_into_bytes'

      counter 'bytes written from cache',
            as: 'written_from_bytes'
    end

    inside 'cursor' do
      counter 'cursor create calls',      {type: 'create'}, as: 'calls'
      counter 'cursor insert calls',      {type: 'insert'}, as: 'calls'
      counter 'cursor next calls',        {type: 'next'}, as: 'calls'
      counter 'cursor prev calls',        {type: 'prev'}, as: 'calls'
      counter 'cursor remove calls',      {type: 'remove'}, as: 'calls'
      counter 'cursor reset calls',       {type: 'reset'}, as: 'calls'
      counter 'cursor restarted searches',{type: 'restarted'}, as: 'calls'
      counter 'cursor search calls',      {type: 'search'}, as: 'calls'
      counter 'cursor search near calls', {type: 'search_near'}, as: 'calls'
      counter 'cursor update calls',      {type: 'update'}, as: 'calls'
      counter 'truncate calls',           {type: 'truncate'}, as: 'calls'
    end

    # TODO: Investigate need of this metrics?
    inside 'thread-state' do
      ignore 'active filesystem fsync calls',
             'active filesystem read calls',
             'active filesystem write calls'
    end

    inside 'thread-yield' do
      ignore 'page acquire busy blocked',
             'page acquire eviction blocked',
             'page acquire locked blocked',
             'page acquire read blocked',
             'page acquire time sleeping (usecs)'
    end

    inside 'data-handle' do
      ignore 'connection data handles currently active',
             'connection sweep candidate became referenced',
             'connection sweep dhandles closed',
             'connection sweep dhandles removed from hash list',
             'connection sweep time-of-death sets',
             'connection sweeps',
             'session dhandles swept',
             'session sweep attempts'
    end

    inside 'reconciliation' do
      ignore 'fast-path pages deleted',
             'page reconciliation calls',
             'page reconciliation calls for eviction',
             'pages deleted',
             'split bytes currently awaiting free',
             'split objects currently awaiting free'
    end

    inside 'transaction' do
      ignore 'number of named snapshots created',
             'number of named snapshots dropped',
             'transaction begins',
             'transaction checkpoint currently running',
             'transaction checkpoint generation',
             'transaction checkpoint max time (msecs)',
             'transaction checkpoint min time (msecs)',
             'transaction checkpoint most recent time (msecs)',
             'transaction checkpoint scrub dirty target',
             'transaction checkpoint scrub time (msecs)',
             'transaction checkpoint total time (msecs)',
             'transaction checkpoints',
             'transaction failures due to cache overflow',
             'transaction fsync calls for checkpoint after allocating the transaction ID',
             'transaction fsync duration for checkpoint after allocating the transaction ID (usecs)',
             'transaction range of IDs currently pinned',
             'transaction range of IDs currently pinned by a checkpoint',
             'transaction range of IDs currently pinned by named snapshots',
             'transaction sync calls',
             'transactions committed',
             'transactions rolled back'
    end

    inside 'session' do
      ignore 'open cursor count',
             'open session count',
             'table compact failed calls',
             'table compact successful calls',
             'table create failed calls',
             'table create successful calls',
             'table drop failed calls',
             'table drop successful calls',
             'table rebalance failed calls',
             'table rebalance successful calls',
             'table rename failed calls',
             'table rename successful calls',
             'table salvage failed calls',
             'table salvage successful calls',
             'table truncate failed calls',
             'table truncate successful calls',
             'table verify failed calls',
             'table verify successful calls'
    end

    inside 'log' do
      ignore 'busy returns attempting to switch slots',
             'consolidated slot closures',
             'consolidated slot join races',
             'consolidated slot join transitions',
             'consolidated slot joins',
             'consolidated slot unbuffered writes',
             'log bytes of payload data',
             'log bytes written',
             'log files manually zero-filled',
             'log flush operations',
             'log force write operations',
             'log force write operations skipped',
             'log records compressed',
             'log records not compressed',
             'log records too small to compress',
             'log release advances write LSN',
             'log scan operations',
             'log scan records requiring two reads',
             'log server thread advances write LSN',
             'log server thread write LSN walk skipped',
             'log sync operations',
             'log sync time duration (usecs)',
             'log sync_dir operations',
             'log sync_dir time duration (usecs)',
             'log write operations',
             'logging bytes consolidated',
             'maximum log file size',
             'number of pre-allocated log files to create',
             'pre-allocated log files not ready and missed',
             'pre-allocated log files prepared',
             'pre-allocated log files used',
             'records processed by log scan',
             'total in-memory size of compressed records',
             'total log buffer size',
             'total size of compressed records',
             'written slots coalesced',
             'yields waiting for previous log file close'
    end
  end
end
