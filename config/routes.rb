Changelog::Application.routes.draw do
  namespace :changelog do
    resources :pivotal_stories
  end
  root :to => "changelog/pivotal_stories#index"
end
