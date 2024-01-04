Rails.application.routes.draw do
  root 'session#home'

  post '/register', to: 'user#create'
  post '/login', to: 'session#login'
  post '/publish-post', to: 'post#publish'
  post '/delete-post', to: 'post#delete'
  post '/like-post', to: 'post#like'
  post '/unlike-post', to: 'post#unlike'
  post '/publish-comment', to: 'comment#publish'

  get '/all-posts', to: 'post#list'
  get '/all-comments', to: 'comment#list'
  
end
