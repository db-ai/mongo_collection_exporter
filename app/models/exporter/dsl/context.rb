class DSL
  # Despite the fact it called Context, it's something like namespace, that
  # can be nested, and names can be inherited.
  #
  # This class is used by `inside` DSL method to keep the nesting of the
  # names.
  class Context
    attr_reader :scope, :name, :nickname, :parent

    def initialize(name, nickname, parent)
      @name = name
      @nickname = nickname || name
      @parent = parent
    end

    def root?
      !parent.respond_to? :parent_context
    end

    def parent_context
      parent.parent_context
    end

    def metric_name
      if root?
        [nickname]
      else
        parent_context.metric_name + [nickname]
      end
    end

    def context_name
      if root?
        [name]
      else
        parent_context.context_name + [name]
      end
    end
  end
end
