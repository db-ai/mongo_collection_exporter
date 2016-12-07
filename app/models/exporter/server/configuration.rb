module Exporter
  class Server
    # Implements Configuration Server node role
    class Configuration < Exporter::Server::Shard
      def extra_labels
        {}
      end
    end
  end
end
