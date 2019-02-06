Rails.application.routes.draw do
  get "/out/this/:type/(:slack_username)", to: "summary#show"
  post "/add", to: "add#create"
  post "/submit", to: "submit#create"
  post "/events", to: "events#create"
  post "/approve", to: "approve#create"
end
