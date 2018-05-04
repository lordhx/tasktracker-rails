Rails.application.routes.draw do
  devise_for :users

  resources :issues, except: [:new, :show] do
    resource :assignment, only: [:create, :update, :destroy], module: :issue
  end
end
