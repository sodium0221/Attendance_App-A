Rails.application.routes.draw do

  get 'sites/new'

    root 'static_pages#top'
    get 'signup', to: 'users#new'
    
    
    # ログイン機能
    get    '/login', to: 'sessions#new'
    post   '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'
    
    # 上長画面1ヶ月分勤怠お知らせフォーム
    get '/approval_alert', to: 'attendances#approval_alert'
    post '/approval_alert', to: 'attendances#approval_alert'
    
    # 1ヶ月分の申請
    patch '/approval_alert', to: 'attendances#approval_alert'
    
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
      resources :attendances do
        member do
          get 'edit_overtime_motion'
          patch 'update_overtime_motion'
        end
      end
    end 
    resources :sites do
      member do
        get 'edit_site_info'
        patch 'update_site_info'
      end
    end
end
