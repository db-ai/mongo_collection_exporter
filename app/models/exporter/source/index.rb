module Exporter
  class Source
    # Metrix extracted from db.getCollection(name).stats()[`indexDetails`] key
    # in the collection metrics hash.
    class Index < Exporter::Source
      metrics do
        namespace 'wt' do
          use Exporter::Source::Helpers::WiredTigerCollection
        end
      end
    end
  end
end
