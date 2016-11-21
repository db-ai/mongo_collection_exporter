module MongoCollectionExporter
  # Entry point for Padrino app
  class App < Padrino::Application
    Mongo::Logger.logger.level = Logger::INFO

    disable :reload
    enable :sessions
    layout :mono

    get '/' do
      'mongo_collection_exporter metrics are <a href="/metrics">here</a>'
    end

    get '/metrics' do
      content_type 'text/plain;charset=utf8'

      @prometheus = Prometheus.new
      @prometheus.to_s
    end
  end
end
