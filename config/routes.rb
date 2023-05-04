Rails.application.routes.draw do
  get 'wiki_stats', to: 'wiki_stats#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      resources :articles, only: [], param: :title do
        collection do
          get :most_viewed_in_a_month
          get :most_viewed_in_a_week
        end
        
        member do
          get :week_views
          get :month_views
          get :top_viewed_day_in_a_month
        end
      end
    end
  end
end
