Changelog::Application.routes.draw do
  namespace :changelog do
    get :release_notes
    get :current_release
    resources :pivotal_stories
    resources :versions
  end
  root :to => "changelog/pivotal_stories#index"
end
