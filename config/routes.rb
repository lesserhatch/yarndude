Rails.application.routes.draw do
  root 'index#index'

  # resource :blankets, as: 'temperatureblanket', only: [:index, :new, :create, :show]
  get 'temperature-blanket', to: 'blankets#index', as: :blankets
  get 'temperature-blanket/new', to: 'blankets#new', as: :new_blanket
  post 'temperature-blanket', to: 'blankets#create', as: :create_blanket
  get 'temperature-blanket/:slug', to: 'blankets#show', as: :blanket
  get 'temperature-blanket/:slug/checkout', to: 'blankets#checkout', as: :blanket_checkout
  post 'temperature-blanket/:slug/pay', to: 'blankets#pay', as: :blanket_pay

  namespace :admin do
    get 'login', to: 'logins#new'
    post 'login', to: 'logins#create'
    get 'logout', to: 'logins#destroy'
    resources :blankets
  end

end
