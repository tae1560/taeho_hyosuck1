Hyosuck1::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users

  root :to => "services#home"

  match 'statistics', to: 'services#statistics', :via => :all
  match 'management', to: 'services#management', :via => :all
  match 'authenticate', to: 'services#authenticate', :via => :all
  match 'scan', to: 'services#scan', :via => :all
  match 'processing', to: 'services#processing', :via => :all
  match 'result/:id', to: 'services#result', :via => :all
  match 'result_print/:id', to: 'services#result_print', :via => :all
  match 'api', to: 'services#api', :via => :all
end