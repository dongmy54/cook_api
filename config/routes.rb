Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'cooks#search'

  get '/dish' => "cooks#dish"
  get '/search' => "cooks#search"
end
