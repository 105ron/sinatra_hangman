require 'sinatra'
require 'sinatra/reloader' #remove before deployment
#require_relative 'game'
enable :sessions

get '/' do
  "value = " << session[:value => "inputs"]
  inputs
end