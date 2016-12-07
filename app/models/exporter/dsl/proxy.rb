module Exporter
  class DSL
    # Here goes the DSL logic. This class is the context where `metrics` block
    # is evaluated, so keep an eye on the methods.
    class Proxy
      attr_reader :all, :keys_not_found, :keys_left, :value_missing
      attr_reader :rules, :context, :labels

      def initialize(context, labels = {}, &rules)
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
        @keys_not_found << name
      end

      def key_left(name, value)
        @keys_left[name] = value
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
        register Point::Counter.new metric_name(as),
                                    extract(key_name),
                                    all_labels(labels)
      end

      def gauge(key_name, labels = {}, as: nil)
        as ||= key_name
        register Point::Gauge.new metric_name(as),
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
        nested_context = ::DSL::Context.new(key_name, as, self)

        ::DSL::NestedProxy.new(scope, labels, nested_context, &block)
      end

      def namespace(key_name, &block)
        nested_context = ::DSL::Context.new(key_name, nil, self)

        ::DSL::NestedProxy.new(context, labels, nested_context, &block)
      end

      # Extraction and transformaton

      def extract(key_name, fallback = nil)
        current_context = context || {}

        current_context.delete(key_name) do
          not_found(key_name)
          break fallback
        end
      end

      def key?(key_name)
        current_context = context || {}

        current_context.key? key_name
      end

      def value(key_name, fallback = nil)
        current_context = context || {}

        current_context[key_name] || fallback
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

      # Helpers

      def use(mod)
        nested_rules = mod.proxy
        instance_eval(&nested_rules)
      end

      # Utility methods
      def keys
        context.keys
      end

      private

      def metric_name(key_name)
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
end
