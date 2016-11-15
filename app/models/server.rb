class Server
  attr_reader :address
  attr_reader :client

  def initialize(address)
    @address = address
    @client = Mongo::Client.new [address],
                                connect: connect_type,
                                database: default_database
  end

  def connect_type
    :direct
  end

  def default_database
    :admin
  end

  def default_labels
    {
      node: address,
      role: self.class.name.split("::").last.downcase,
    }
  end

  def extra_labels
    {}
  end

  def labels
    default_labels.merge extra_labels
  end

  def server
    client.cluster.servers.first
  end

  def run(command)
    response = Mongo::Operation::Commands::Command.new(command).execute(server)
    response.documents.first
  end

  def status
    [role, features].flatten.join(" ")
  end

  def features
    my_features = []
    my_features << :hidden if server.description.hidden?
    my_features << :replica if server.replica_set_name
    my_features << :standalone if server.standalone?
    my_features
  end

  def role
    if server.primary?
      :master
    elsif server.secondary?
      :slave
    elsif server.arbiter?
      :arbiter
    elsif server.description.passive?
      :passive
    elsif server.description.other?
      if server.mongos?
        :mongos
      else
        :other
      end
    else
      :unknown
    end
  end
end