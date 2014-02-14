SavingsOrganizer::Application.routes.draw do

  root "users#login" # specifes default web page for application

  get "users/login"
  get "users/registration"
  get "users/welcome"
  get "accounts/create"
  get "categories/create"

  post "users/login"
  post "users/registration"
  post "accounts/create"
  post "categories/create"

end
