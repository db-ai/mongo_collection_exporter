class Prometheus
  attr_reader :config

  def initialize(config = Settings.current)
    @config = config
  end

  def to_s
    lines = all_points_by_name.each_with_object([]) do |(name, points), memo|
      memo << points.first.banner
      memo.concat points.map {|point| point.to_prom("mongo") }
    end

    # Trailing new-line is strictly required by Prometheus
    lines.join("\n") + "\n"
  end

  def all_points
    all_metrics.map(&:all).flatten
  end

  def all_points_by_name
    all_points.each_with_object(Hash.new) do |point, memo|
      full_name = point.full_name
      memo[full_name] ||= Array.new
      memo[full_name].push(point)
    end
  end

  def all_metrics
    config.mongo.all.map(&:metrics).flatten
  end
end
