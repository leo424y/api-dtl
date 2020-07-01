Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/fin', as: 'rails_admin'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  defaults format: :json do
    resources :pablo
    resources :crowdtangle
    resources :cofact
    resources :bydays
    resources :fblinks
    resources :claim
    resources :wikipedia
  end  
  resources :hub
  get :hub_wikipedia, controller: :hub
  get :hub_claim, controller: :hub
  get :hub_cofact, controller: :hub
  get :hub_crowdtangle, controller: :hub
  get :hub_pablo, controller: :hub
  get :hub_fblink, controller: :hub
end
