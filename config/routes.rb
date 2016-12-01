Rails.application.routes.draw do
  resources :notes
  mount ActionCable.server => '/cable'

  resources :conversations
  resources :messages
  resources :conversations, only: [:new, :create, :show, :index]

  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :users
  root to: "general#welcome"

  get 'users/choose_coaches'
  get 'general/welcome'
  get 'general/our_coaches'
  get 'general/testimonials'
  get 'general/recipes'
  get 'general/about_us'
  get 'general/terms'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
