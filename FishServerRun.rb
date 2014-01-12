
require 'socket'
require 'rspec'
require 'json'
require_relative 'FishDeck.rb'
require_relative 'FishHand.rb'
require_relative 'FishGame.rb'
require_relative 'FishPlayers.rb'
require_relative 'FishServer.rb'
require_relative 'FishClient.rb'

puts "Welcome.  You're about to start a game of GoFish."
puts "First, please tell me the number of players that will attend this game.  The least you can have is 2, and the most is 6:"
number_of_players = gets.chomp
number_of_players = number_of_players.to_i
valid_player = false

while valid_player == false
	if number_of_players >= 2 && number_of_players <= 6
		puts "Great!  The game will begin as soon as #{number_of_players} players connect!"
		valid_player = true
	else
		puts "Sorry!  That's not a valid amount of players.  Enter a single number 2 - 6"
		number_of_players = gets.chomp
		number_of_players = number_of_players.to_i
	end
end


server = SocketServerClass.new(2012, number_of_players)

number_of_players.times do 
	server.accept_client(server.fish_game)
end

puts "Clients accepted"
server.players_available_to_clients(server.fish_game)
game_over = false
whos_turn = 0
server.broadcast_all(server.fish_game, "Welcome to go fish.  The game has started with #{number_of_players} players!")

while game_over == false

	server.deck.all_cards = []






	whos_turn = server.fish_game.turn
	server.update_client_cards(server.fish_game)
	server.broadcast_all(server.fish_game, "It is player #{whos_turn + 1}'s turn.")

	server.fish_game.player[whos_turn].socket_number.puts("TURN")			#Give appropriate client the turn
	from_client = server.receive_input_json(server.fish_game, whos_turn)	#Get client response	
	server.parser(from_client)												#parse Response
	server.fish_game.player_to_player(server.deck, server.card_wanted, server.fish_game.player[server.player_asked], server.fish_game.player[whos_turn])
	# ^ Take a turn
	server.broadcast_all(server.fish_game, server.fish_game.player_to_player_result) #broadcasts result of player to player
	server.broadcast_books(server.fish_game)

	game_over = server.fish_game.game_won?(server.deck, server.fish_game)
end
sleep(2)

server.broadcast_all(server.fish_game, server.fish_game.winner_message)

server.exit(server.fish_game)
server.close


=begin
	server.fish_game.player[0].fish_hand.player_cards = %w(2 4 6 8 A)
	server.fish_game.player[1].fish_hand.player_cards = %w(3 6 9 J A)

	server.fish_game.player[0].fish_hand.books_collected = 2
	server.fish_game.player[1].fish_hand.books_collected = 3
=end







