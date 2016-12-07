module Exporter
  class DSL
    # Tiny class that used by `use` DSL method to implement reusable parts of
    # DSL logic.
    class Helper
      class << self
        attr_reader :proxy

        def metrics(&blk)
          @proxy = blk
        end
      end
    end
  end
end
