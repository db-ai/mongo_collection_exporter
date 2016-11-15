class DSL
  class Proxy
    attr_reader :all, :keys_not_found, :keys_left, :value_missing
    attr_reader :rules, :context, :labels

    def initialize(rules, context, labels = {})
      @rules = rules.freeze
      @context = context
      @labels = labels.freeze

      @all = []
      @keys_not_found = []
      @keys_left = {}
      @value_missing = []

      evaluate_rules

      leftover_the_rest_of context
    end

    def evaluate_rules
      instance_eval(&rules)
    end

    # Registry

    def register(point)
      if point.registrable?
        @all << point
      else
        @value_missing << point
      end
    end

    def not_found(name)
      @keys_not_found << nested(name)
    end

    def key_left(name, value)
      @keys_left[nested(name)] = value
    end

    def leftover_the_rest_of(object)
      return unless object

      object.each do |key, value|
        key_left key, value
      end
    end

    # Points created from root context

    def counter(key_name, labels = {}, as: nil)
      as ||= key_name
      register Point::Counter.new nested(as),
                                  extract(key_name),
                                  all_labels(labels)
    end

    def gauge(key_name, labels = {}, as: nil)
      as ||= key_name
      register Point::Gauge.new nested(as),
                                extract(key_name),
                                all_labels(labels)
    end

    # Manual Points

    def counter!(key_name, value, labels = {})
      register Point::Counter.new key_name,
                                  value,
                                  all_labels(labels)
    end

    def gauge!(key_name, value, labels = {})
      register Point::Gauge.new key_name,
                                value,
                                all_labels(labels)
    end

    # Nesting

    def inside(key_name, as: nil, &block)
      scope = extract(key_name)

      ::DSL::NestedProxy.new(block, scope, labels, key_name, self)
    end

    # Extraction and transformaton

    def extract(key_name, fallback = nil)
      current_context = context || Hash.new

      current_context.delete(key_name) do
        not_found(key_name)
        break fallback
      end
    end

    def ignore(*key_names)
      key_names.flatten.each do |key_name|
        extract key_name
      end
    end

    def iterate
      context.each_key do |key_name|
        value = extract(key_name)
        yield key_name, value
      end
    end

    # Utility methods
    def keys
      context.keys
    end

    private
    def nested(key_name)
      key_name
    end

    def all_labels(extra_labels)
      labels.merge extra_labels
    end

    def log
      Padrino.logger
    end
  end
end
