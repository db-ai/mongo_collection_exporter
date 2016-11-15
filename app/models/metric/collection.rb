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

        inside 'reconciliation' do
          ignore 'dictionary matches',
                 'fast-path pages deleted',
                 'internal page key bytes discarded using suffix compression',
                 'internal page multi-block writes',
                 'internal-page overflow keys',
                 'leaf page key bytes discarded using prefix compression',
                 'leaf page multi-block writes',
                 'leaf-page overflow keys',
                 'maximum blocks required for a page',
                 'overflow values written',
                 'page checksum matches'

          counter 'page reconciliation calls',
                  as: 'page_calls'

          counter 'page reconciliation calls for eviction',
                  as: 'page_eviction_calls'

          counter 'pages deleted',
                  as: 'page_delete_calls'
        end

        inside 'session' do
          counter 'object compaction',
                  as: 'object_compaction'
          counter 'open cursor count',
                  as: 'open_cursor_count'
        end

        inside 'transaction' do
          counter 'update conflicts',
                  as: 'update_conflicts'
        end
      end

      gauge 'ok', as: 'metrics_is_ok'
    end
  end
end
