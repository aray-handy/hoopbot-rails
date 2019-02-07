Rails.application.routes.draw do
  get "/out/this/:type/(:slack_username)", to: "summary#show"
  post "/", to: "hoop_dialog#create"
  post "/callback", to: "callback#create"
end
