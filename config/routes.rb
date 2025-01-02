Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  #トップページ関係。未ログイン時はtops/index、ログイン時はtops/dashboardに遷移する
  root "tops#home"
  get 'dashboard', to: 'tops#dashboard'

  #セッション、ログイン関係
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'log_out', to: 'sessions#destroy', as: 'log_out'

  resources :sessions, only: %i[create destroy]
end
