Rails.application.routes.draw do

  get 'sites/new'

    root 'static_pages#top'
    get 'signup', to: 'users#new'
    
    
    # ログイン機能
    get    '/login', to: 'sessions#new'
    post   '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'
    
    # ユーザー表示
    get '/attending_member', to: 'users#attending_member'
    
    resources :users do
      collection { post :csv_import }
      member do
        get 'edit_basic_info'
        patch 'update_basic_info'
        get 'attendances/edit_one_month'
        patch 'attendances/update_one_month'
      end 
      resources :attendances, only: :update
    end 
    resources :sites do
      member do
        get 'edit_site_info'
        patch 'update_site_info'
      end
    end
end
