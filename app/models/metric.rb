class Metric
  class << self
    attr_reader :proxy

    def metrics(&blk)
      @proxy = blk
    end
  end

  attr_reader :raw

  def initialize(raw, labels = {})
    @raw = raw
    @labels = labels
    @proxy = DSL::Proxy.new(self.class.proxy, raw, labels)
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
