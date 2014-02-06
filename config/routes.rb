SavingsOrganizer::Application.routes.draw do

  root "users#login" # specifes default web page for application

  get "users/login"
  get "users/registration"
  get "users/welcome"

  post "users/login"
  post "users/registration"

end
