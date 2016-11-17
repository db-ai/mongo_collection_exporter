class Prometheus
  attr_reader :config

  METRIC_PREFIX = "mongo".freeze

  def initialize(config = Settings.current)
    @config = config
    @points = []

    prepare!
  end

  def to_s
    # Trailing new-line is strictly required by Prometheus
    @points.join("\n") + "\n"
  end

  private

  def scrape_duration
    point = Point::Gauge.new("scrape_duration_ms", (@runtime * 1000.0).to_i)

    [point.to_prom_banner(METRIC_PREFIX), point.to_prom(METRIC_PREFIX)]
  end

  def prepare!
    before = Time.now.to_f

    @points = all_points_by_name.each_with_object([]) do |(name, points), memo|
      memo << points.first.to_prom_banner(METRIC_PREFIX)
      memo.concat points.map {|point| point.to_prom(METRIC_PREFIX) }
    end

    @runtime = Time.now.to_f - before

    @points.concat scrape_duration
  end

  def all_points
    all_metrics.map(&:all).flatten
  end

  def all_metrics
    config.mongo.all.map(&:metrics).flatten
  end

  def all_points_by_name
    all_points.each_with_object(Hash.new) do |point, memo|
      full_name = point.full_name
      memo[full_name] ||= Array.new
      memo[full_name].push(point)
    end
  end
end
