module MongoCollectionExporter
  class App < Padrino::Application
    enable  :reload

    register Padrino::Helpers

    enable :sessions
    layout :mono

    get '/' do
      "Hello World"
    end
  end
end
