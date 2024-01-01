Rails.application.routes.draw do
  root 'session#home'

  post '/register', to: 'user#create'
  post '/login', to: 'session#login'
  post '/publish-post', to: 'post#publish'
end
