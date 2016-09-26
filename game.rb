module Hangman


  class Game
		attr_accessor :attempts,:secret_word,:guess,:string_of_guesses, :display_string, :secret_word_array, :won


		def initialize
		  @string_of_guesses = ''
	  	  @attempts = 0
	  	  @secret_word = secret_word
	  	  @secret_word_array = @secret_word.split("")
	  	  @display_string = ("_  ") * (@secret_word.length)
	  	  @won = false
		end


		def play
		  puts @display_string
		  while @attempts < 10
		    if get_user_input == "check_character"
		      match_character
		    else
		  	  match_word
		    end
		    display_game_status unless @won
		    @attempts += 1
		    end
		  you_lose if !@won
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

		def display_game_status
	  	  puts @display_string 
	  	  guess_so_far unless string_of_guesses == ''
	  	  puts "You've got #{9 - @attempts} guesses left"
		end


		def get_user_input
		  valid = false
		  puts "Please character would like to guess, or type save to save and quit:"
		  until valid
			  @guess = gets.downcase.chomp
			  if guess.length == 1
			  	valid = true
			  	return_selection = "check_character"
			  elsif guess.length >= 5
			  	valid = true
			  	return_selection = "check_word"
			  elsif guess == "save"
			  	save
			  else
			  	puts "Sorry, please enter one character of the word you would like to guess"
			  end
		  end
		  return_selection
		end


		def guess_so_far
		  puts "You're guesses so far have been..." unless string_of_guesses == ''
	  	  puts @string_of_guesses[0..-3]  #-2 doesn't display last comma
	  	end


		def match_character
		  if @secret_word_array.include?(@guess)
		  	update_game_state
		  else
		  	@string_of_guesses << "#{@guess}, "
		  	puts "Sorry, That's not in the secret word. Guess again."
		  end
		end


		def update_game_state
		  while @secret_word_array.include?(@guess)
		  	position = @secret_word_array.find_index(@guess)
		  	@secret_word_array[position] = nil
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
		  @won = true
		  @attempts = 11
		  display_winning_combination
		  puts "Congratulations, You win!"
		  play_again
		end


		def you_lose
		  puts "Sorry you lost! We were looking for..."
		  display_winning_combination
		  play_again
		end


		def display_winning_combination
		  @secret_word_array = @secret_word.split("")
		  @display_string = @secret_word_array.collect {|character| character + "  "}.join
		  puts @display_string
		end


		def play_again
		  puts "would you like to play again? (y/n)"
		  again = gets.chomp.downcase
		  if again == "y"
		    hangman = Game.new
		    hangman.play
		  else
		  	hangman = Game.new
		    hangman.play
			end	     
		end
	end

end
Hangman::Game.new.play