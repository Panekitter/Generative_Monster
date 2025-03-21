Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  #トップページ関係。未ログイン時はtops/index、ログイン時はtops/dashboardに遷移する
  root "tops#home"
  get 'dashboard', to: 'tops#dashboard'

  # 利用規約とプライバシーポリシー
  get 'terms_of_service', to: 'tops#terms_of_service'
  get 'privacy_policy', to: 'tops#privacy_policy'

  #セッション、ログイン関係
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'log_out', to: 'sessions#destroy', as: 'log_out'
  resources :sessions, only: %i[create destroy]

  #検索機能
  get "search", to: "search#index"

  # ユーザー関連
  resources :users, only: [:index, :show, :edit, :update] do
    # バトル関連（戦闘履歴）
    resources :battles, only: [:index]
    # キャラクター関連
    resources :characters, only: [:index, :new]
  end

  # キャラクター単独操作
  resources :characters, only: [:new, :create, :show, :update, :destroy] do
    member do
      get :og_image
      get :og_image_page
    end
  end

  # バトル関連（独立したバトル操作）
  resources :battles, only: [:new, :create, :show] do
    member do
      get :og_image
      get :og_image_page
    end
  end
end
