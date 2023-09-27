# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             controllers: { registrations: 'users/registrations', passwords: 'users/passwords' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
  root 'welcome#index'

  get 'courses/reload_new' => 'courses#reload_new', :as => :courses_reload_new
  post 'courses/reload' => 'courses#reload', :as => :courses_reload
  get 'users/approval' => 'users#approval', :as => :users_approval
  get 'users/approval_update' => 'users#approval_update', :as => :users_approval_update
  get 'assignments/unassigned_section' => 'assignments#unassigned_section', :as => :assignments_unassigned_section
  resources :users do
    resources :applications do
      resources :student_schedules
    end
    resources :recommendations
    resources :evaluations
  end
  resources :courses do
    resources :sections
  end
  resources :assignments
end
