MongoCollectionExporter::App.controllers :config do
  get :index do
    @config = Settings.current
    render 'index'
  end
end
