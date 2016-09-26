module Hangman


  class Game
		attr_accessor :attempts,:secret_word,:guess,:string_of_guesses, :display_string, :secret_word_array, :won, :game_over


		def initialize
		  @guess = '' #initialize to '' nil class doesn't have .length
		  @string_of_guesses = ''
	  	@attempts = 10
	  	@secret_word = secret_word
	  	@secret_word_array = @secret_word.split("")
	  	@display_string = ("_  ") * (@secret_word.length)
	  	@game_over = false
	  	@won = false
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
		  if (!@won && attempts == 0)
		  	@game_over = true
		  	you_lose
		  end
		end


		private


		def secret_word
	  	file = "5desk.txt"
	  	suitable = false # suitable if length between 5 and 12 characters
	  	until suitable
	  		word = IO.readlines(file)[rand(61405)].chomp.downcase
	  		if (word.length >=5 && word.length <= 12)
	  			suitable = true
	 			end
	  	end
	  	return word
	  end


		#def guess_so_far
		#   @string_of_guesses[0..-3]  #-2 doesn't display last comma
	  #end


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
		  	"Sorry, try again!"
		  end
		end


		def you_win
			@game_over = true
		  @won = true
		  @attempts = 11
		  play_again
		end


		def you_lose
		  play_again
		end


		def display_winning_combination
		  @secret_word_array = @secret_word.split("")
		  @display_string = @secret_word_array.collect {|character| character + "  "}.join
		end


		def play_again
		  #render end of game
		end
	end

end
