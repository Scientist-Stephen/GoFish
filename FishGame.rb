require_relative 'FishDeck.rb'
require_relative 'FishHand.rb'
require_relative 'FishPlayers.rb'


class FishGame

	attr_accessor :player
	#attr_accessor :player2
	#attr_accessor :player3
	#attr_accessor :player4
	#attr_accessor :player5
	attr_accessor :top_card_container, :turn, :winner_message, :player_to_player_result	#next turn stores who's turn it is next
													#How will I use that with the server?

	def initialize(number_of_fish_players) 	
		@player = []
		@turn = 0
		@winner_message = "Initialization message."
		@player_to_player_result = "DEFAULT MESSAGE"

		i = 0	##Revise so i can be 0?
		number_of_fish_players.times do #like 5.times do
		#puts "iteration i is: #{i}"	
			@player[i] = FishPlayer.new	#Revise to PLAYER CLASS
			i += 1
		end
		@max_turns = (@player.size - 1)
		#puts "PLAYER ARRAY: #{@player}"
		#puts "players 0: #{@player[0].player_hand.player_cards}, players 1: #{@player[1]}"
	end

	def deal_to_players(deck_name)	
		5.times do
			@player.each do |player_x|
				top_card = deck_name.pop_top_card
				player_x.fish_hand.player_cards << top_card
			end
		end
	end

	def deck_to_player(game_deck, player_to)
	
		player_to.fish_hand.player_cards << top_card_container = game_deck.pop_top_card
		#Pops top deck card and shovels onto player_to 's cards
		player_to.fish_hand.looks_for_books
	end


	def player_to_player(game_deck, wanted_card, player_asked, player_asking)	#cards go FROM player_asked TO player_asking (or from the deck to player_asking)

		card_holder = player_asked.fish_hand.return_cards_requested(wanted_card)	#player in game's return card method and stores
		#puts "card holder[0] is: #{card_holder[0]}"
		#puts "wanted card is #{wanted_card}"

		if card_holder[0] == wanted_card	#element 0 will be the wanted_card or hold nothing
			player_asked.fish_hand.delete_cards(wanted_card)
			player_asking.fish_hand.player_cards.concat(card_holder)
			card_holder.clear
			player_asking.fish_hand.looks_for_books

			@player_to_player_result = "Player received Wanted Cards"
			
		else
			@player_to_player_result = "Player had to take a card from the deck"
			card_from_deck = deck_to_player(game_deck, player_asking)
			player_asking.fish_hand.looks_for_books###--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--!!--
			
			if card_from_deck == wanted_card 
				#do nothing					
				@player_to_player_result = "Player got the card he wanted from the deck."
			else
				if @turn < @max_turns
					@turn += 1
					
				else
					@turn = 0
				end
			end
		end
	end

	def has_books_check(game_deck)

	end


	def game_won?(game_deck, game_name)	#####METHOD TO SEE IF THERE IS A WINNER

		books_check = 0
		is_empty = false
		index_of_winner = nil
		#is_empty = player.fish_hand.player_cards.empty?

			game_name.player.each do |player|  #look to see if ANY PLAYERS have books > 0
				books_check = books_check + player.fish_hand.books_collected
				index_of_winner = game_name.player.index(player)
			end
#		puts "book check after each loop and before if: #{books_check}"

		game_name.player.each do |player|  #look to see if ANY PLAYERS have books > 0
			
			if player.fish_hand.player_cards.empty?
				is_empty = true
				index_of_winner = game_name.player.index(player)  
			end
		end


		if game_deck.all_cards.empty? == true && books_check == 0	#No winners case
			
			@winner_message = "The deck is empty and no players have any books.  The game has ended with NO winners."
			return true

		elsif is_empty == true	#Case for if player has NO CARDS LEFT

			
			@winner_message = "player #{index_of_winner + 1} has eliminated all cards from his hand, thereby winning the game!"
			return true

		elsif game_deck.all_cards.empty? == true && books_check > 0 && books_check < 7 #Deck empty/Most books winner
			most_decks = 0
			biggest = 0

				game_name.player.each do |player|  #look to see if ANY PLAYERS have books > 0
					challenger = player.fish_hand.books_collected
		
					if challenger > biggest

						most_decks = game_name.player.index(player)  #SHOULD eval to 0, 1, etc.
					end
					#puts "MOST DECKS after challenger > biggest: #{most_decks}"
				end
			@winner_message = "The deck is empty and player #{most_decks + 1} has the most books, and thereby has won."	
			#puts "Game Deck Empty AND book_check > 1"
			#puts "Most decks is now #{most_decks}"
			return true

		elsif books_check >= 7  #Case for one player having over half the books


			@winner_message = "player #{index_of_winner + 1} has gained more than half of the available books, having a total of #{books_check} books.  He has won the game."
			return true

		else

			#Game is not over
			return false
		end
		puts "Winner message: #{@winner_message}"
	end




















	
end
