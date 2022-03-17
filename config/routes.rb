Rails.application.routes.draw do
  root to: 'users#new'
  devise_for :users, path: ''
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
