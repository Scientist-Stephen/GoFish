require_relative 'FishDeck.rb'
require_relative 'FishHand.rb'
require_relative 'FishGame.rb'


#Creates player hand and stores their corresponding client socket#

class FishPlayer
	
	attr_accessor :socket_number
	attr_reader :fish_hand 

	def initialize 
		@socket_number
		@fish_hand = FishHand.new	#Holds Cards for player
	end

end

