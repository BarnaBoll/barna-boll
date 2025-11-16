Rails.application.routes.draw do
  constraints(host: "www.barnaboll.se") do
    match "/(*path)", to: redirect { |_params, req|
      "https://barnaboll.se#{req.fullpath}"
    }, via: :all
  end

  get "up" => "rails/health#show", as: :rails_health_check

  get "sitemap.xml", to: "sitemaps#index", defaults: { format: :xml }

  root "pages#home"

  # Legal
  get "about",   to: "pages#about"
  get "privacy", to: "pages#privacy"
  get "terms",   to: "pages#terms"
  get "contact", to: "pages#contact"

  # Marketing
  get "features", to: "pages#features"
  get "business", to: "pages#business"
  get "help",     to: "pages#help"
end
