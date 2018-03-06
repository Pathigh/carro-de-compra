Rails.application.routes.draw do
 
  devise_for :users

  	resources :products, only: [:index] do
  		resources  :orders, only: :create
 	end

 	resources :orders, only: [:index, :destroy ] do
 		collection do
 			delete 'empty_card'
 		end
 	end

  root 'products#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
