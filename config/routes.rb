Changelog::Application.routes.draw do
  namespace :changelog do
    resources :pivotal_stories
    resources :versions
  end
  root :to => "changelog/pivotal_stories#index"
end
