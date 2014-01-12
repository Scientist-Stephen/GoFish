require_relative 'FishDeck.rb'
require_relative 'FishGame.rb'
require_relative 'FishPlayers.rb'

class FishHand

	attr_accessor :player_cards, :books_collected

	def initialize
		@player_cards = []	#Holds a player's cards
		@books_collected = 0
	end

	def looks_for_books	#Delete books from hand and store # of books collected

		look_for = %w(2 3 4 5 6 7 8 9 10 J Q K A)	#do each of these
		
		look_for.each do |card_searching_for|
		
			card_density = @player_cards.select{|card_in_array| card_searching_for == card_in_array}.size	#This will take a card in the array, put it in card_in_array, compare it to card_search_for, and move on to the next card 		
			
			if card_density == 4
				@player_cards.delete(card_searching_for)	#Delete books found
				@books_collected += 1 						#Store 
			end		
		end
	end

	def return_cards_requested!(requested_card)	#Destructive
		#puts "requested card is #{requested_card}"
		
		card_wanted = @player_cards.select{|card| requested_card == card}
				#puts "CARD WANTED  in RETURN CARDS REQUESTED = #{card_wanted}"
		@player_cards.delete(requested_card)	#Could I just one-line this with .keep_if?  (I'm not sure)
		return card_wanted
	end


	def return_cards_requested(requested_card)	#Non-destructive
	
		card_wanted = @player_cards.select{|card| requested_card == card}
		return card_wanted
	end	

	def delete_cards(card_type)	#deletes all cards of a given rank from @player_cards
		@player_cards.delete(card_type)
	end

end

=begin
	


	

=end
