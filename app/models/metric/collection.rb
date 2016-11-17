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

      inside 'wiredTiger', as: 'wt' do
        use WiredTigerCollectionHelper
      end

      gauge 'ok', as: 'metrics_is_ok'
    end
  end
end
