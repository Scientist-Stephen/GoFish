require_relative 'FishPlayers.rb'

class FishDeck

	attr_accessor :all_cards
	
	def initialize
		@all_cards = []
		cards_just_rank = %w(2 3 4 5 6 7 8 9 10 J Q K A)	#Values for cards
		
		4.times do
			cards_just_rank.each do |card2array|
				@all_cards << card2array
				@all_cards.shuffle!
			end
		end
	end

	def pop_top_card
		@all_cards.pop		
	end



end
