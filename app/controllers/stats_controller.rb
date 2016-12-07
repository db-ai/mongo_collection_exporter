class StatsController < ApplicationController
  def index
    render plain: "OKAY"
  end

  def metrics
    render plain: Prometheus.new.to_s
  end
end
