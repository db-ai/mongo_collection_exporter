class Metric
  class Index < Metric
    metrics do
      use WiredTigerCollectionHelper
    end
  end
end
