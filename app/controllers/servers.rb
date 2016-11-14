require 'pp'

MongoCollectionExporter::App.controllers :servers do
  get :index, with: :address do
    @server = Settings.current.mongo.find(params[:address]) || halt(404)

    render 'show'
  end

  get :show, map: '/servers/:address/collections' do
    @server = Settings.current.mongo.find(params[:address]) || halt(404)
    @metrics = @server.namespaces_metrics.first

    render 'collection'
  end
end
