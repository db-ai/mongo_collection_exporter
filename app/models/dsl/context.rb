class DSL
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
