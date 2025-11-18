Rails.application.routes.draw do
  get "dashboards/show"

  devise_for :users

  resource :profile,
          only: [ :show, :update, :destroy ],
          controller: "profiles" do
    post :update_password
  end

  get "up" => "rails/health#show", as: :rails_health_check

  get "sitemap.xml", to: "sitemaps#index", defaults: { format: :xml }

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Legal
  get "about",   to: "pages#about"
  get "privacy", to: "pages#privacy"
  get "terms",   to: "pages#terms"
  get "contact", to: "pages#contact"

  # Marketing
  get "features", to: "pages#features"
  get "business", to: "pages#business"
  get "help",     to: "pages#help"

  # Admin pages
  namespace :admin do
    root "dashboard#index"

    resources :cities do
      resources :locations
    end
    resources :matches

    resources :users do
      member do
        patch :toggle_admin
      end
    end
  end

  authenticated :user do
    root "dashboards#show", as: :authenticated_root
  end

  unauthenticated do
    root "pages#home"
  end
end
