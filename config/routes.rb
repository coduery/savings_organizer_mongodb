SavingsOrganizer::Application.routes.draw do

  root "users#login" # specifes default web page for application

  get "users/login"
  get "users/registration"
  get "users/welcome"
  get "accounts/create"
  get "categories/create"
  get "entries/add"

  post "users/login"
  post "users/registration"
  post "users/welcome"
  post "accounts/create"
  post "categories/create"
  post "entries/add"

end
