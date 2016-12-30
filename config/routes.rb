Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  mount StripeEvent::Engine => "/#{ENV["MHSWEBHOOK"]}"

  root to: "general#welcome"
  
  resources :notes
  resources :conversations
  resources :messages
  resources :conversations, only: [:new, :create, :show, :index]
  resources :form_steps

  devise_for :users, controllers: { registrations: "registrations" }

  scope '/admin' do
    resources :users
  end

  get 'subscriptions/new'
  get 'subscriptions/create'
  post 'subscriptions/create'
  get 'users/choose_coaches' => 'users#choose_coaches'
  get 'general/welcome'
  get 'general/our_coaches'
  get 'general/testimonials'
  get 'general/recipes'
  get 'general/about_us'
  get 'general/terms'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
