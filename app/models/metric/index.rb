class Metric
  # Metrix extracted from db.getCollection(name).stats()[`indexDetails`] key in
  # the collection metrics hash.
  class Index < Metric
    metrics do
      namespace 'wt' do
        use WiredTigerCollectionHelper
      end
    end
  end
end
