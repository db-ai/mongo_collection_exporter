class Metric
  class Index < Metric
    metrics do
      namespace 'wt' do
        use WiredTigerCollectionHelper
      end
    end
  end
end
