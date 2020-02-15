Simpler.application.routes do
  get '/tests', 'tests#index'
  get '/tests/new', 'tests#new'
  get '/tests/:id', 'tests#show'
  post '/tests', 'tests#create'
end
