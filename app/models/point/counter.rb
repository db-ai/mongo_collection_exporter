class Point
  # Metric point that is changes only upwards with possible resets to zero. Like
  # number of requests processed or count of logins.
  class Counter < Point
    def type_name
      'COUNTER'.freeze
    end
  end
end
