class DSL
  class Helper
    class << self
      attr_reader :proxy

      def metrics(&blk)
        @proxy = blk
      end
    end
  end
end
