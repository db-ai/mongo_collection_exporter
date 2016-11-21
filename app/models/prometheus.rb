# This class aggregates all metrics from all nodes and presents them in the
# Prometheus Text format (>0.0.4)
#
# Additionaly it provides `scrape_duration_ms` metric, that just tells how
# long it took to read all metrics.
class Prometheus
  attr_reader :config, :prefix

  METRIC_PREFIX = "mongo".freeze

  def initialize(config = Settings.current, prefix = METRIC_PREFIX)
    @config = config
    @points = []
    @prefix = prefix

    prepare
  end

  def to_s
    # Trailing new-line is strictly required by Prometheus
    @points.join("\n") + "\n"
  end

  private

  def scrape_duration
    point = Point::Gauge.new("scrape_duration_ms", (@runtime * 1000.0).to_i)

    [point.to_prom_banner(prefix), point.to_prom(prefix)]
  end

  def prepare
    runtime do
      points_iterator = all_points_by_name.each_with_object([])

      @points = points_iterator do |(name, points), memo|
        memo
          .concat [points.first.to_prom_banner(prefix)]
          .concat promethize(points)
      end
    end

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
      points = memo[full_name] ||= Array.new
      points.push(point)
    end
  end

  def promethize(points)
    points.map {|point| point.to_prom(prefix) }
  end

  def runtime(before = Time.now)
    yield

    @runtime = Time.now - before
  end
end
