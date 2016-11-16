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
    @help_text = nil
  end

  def to_prom(prefix)
    with(prefix) { banner }
  end

  def banner
    [help, type, full_value].compact.join("\n")
  end

  def full_name
    [@prefix, name].compact.join("_")
  end

  def full_name_with_labels
    "#{full_name}#{full_labels}"
  end

  def registrable?
    value != nil
  end

  private

  def with(prefix, extra_labels = {})
    original_prefix = @prefix
    @prefix = prefix

    result = yield

    @prefix = original_prefix
    @extra_labels = nil

    return result
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
      %Q/#{key}=#{value.to_s.dump}/
    end.join(",")

    "{#{text}}"
  end

  def full_value
    "#{full_name_with_labels} #{value}"
  end
end
