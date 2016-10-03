Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  get 'general/welcome'
  resources :conversations, only: [:new, :create, :show, :index]
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "general#welcome"
  post 'conversations/:conversation_id' => 'conversations#show'
end
