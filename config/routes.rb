Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'api/public' => 'public#public'
  get 'api/private' => 'private#private'
  get 'api/private-scoped' => 'private#private_scoped'
  resources :messages
  # namespace :api, defaults: { format: :json } do
  #   namespace :v1 do
  #     resources :messages
  #   end
  # end
end
