module Exporter
  class Point
    # Metric point that is changes upwards and backwards, like amount of RAM
    # used, or number of available cash desks in the store.
    class Gauge < Point
      GAUGE_TYPE = 'COUNTER'.freeze

      def type_name
        GAUGE_TYPE
      end
    end
  end
end
