Rails.application.routes.draw do
  apipie
  post 'auth/login', to: 'auth#login'

  resources :clients, only: [:index, :create, :update, :destroy]
  resources :toys, only: [:index, :create, :update, :destroy]
  
  resources :sales, only: [:index, :create, :update, :destroy]
  get 'sales/higher/volume', to: 'sales#get_higher_volume_sale'
  get 'sales/higher/average', to: 'sales#get_highest_average_amount_sale'
  get 'sales/higher/frequency', to: 'sales#get_highest_frequency_sale'

end
