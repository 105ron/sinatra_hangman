require 'sinatra'
require 'sinatra/reloader' #remove before deployment
require_relative 'game'
get '/' do
	#to_cypher,shift = params["encrypt"],params["shift"]
	#to_cypher,shift = check_input(to_cypher,shift)
	#response = CaesarCipher.encrypt(to_cypher, shift)
  #erb :index, :locals => {:response => response}
end