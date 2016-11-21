class Point
  # Metric point that is changes upwards and backwards, like amount of RAM used,
  # or number of available cash desks in the store.
  class Gauge < Point
    def type_name
      'GAUGE'.freeze
    end
  end
end
