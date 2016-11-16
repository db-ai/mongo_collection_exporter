MongoCollectionExporter::App.controllers :metrics do
  get :index do
    content_type 'text/plain;charset=utf8'

    @prometheus = Prometheus.new
    @prometheus.to_s
  end
end
