Rails.application.routes.draw do

  root 'static_pages#top'
  get '/signup', to: 'users#new'
  
  get     '/login', to: 'sessions#new'
  post    '/login', to: 'sessions#create'
  delete  '/logout', to: 'sessions#destroy'

# モーダルウインドウ上で「基本勤怠情報を編集する画面」を表示させるget、「基本勤怠情報を更新する」ためのpatch　のためのroutes
  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
    end 
    resources :attendances, only: :update
  end 
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
