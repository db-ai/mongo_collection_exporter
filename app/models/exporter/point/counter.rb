module Exporter
  class Point
    # Metric point that is changes only upwards with possible resets to zero.
    # Like number of requests processed or count of logins.
    class Counter < Point
      COUNTER_TYPE = 'COUNTER'.freeze

      def type_name
        COUNTER_TYPE
      end
    end
  end
end
