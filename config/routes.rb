Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/fin', as: 'rails_admin'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  defaults format: :json do
    resources :bydays
  end  
end
