class Prometheus
  attr_reader :config

  def initialize(config = Settings.current)
    @config = config
  end

  def to_s
    all_points.map {|point| point.to_prom("mongo")}.join("\n")
  end

  def all_points
    all_metrics.map(&:all).flatten
  end

  def all_metrics
    config.mongo.all.map(&:metrics).flatten
  end
end
