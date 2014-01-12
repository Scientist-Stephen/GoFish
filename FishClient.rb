require 'socket'
require 'rspec'
require 'json'
require_relative 'FishDeck.rb'
require_relative 'FishHand.rb'
require_relative 'FishGame.rb'
require_relative 'FishPlayers.rb'
require_relative 'FishServer.rb'



class ClientClass

	attr_accessor :players_available, :card_choices_available, :socket, :server_closed

	def initialize(host, port)

		@socket = TCPSocket.new(host, port)
		@players_available = nil
		@card_choices_available = nil
		@server_closed = false
	end

	def get_input
		incoming = @socket.gets.chomp
	end

	def send_input(message)
		outgoing = @socket.puts(message)
	end

	def close
		@socket.close
	end



	def is_valid_player_query(player_queried)

		player_queried = player_queried.to_i

		if (player_queried > @players_available) || (player_queried < 1)

			puts "I'm sorry, that's not a player."
			puts "Please enter a player number ranging from 1 through #{players_available}"
			user_input = gets.chomp
			is_valid_player_query(user_input)	#Recursion until proper response
		else
			player_queried = player_queried - 1 #because client 1 is @server.fish_game.player[0]
			return player_queried
		end

	end

	def is_valid_card_query(card_queried)
		puts "CARD QUERIED: #{card_queried}"
		cards_available = %w(2 3 4 5 6 7 8 9 10 J Q K A)
		
		card_queried = card_queried.upcase

		if (cards_available.include? card_queried) == false
		

			puts "I'm sorry, that's not a valid card choice."
			puts "Please enter a card number ranging from 2 through A.  You're using a traditional deck"
			user_input = gets.chomp
			user_input = user_input.upcase	
			user_input = is_valid_card_query(user_input)	#Recursion until proper response

		elsif (((cards_available.include? card_queried) == true) && ((card_choices_available.include? card_queried) == false))
		
			puts "I'm sorry, you don't have that card, so you can't ask for it."
			puts "Here are the cards for which you may ask: #{card_choices_available}"
			user_input = gets.chomp
			user_input = user_input.upcase	
			user_input = is_valid_card_query(user_input)

		else
		
			return card_queried
		end
	end

	def input_decision(input)

		if input == "PLAYERS"

		
			input = @socket.gets.chomp	#gets the actual array
			input = input.to_i
			@players_available = input
		
		elsif input == "CARDS"
		

			input = @socket.gets.chomp
		
			input = JSON.parse(input)
			@card_choices_available = input
			puts "The cards you have in your hand are: #{@card_choices_available}"
			

		elsif input == "EXIT"
	
			puts "The server has closed.  I hope you had a fun game!  Goodbye!"
			@server_closed = true
		elsif input == "ANNOUNCEMENT"	#just reads it

			input = @socket.gets.chomp
			puts input

		else	#get input from user case
			puts "in \"TURNS\" else"

			user_choice = []
			puts "It is your turn.  Please choose a player to ask for a card"
			user_input = gets.chomp
			user_input = is_valid_player_query(user_input)
			user_choice << user_input
			
			puts "Great!  You're asking Player #{user_input + 1} for a card.  What card would you like?"
			user_input = gets.chomp
			user_input = user_input.upcase	
			user_input = is_valid_card_query(user_input)
			user_choice << user_input

			user_choice = user_choice.to_json
			send_input(user_choice)	
		end
	end
end
