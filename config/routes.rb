Rails.application.routes.draw do
  devise_for :users, path: ''
  resources :families, only: [:index]
  resources :settings, only: [:index]
  resources :children do
    resources :histories
    resources :schedules, only: [:index]
  end
  root 'top#index'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
