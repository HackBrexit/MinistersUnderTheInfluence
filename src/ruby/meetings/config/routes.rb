Rails.application.routes.draw do

  resources :means_of_influences
  resources :entities
  Entity.types.each do |pi_type|
    resources (pi_type.underscore.downcase.pluralize.to_sym),controller: 'entities',type: pi_type
    namespace :api do
      namespace :v1 do
        jsonapi_resources (pi_type.underscore.downcase.pluralize.to_sym)
        resources :apidocs, only:[:index]
        resources :docs, only:[:index]
      end
    end
  end
  MeansOfInfluence.types.each do |pi_type|
    resources (pi_type.underscore.downcase.pluralize.to_sym),controller: 'means_of_influences',type: pi_type
    namespace :api do
      namespace :v1 do
        jsonapi_resources (pi_type.underscore.downcase.pluralize.to_sym)
      end
    end
  end
  get '/swagger-docs' => redirect('/swagger/dist/index.html?url=/api/v1/apidocs')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'main#index'
end
