Rails.application.routes.draw do
  root 'index#index'

  # resource :blankets, as: 'temperatureblanket', only: [:index, :new, :create, :show]
  get 'temperature-blanket', to: 'blankets#index', as: :blankets
  get 'temperature-blanket/new', to: 'blankets#new', as: :new_blanket
  post 'temperature-blanket', to: 'blankets#create', as: :create_blanket
  get 'temperature-blanket/:slug', to: 'blankets#show', as: :blanket

end
