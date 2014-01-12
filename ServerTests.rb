require 'socket'
require 'rspec'
require 'json'
require_relative 'FishDeck.rb'
require_relative 'FishHand.rb'
require_relative 'FishGame.rb'
require_relative 'FishPlayers.rb'

class SocketServerClass
	attr_accessor :clients, :fish_game	#:fish_game needs an attr_accessor until I re-write a couple of function

	def initialize(port, number_of_players)
		@socket_server = TCPServer.new(port)
		@clients = []
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

	def accept_client(game_name = nil)	#(Version for Tests)  #####Revise This so it doesn't need Game Name

		#puts "clients size is: #{@clients.size}"
		clients_size = @clients.size
		client = @socket_server.accept
		@clients << client
		#puts "Here is the client we just shoveled on: #{client}"
		game_name.player[clients_size].socket_number = client #Puts client into appropriate player
	end

	def broadcast_all(game_name, message)

		game_name.player.each do |player|
			player.socket_number.puts(message)
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


	def update_client_cards(game_name)	#Allows client to check input

		game_name.player.each do |player|
			player.socket_number.puts("CARDS")
		end
		sleep(0.5)

		game_name.player.each do |player|
			
			#puts "Player cards:"
			#p player.fish_hand.player_cards
			#p player.fish_hand.player_cards.to_json
		
			cards_for_client = player.fish_hand.player_cards.to_json
			player.socket_number.puts(cards_for_client)	#JSON DATA
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


class MockClientClass

	def initialize(host, port)
		@socket = TCPSocket.new(host, port)
	end

	def get_input
		incoming = @socket.gets.chomp
		#puts "Here is the output for incoming: #{incoming}"
	end

	def get_input_nonblock
		incoming = @socket.read_nonblock(1000).chomp
		#puts "Here is the output for incoming: #{incoming}"
	end

	def send_input(message)
		outgoing = @socket.puts(message)
	end

end


describe SocketServerClass do 

	before do
		@server = SocketServerClass.new(2012, 3)
	end

	after do
		@server.close
	end


	it "exists" do
		#how to test if @server is a class
	end

	it "exists and listens on port 2012 when started" do
		expect{TCPSocket.new('localhost', 2012)}.to_not raise_error
	end

	it "initializes a game of n players (2 in this case)" do
		fish_game = FishGame.new(2)	#Has player 0 & player 1
		fish_game.player[0].should_not eq(nil)
		fish_game.player[1].should_not eq(nil)
		fish_game.player[2].should eq(nil)
	end

		it "initializes a game of n players (3 in this case)" do
		fish_game = FishGame.new(3)	#Has player 0 & player 1
		fish_game.player[0].should_not eq(nil)
		fish_game.player[1].should_not eq(nil)
		fish_game.player[2].should_not eq(nil)
		fish_game.player[3].should eq(nil)
	end

	it "accepts clients & stores them in clients array" do
		fish_game = FishGame.new(2)
		mock_client1 = MockClientClass.new('localhost', 2012)
		mock_client2 = MockClientClass.new('localhost', 2012)

		@server.accept_client(fish_game)
		@server.accept_client(fish_game)

		@server.clients[0].should_not eq(nil)
		@server.clients[1].should_not eq(nil)
		@server.clients[2].should eq(nil)
	end

	it "accepts clients and stores in the appropriate player class" do
	#puts "HERE is the TEST you're LOOKING FOR"

		fish_game = FishGame.new(3)
		mock_client1 = MockClientClass.new('localhost', 2012)
		mock_client2 = MockClientClass.new('localhost', 2012)
		mock_client3 = MockClientClass.new('localhost', 2012)
		@server.accept_client(fish_game)
		@server.accept_client(fish_game)
		@server.accept_client(fish_game)

		fish_game.player[0].socket_number.should_not eq(nil)
		fish_game.player[1].socket_number.should_not eq(nil)
		fish_game.player[2].socket_number.should_not eq(nil)

	#	puts "socket_number for player 0: #{fish_game.player[0].socket_number}"
	#	puts "socket_number for player 1: #{fish_game.player[1].socket_number}"
	#	puts "socket_number for player 2: #{fish_game.player[2].socket_number}"
	end

	context "Testing Outputs and Inputs" do

		it "Broadcasts to all players" do
			fish_game = FishGame.new(3)
			mock_client1 = MockClientClass.new('localhost', 2012)
			mock_client2 = MockClientClass.new('localhost', 2012)
			mock_client3 = MockClientClass.new('localhost', 2012)
			@server.accept_client(fish_game)
			@server.accept_client(fish_game)
			@server.accept_client(fish_game)	
		
			@server.broadcast_all(fish_game, "I eatz u.")

			
			msg1 = mock_client1.get_input
			msg2 = mock_client2.get_input
			msg3 = mock_client3.get_input
		end

		it "receives input from clients" do

			fish_game = FishGame.new(3)
			mock_client1 = MockClientClass.new('localhost', 2012)
			mock_client2 = MockClientClass.new('localhost', 2012)
			mock_client3 = MockClientClass.new('localhost', 2012)
			@server.accept_client(fish_game)
			@server.accept_client(fish_game)
			@server.accept_client(fish_game)	

			mock_client1.send_input("This is from client 1!")
			mock_client2.send_input("Whereas this is from client 2!")
			mock_client3.send_input("And still yet, this is from client 3!")

			from_mc1 = @server.receive_input(fish_game, 0)
			from_mc2 = @server.receive_input(fish_game, 1)
			from_mc3 = @server.receive_input(fish_game, 2)
			
			expect(from_mc1).to eq("This is from client 1!")
			expect(from_mc2).to eq("Whereas this is from client 2!")
			expect(from_mc3).to eq("And still yet, this is from client 3!")
		end


		it "sends cards as JSON data" do

			fish_game = FishGame.new(3)
			deck = FishDeck.new
			fish_game.deal_to_players(deck)
			mock_client1 = MockClientClass.new('localhost', 2012)
			mock_client2 = MockClientClass.new('localhost', 2012)
			mock_client3 = MockClientClass.new('localhost', 2012)
			@server.accept_client(fish_game)
			@server.accept_client(fish_game)
			@server.accept_client(fish_game)

			#puts "HERE IS THE ACTUAL ARRAY OF CARDS for 0: #{fish_game.player[0].fish_hand.player_cards}"

			@server.update_client_cards(fish_game)	

			msg1 = mock_client1.get_input
			msg2 = mock_client2.get_input
			msg3 = mock_client3.get_input

			#puts "msg 1: #{msg1}"
			#puts "msg 2: #{msg2}"
			#puts "msg 3: #{msg3}"

			msg1a = mock_client1.get_input
			msg2a = mock_client2.get_input
			msg3a = mock_client3.get_input

			#You can un-pound these and see the json output.
			#puts "msg 1a"
			#p msg1a
			#puts "msg 2a"
			#p msg2a
			#puts "msg 3a"
			#p msg3a
		end

		it "sends number of clients available to client" do

			fish_game = FishGame.new(3)
			deck = FishDeck.new
			fish_game.deal_to_players(deck)
			mock_client1 = MockClientClass.new('localhost', 2012)
			mock_client2 = MockClientClass.new('localhost', 2012)
			mock_client3 = MockClientClass.new('localhost', 2012)
			@server.accept_client(fish_game)
			@server.accept_client(fish_game)
			@server.accept_client(fish_game)

			@server.players_available_to_clients(fish_game)

			msg1 = mock_client1.get_input
			msg2 = mock_client2.get_input
			msg3 = mock_client3.get_input

			#puts "msg 1: #{msg1}"
			#puts "msg 2: #{msg2}"
			#puts "msg 3: #{msg3}"

			msg1a = mock_client1.get_input
			msg2a = mock_client2.get_input
			msg3a = mock_client3.get_input

			expect(msg1a).to eq("3")
			expect(msg2a).to eq("3")
			expect(msg3a).to eq("3")


		end
	end
end