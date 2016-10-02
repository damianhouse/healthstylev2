Rails.application.routes.draw do
  get 'general/welcome'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "general#welcome"

end
