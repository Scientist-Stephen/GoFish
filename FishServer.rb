require 'socket'
require 'rspec'
require 'json'
require_relative 'FishDeck.rb'
require_relative 'FishHand.rb'
require_relative 'FishGame.rb'
require_relative 'FishPlayers.rb'
require_relative 'FishClient.rb'

class SocketServerClass
	attr_accessor :clients, :fish_game, :card_wanted, :player_asked, :deck	#:fish_game needs an attr_accessor until I re-write a couple of function

	def initialize(port, number_of_players)
		@socket_server = TCPServer.new(port)
		@clients = []
		@player_asked = nil
		@card_wanted = nil
		@fish_game = FishGame.new(number_of_players)
		@deck = FishDeck.new	##UNTESTED--!!--!!--!!--!!--!!--!!--!!--!!--!!
		@fish_game.deal_to_players(@deck)	##UNTESTED--!!--!!--!!--!!--!!--!!--!!--!!--!!
	end

	def close
		@socket_server.close
	end

	def start_game(players)
		@game = FishGame.new(players)
	end

	def exit(game_name)
			game_name.player.each do |player|
			player.socket_number.puts("EXIT")
		end
	end

	def accept_client(game_name = nil)	#(Version for Tests)  #####Revise This so it doesn't need Game Name

		#puts "clients size is: #{@clients.size}"
		clients_size = @clients.size
		client = @socket_server.accept
		#puts "CLIENT: #{client}"
		@clients << client
		#puts "Here is the client we just shoveled on: #{client}"
		game_name.player[clients_size].socket_number = client #Puts client into appropriate player
	end

	def to_client(game_name, client_number, message)
		client_number = client_number.to_i
		game_name.player[client_number].socket_number.puts(message)
	end

	def broadcast_all(game_name, message)

		game_name.player.each do |player|
			player.socket_number.puts("ANNOUNCEMENT")
		end
		sleep(0.5)

		game_name.player.each do |player|
			player.socket_number.puts(message)
		end
	end

	def broadcast_books(game_name)
		game_name.player.each do |player|
		#	puts "player array element: #{game_name.player}"
			puts "player fish_hand: #{game_name.player[0].fish_hand.books_collected}"
		#	puts "player index  #{game_name.player.index(player)}"
			broadcast_all(game_name, "Player #{game_name.player.index(player) + 1} has #{player.fish_hand.books_collected} books!")
		end
	end

	def receive_input(game_name, player_from)
		incoming = game_name.player[player_from].socket_number.gets.chomp
	end

	def receive_input_json(game_name, player_from)	#Need to test this one still--!!--!!--!!--!!--!!--!!--!!--!!--!!
		incoming = game_name.player[player_from].socket_number.gets.chomp
		incoming = JSON.parse(incoming)
		return incoming
	end
	
	def parser(to_be_parsed)
	@player_asked = to_be_parsed.shift
	@card_wanted = to_be_parsed.shift
	end

	def update_client_cards(game_name)	#Allows client to check input

		game_name.player.each do |player|
			player.socket_number.puts("CARDS")
		end
		sleep(0.5)

		game_name.player.each do |player|
			
			#puts "Player cards:"
			#p player.fish_hand.player_cards
			#p player.fish_hand.player_cards.to_json
		#	puts "player n's cards: #{player.fish_hand.player_cards}"
			cards_for_client = player.fish_hand.player_cards.to_json
		#	puts "CARDS FOR CLIENT p"
		#	p cards_for_client
			player.socket_number.puts(cards_for_client)	#JSON DATA
		#	puts "WHICH PLAYER IS THIIIIIIIIIS: #{player}"
		end	
	end

	def players_available_to_clients(game_name)
		

		game_name.player.each do |player|
			player.socket_number.puts("PLAYERS")
		end
		sleep(0.5)

		game_name.player.each do |player|
			
			number_of_players = game_name.player.count.to_json
			player.socket_number.puts(number_of_players)	#JSON DATA
		end	

	end
end
