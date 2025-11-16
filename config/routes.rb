Rails.application.routes.draw do
  get "dashboards/show"
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  get "sitemap.xml", to: "sitemaps#index", defaults: { format: :xml }

  # Legal
  get "about",   to: "pages#about"
  get "privacy", to: "pages#privacy"
  get "terms",   to: "pages#terms"
  get "contact", to: "pages#contact"

  # Marketing
  get "features", to: "pages#features"
  get "business", to: "pages#business"
  get "help",     to: "pages#help"


  authenticated :user do
    root "dashboards#show", as: :authenticated_root
  end

  unauthenticated do
    root "pages#home"
  end
end
