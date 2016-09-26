require 'sinatra'
require 'sinatra/reloader' #remove before deployment
use Rack::Session::Cookie

get '/' do
  if session['secret_word'].nil?
		redirect to('/new')
	end
end

get '/new' do
  
  new_secret_word
  #redirect to('/')
  erb :index, :locals => {:secret_word => @secret_word, :display_string => @display_string, :attempts => @attempts}
end

post '/' do
	session[:guess] = params[:guess].downcase
	guess(session[:guess])
	erb :index, :locals => {:secret_word => @secret_word, :display_string => @display_string, :attempts => @attempts}
end

get '/lose' do

end

get '/win' do

end

helpers do
  attr_accessor :guess,:attempts,:secret_word,:string_of_guesses,:display_string,:secret_word_array


  def guess(input)
    @guess = input
    play
  end

  def play
    if guess.length == 1
      valid = true
      match_character
    elsif guess.length >= 5
      valid = true
      match_word
    else
      return #No input, don't run the game.
    end
    @attempts -= 1
    if attempts == 0
      redirect to('/lose')
    end
  end


  def new_secret_word
    file = "5desk.txt"
    suitable = false # suitable if length between 5 and 12 characters
    until suitable
      @secret_word = IO.readlines(file)[rand(61405)].chomp.downcase
      if (@secret_word.length >=5 && @secret_word.length <= 12)
        suitable = true
      end
    end
    @display_string = ("_  ") * (@secret_word.length)
    @secret_word_array = @secret_word.split("")
    @attempts = 10
  end


  def match_character
    if @secret_word_array.include?(@guess)
      update_game_state
    else
      @string_of_guesses << "#{@guess}, "
    end
  end


  def update_game_state
    while @secret_word_array.include?(@guess)
      position = @secret_word_array.find_index(@guess)
      @secret_word_array[position] = nil # go through and find and replace with nil all characters that match the guess
      @display_string[(position * 3)] = @guess
      you_win if @secret_word_array.all? { |element| element == nil }
    end
  end


  def match_word
    if @guess == @secret_word
      you_win
    else
      redirect to('/')
    end
  end

  def you_win
    redirect to('/win')
  end

end