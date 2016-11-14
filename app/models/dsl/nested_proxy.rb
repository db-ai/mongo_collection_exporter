class DSL
  class NestedProxy < DSL::Proxy
    attr_reader :parent, :parent_name

    def initialize(rules, context, labels, parent_name, parent)
      @parent_name = parent_name
      @parent = parent

      super rules, context, labels
    end

    # Just forward everything to parent

    def register(point)
      parent.register point
    end

    def not_found(name)
      parent.not_found nested(name)
    end

    def key_left(name, value)
      parent.key_left nested(name), value
    end

    def parent_name
      # FIXME: This is not really, um, unsurprising logic?
      return [@parent_name] if root?

      [parent.parent_name, @parent_name].compact.flatten
    end

    def root?
      !parent.respond_to?(:parent_name)
    end

    private
    def nested(key_name)
      [parent_name, key_name].flatten
    end
  end
end
