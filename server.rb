require 'sinatra'
#require 'sinatra/reloader' #remove before deployment
use Rack::Session::Cookie

get '/' do
  if session['secret_word'].nil?
		redirect to('/new')
	end

	erb :index
end

get '/new' do
	session[:secret_word] = new_secret_word
  session[:display_string] =@display_string = ("_  ") * (@secret_word.length)
  session[:secret_word_array] = @secret_word_array = @secret_word.split("")
  session[:attempts] = 10
	session[:string_of_guesses] = ''
	redirect to ('/')
end

post '/try' do
	session[:guess] = params[:guess].downcase
	update_variables
	play
	redirect to('/')
end

get '/lose' do
  erb :lose
end

get '/win' do
  erb :win
end

helpers do
  attr_accessor :guess,:attempts,:secret_word,:string_of_guesses,:display_string,:secret_word_array


  def update_variables
	  @secret_word = session[:secret_word]
	  @display_string = session[:display_string]
	  @string_of_guesses = session[:string_of_guesses]
	  @secret_word_array = session[:secret_word_array]
		@guess = session[:guess]
		@attempts = session[:attempts]
	end



  def play
    if guess.length == 1
      match_character
    else
      match_word
    end
    deduct_guesses
  end


  def deduct_guesses
  	session[:attempts] -= 1
  	@attemtps = session[:attempts]
  	redirect to('/lose') if @attempts <= 1
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
    return @secret_word
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
    end
    you_win if @secret_word_array.all? { |element| element == nil }
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
