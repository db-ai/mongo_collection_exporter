class Server
  # Implements Configuration Server node role
  class Config < Server::Shard
    def extra_labels
      { }
    end
  end
end
