require_relative '../metric/mongos'

class Server
  class Mongos < Server
    def fetch_metrics
      [Metric::Mongos.new(raw_metrics, labels)]
    end

    def raw_metrics
      run(selector: { serverStatus: 1 }, db_name: 'admin')
    end
  end
end
