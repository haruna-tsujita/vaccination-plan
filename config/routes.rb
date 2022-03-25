Rails.application.routes.draw do
  get 'histories/new'
  get 'histories/index'
  get 'histories/edit'
  get 'histories/show'
  devise_for :users, path: ''
  resources :children
  root 'top#index'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
