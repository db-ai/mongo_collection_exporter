Rails.application.routes.draw do
  get 'metrics', to: 'stats#metrics'
  root to: 'stats#index'
end
