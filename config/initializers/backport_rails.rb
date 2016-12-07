# This file containts backports from rails master.

# Issue: https://github.com/rails/rails/issues/26912
# Pull Request: https://github.com/rails/rails/pull/27007
# Introduced: 5.0.0.1
module ActionDispatch
  module Http
    module MimeNegotiation
      def has_content_type? # :nodoc:
        get_header "CONTENT_TYPE"
      end
    end
  end
end
