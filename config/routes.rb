Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  post "/", to: "hoopbot#create"
  get "/out/this/:type/:slack_username", to: "summary#show"
end
