module MongoCollectionExporter
  class App < Padrino::Application
    Mongo::Logger.logger.level = Logger::INFO

    disable :reload

    register Padrino::Helpers

    enable :sessions
    layout :mono

    get '/' do
      "Hello World"
    end
  end
end
