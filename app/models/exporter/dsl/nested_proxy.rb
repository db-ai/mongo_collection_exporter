module Exporter
  class DSL
    # This class overrides some parts of DSL::Proxy to make proxies nestable, so
    # we can implement things like `inside` and `namespace`.
    class NestedProxy < DSL::Proxy
      attr_reader :parent_context

      def initialize(context, labels, parent_context)
        @parent_context = parent_context

        super context, labels
      end

      # Just forward everything to parent

      def register(point)
        parent.register point
      end

      def not_found(name)
        parent.not_found context_name(name)
      end

      def key_left(name, value)
        parent.key_left context_name(name), value
      end

      private

      def metric_name(key_name)
        [parent_context.metric_name, key_name].flatten
      end

      def context_name(key_name)
        [parent_context.context_name, key_name].flatten
      end

      def parent
        parent_context.parent
      end
    end
  end
end
