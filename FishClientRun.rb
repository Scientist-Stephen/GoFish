require 'socket'
require 'rspec'
require 'json'
require_relative 'FishDeck.rb'
require_relative 'FishHand.rb'
require_relative 'FishGame.rb'
require_relative 'FishPlayers.rb'
require_relative 'FishServer.rb'
require_relative 'FishClient.rb'

client = ClientClass.new('localhost', 2012)



while true
#	puts "IN WHILE TRUE!!!"
	incoming = ""
	incoming = client.socket.gets.chomp
	#puts "incoming with a p"
	#p incoming




	client.input_decision(incoming)
	if client.server_closed == true
		break		
	end
end

client.close
