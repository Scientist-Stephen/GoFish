require 'socket'
require 'rspec'
require 'json'
require_relative 'FishDeck.rb'
require_relative 'FishHand.rb'
require_relative 'FishGame.rb'
require_relative 'FishPlayers.rb'
require_relative 'FishServer.rb'



class ClientClass

	attr_accessor :players_available, :card_choices_available, :socket

	def initialize(host, port)

		@socket = TCPSocket.new(host, port)
		@players_available = nil
		@card_choices_available = nil
	end

	def get_input
		incoming = @socket.gets.chomp
		#puts "Here is the output for incoming: #{incoming}"
	end

	def send_input(message)
		outgoing = @socket.puts(message)
	end

	def close
		@socket.close
	end



	def is_valid_player_query(player_queried)

		player_queried = player_queried.to_i
		puts "PLAYER QUERIED:"
		p player_queried
		puts "players available: #{@players_available}"

		if (player_queried > @players_available) || (player_queried < 1)

			puts "I'm sorry, that's not a player."
			puts "Please enter a player number ranging from 1 through #{players_available}"
			user_input = gets.chomp
			is_valid_player_query(user_input)	#Recursion until proper response
		else
			player_queried = player_queried - 1 #because client 1 is @server.fish_game.player[0]
			puts "again, here's player_queried #{player_queried}"
			return player_queried
		end

	end

	def is_valid_card_query(card_queried)
		puts "CARD QUERIED: #{card_queried}"
		cards_available = %w(2 3 4 5 6 7 8 9 10 J Q K A)
		#puts "CARDS AVAILABLE: #{cards_available}"
		card_queried = card_queried.upcase	###--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--

		if (cards_available.include? card_queried) == false
		#	puts "CARD NOT AVAILABLE EVER"
		#	puts "True if statement? #{cards_available.include? "card_queried"}"

			puts "I'm sorry, that's not a valid card choice."
			puts "Please enter a card number ranging from 2 through A.  You're using a traditional deck"
			user_input = gets.chomp
			user_input = user_input.upcase	###--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--
			user_input = is_valid_card_query(user_input)	#Recursion until proper response

		elsif (((cards_available.include? card_queried) == true) && ((card_choices_available.include? card_queried) == false))
		#	puts "CARD IN DECK BUT NOT HAND"
		#	puts "True if statement? #{cards_available.include? "card_queried"}"

			puts "I'm sorry, you don't have that card, so you can't ask for it."
			puts "Here are the cards for which you may ask: #{card_choices_available}"
			user_input = gets.chomp
			user_input = user_input.upcase	###--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--
			user_input = is_valid_card_query(user_input)

		else
			puts "True if statement? #{cards_available.include? "card_queried"}"
			puts "PASS!"
			return card_queried
		end
	end

	def input_decision(input)
		puts "In input decision!"
		if input == "PLAYERS"
			
			input = @socket.gets.chomp	#gets the actual array
			input = input.to_i
			@players_available = input
			
		elsif input == "CARDS"

			input = @socket.gets.chomp
			input = JSON.parse(input)
			@card_choices_available = input
			puts "CARD CHOICES AVAILABLE: #{card_choices_available}"

		elsif input == "EXIT"
			puts "The server has closed.  Goodbye!"
			#I need some way to break the loop or close the client if the server has closed

		elsif input == "ANNOUNCEMENT"	#just reads it

			input = @socket.gets.chomp
			puts input

		else	#get input from user case
			user_choice = []
			puts "It is your turn.  Please choose a player to ask for a card"
			user_input = gets.chomp
			user_input = is_valid_player_query(user_input)
			user_choice << user_input
			
			puts "Great!  You're asking Player #{user_input + 1} for a card.  What card would you like?"
			user_input = gets.chomp
			user_input = user_input.upcase	###--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--
			user_input = is_valid_card_query(user_input)
			user_choice << user_input

			user_choice = user_choice.to_json
			send_input(user_choice)	#Don't need @server.send_input(...) because it's in the class

			#puts "user_choice:"
			#p user_choice
		end
	end
end




describe ClientClass do 

	before do
		@server = SocketServerClass.new(2012, 3)
		@client1 = ClientClass.new('localhost', 2012)
		@client2 = ClientClass.new('localhost', 2012)
		@client3 = ClientClass.new('localhost', 2012)
		@server.accept_client(@server.fish_game)
		@server.accept_client(@server.fish_game)
		@server.accept_client(@server.fish_game)

	end

	after do
		@server.close
		@client1.close
		@client2.close
		@client3.close
	end


	it "reads from the server" do
		@server.broadcast_all(@server.fish_game, "Hello world!")
		msg1 = @client1.get_input
		msg3 = @client3.get_input

		expect(msg1).to eq("Hello world!")
		expect(msg3).to eq("Hello world!")
	end

	it "sends input to server" do

		@client1.send_input("Hello server!")
		@client3.send_input("Hello server!")

		msg1 = @server.receive_input(@server.fish_game, 0)
		msg3 = @server.receive_input(@server.fish_game, 2)

		expect(msg1).to eq("Hello server!")
		expect(msg3).to eq("Hello server!")
	end

	it "only allows players available to be asked" do

		
	end

	it "only allows player to ask for cards of rank in his hand" do


	end	

	


end
