# WiredTiger rules for collections.
class WiredTigerCollectionHelper < DSL::Helper
  metrics do
    ignore 'uri', 'type', 'creationString'

    inside 'metadata' do
      ignore 'infoObj'
      gauge 'formatVersion', as: 'format_version'
    end

    inside 'LSM', as: 'lsm' do
      counter 'bloom filter false positives',
              as: 'bloom_filer_false_positives'
      counter 'bloom filter hits',
              as: 'bloom_filer_hits'
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

      gauge 'sleep for LSM checkpoint throttle', { task: 'checkpoint' },
            as: 'throttle_sleep'

      gauge 'sleep for LSM merge throttle', { task: 'merge' },
            as: 'merge_throttle_sleep'

      counter 'total size of bloom filters',
              as: 'filter_total_size_bytes'
    end

    inside 'block-manager', as: 'block_manager' do
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

    inside 'btree' do
      counter 'btree checkpoint generation',
              as: 'checkpoint_gen'

      counter 'column-store fixed-size leaf pages', { type: 'fixed_leaf' },
              as: 'column_store_pages'

      counter 'column-store internal pages', { type: 'internal' },
              as: 'column_store_pages'

      counter 'column-store variable-size leaf pages', { type: 'var_leaf' },
              as: 'column_store_pages'

      counter 'column-store variable-size RLE encoded values',
              { type: 'var_rle' }, as: 'column_store_values'

      counter 'column-store variable-size deleted values',
              { type: 'var_deleted' }, as: 'column_store_values'

      gauge 'fixed-record size',
            as: 'fixed_record_size'

      gauge 'maximum internal page key size',
            as: 'max_internal_page_key_size'

      gauge 'maximum internal page size',
            as: 'max_interal_page_size'

      gauge 'maximum leaf page key size',
            as: 'max_leaf_page_key_size'

      gauge 'maximum leaf page size',
            as: 'max_leaf_page_size'

      gauge 'maximum leaf page value size',
            as: 'max_leaf_page_value_size'

      gauge 'maximum tree depth',
            as: 'max_tree_depth'

      gauge 'number of key/value pairs',
            as: 'key_value_pairs'

      gauge 'overflow pages',
            as: 'overflow_pages'

      gauge 'pages rewritten by compaction',
            as: 'rewritten_by_compaction_pages'

      gauge 'row-store internal pages', { type: 'internal' },
            as: 'row_store_pages'

      gauge 'row-store leaf pages', { type: 'leaf' },
            as: 'row_store_pages'
    end

    inside 'cache' do
      ignore 'overflow pages read into cache',
             'overflow values cached in memory',
             'page split during eviction deepened the tree',
             'page written requiring lookaside records',
             'pages read into cache requiring lookaside entries',
             'pages written requiring in-memory restoration'

      counter 'in-memory page passed criteria to be split',
              as: 'can_be_split_inmem_pages'

      counter 'in-memory page splits',
              as: 'split_inmem_pages'

      counter 'data source pages selected for eviction unable to be evicted',
              as: 'selected_but_cant_be_evicted_pages'

      counter 'checkpoint blocked page eviction',
              { cause: 'checkpoint' }, as: 'page_eviction_blocked'

      counter 'hazard pointer blocked page eviction',
              { cause: 'hazard_ponter' }, as: 'page_eviction_blocked'

      counter 'internal pages split during eviction', { type: 'internal' },
              as: 'split_during_eviction_pages'

      counter 'leaf pages split during eviction', { type: 'leaf' },
              as: 'split_during_eviction_pages'

      gauge 'bytes currently in the cache',
            as: 'used_bytes'

      counter 'bytes read into cache',
              as: 'read_into_bytes'

      counter 'bytes written from cache',
              as: 'written_from_bytes'

      counter 'pages read into cache',
              as: 'read_into_pages'

      counter 'pages requested from the cache',
              as: 'read_from_pages'

      counter 'pages written from cache',
              as: 'written_from_pages'

      counter 'unmodified pages evicted', { type: 'unmodified' },
              as: 'evicted_pages'

      counter 'modified pages evicted', { type: 'modified' },
              as: 'evicted_pages'

      counter 'internal pages evicted', { type: 'internal' },
              as: 'evicted_pages'
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

      # Not sure that this is same event as 'insert calls'
      counter 'bulk-loaded cursor-insert calls', { type: 'bulk_load_insert' },
              as: 'calls'

      counter 'create calls',      { type: 'create' }, as: 'calls'
      counter 'insert calls',      { type: 'insert' }, as: 'calls'
      counter 'next calls',        { type: 'next' }, as: 'calls'
      counter 'prev calls',        { type: 'prev' }, as: 'calls'
      counter 'remove calls',      { type: 'remove' }, as: 'calls'
      counter 'reset calls',       { type: 'reset' }, as: 'calls'
      counter 'search calls',      { type: 'search' }, as: 'calls'
      counter 'search near calls', { type: 'search_near' }, as: 'calls'
      counter 'truncate calls',    { type: 'truncate' }, as: 'calls'
      counter 'update calls',      { type: 'update' }, as: 'calls'
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
end
