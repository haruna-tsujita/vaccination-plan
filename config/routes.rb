Rails.application.routes.draw do
  get 'children/index'
  get 'children/show'
  get 'children/new'
  get 'children/edit'
  root 'top#index'
  devise_for :users, path: ''
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
