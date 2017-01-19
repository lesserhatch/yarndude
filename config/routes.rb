Rails.application.routes.draw do
  root 'index#index'

  # resource :blankets, as: 'temperatureblanket', only: [:index, :new, :create, :show]
  get 'temperature-blanket', to: 'blankets#index', as: :blankets
  get 'temperature-blanket/new', to: 'blankets#new', as: :new_blanket
  post 'temperature-blanket/find', to: 'blankets#index', as: :find_blankets
  post 'temperature-blanket', to: 'blankets#create', as: :create_blanket
  get 'temperature-blanket/:slug', to: 'blankets#show', as: :blanket
  post 'temperature-blanket/:slug/pay', to: 'blankets#pay', as: :blanket_pay

  namespace :admin do
    get '/', to: 'logins#new'
    get 'login', to: 'logins#new'
    post 'login', to: 'logins#create'
    get 'logout', to: 'logins#destroy'

    # Blankets resources and additional actions
    resources :blankets do
      member do
        get 'refund'
        get 'restart_job'
        get 'toggle_example'
      end
    end

    # Palettes resources
    resources :palettes do
      resources :temperature_ranges
    end

    # Yarns resources
    resources :yarns
  end

end
