# Container for metric parsing DSL. It is used to hold `metrics` body and to
# provide basic API to read parsed data.
module Exporter
  class Metric
    attr_reader :raw

    def initialize(raw, labels = {})
      @raw = raw
      @labels = labels
      @proxy = DSL::Proxy.new(raw, labels, &self.class.proxy)
    end

    def all
      @proxy.all
    end

    def keys_not_found
      @proxy.keys_not_found
    end

    def keys_left
      @proxy.keys_left
    end
  end
end
