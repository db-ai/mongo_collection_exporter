module MongoCollectionExporter
  class App < Padrino::Application
    Mongo::Logger.logger.level = Logger::INFO

    disable :reload

    register Padrino::Helpers

    enable :sessions
    layout :mono

    get '/' do
      'mongo_collection_exporter metrics are <a href="/metrics">here</a>'
    end
  end
end
