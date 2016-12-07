# Abstract Metric data Point. Represents the metric value of Counter or Gauge
# types. It can hold 1 value attached to a name with some labels. Take a look
# at Prometheus metrics to make sense of the difference between name and label.
class Point
  attr_reader :name, :value, :labels
  attr_reader :help_text

  def initialize(name, value, labels = {})
    unless labels.is_a? Hash
      raise ArgumentError, "Label should be a hash, but got a '#{labels}'"
    end

    @name = name
    @value = value
    @labels = labels
  end

  def to_prom(prefix)
    with(prefix) { metric }
  end

  def to_prom_banner(prefix)
    with(prefix) { banner }
  end

  def metric
    [full_value].compact.join("\n")
  end

  def banner
    [help, type].compact.join("\n")
  end

  def full_name
    [@prefix, name].compact.join('_')
  end

  def full_name_with_labels
    "#{full_name}#{full_labels}"
  end

  def registrable?
    value != nil
  end

  private

  def with(prefix)
    original_prefix = @prefix
    @prefix = prefix

    result = yield

    @prefix = original_prefix

    result
  end

  def help
    "# HELP #{help_text}" if help_text
  end

  def type
    "# TYPE #{full_name} #{type_name}"
  end

  def type_name
    'UNTYPED'
  end

  def full_labels
    return '' if labels.empty?
    text = labels.map do |key, value|
      %(#{key}=#{value.to_s.dump})
    end.join(',')

    "{#{text}}"
  end

  def full_value
    "#{full_name_with_labels} #{value}"
  end
end
