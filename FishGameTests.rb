require_relative 'FishDeck.rb'
require_relative 'FishHand.rb'
require_relative 'FishGame.rb'
require_relative 'FishPlayers.rb'

describe FishDeck do

	before(:all) do
    	@game = FishGame.new(5)
    	@deck = FishDeck.new
	end


	it "exists and has 52 shuffled cards" do							#GOOD
		@game.class.should_not eq(nil)
		@deck.class.should_not eq(nil)
		@deck.all_cards.should have(52).items
		#puts "all cards are:#{@deck.all_cards}"	#Shows cards are shuffled
	end

	it "returns one card popped off the top of the deck (array)" do		#GOOD
		@deck.pop_top_card
		@deck.all_cards.should have(51).items
	end


end	######THIS end is really, REALLEALLLY important.  It's the end of describe FishDeck do



describe FishHand do
 
 	before(:all) do

    	@game = FishGame.new(5)
    	@deck = FishDeck.new
	end


	it "exists" do
		
		@game.player[0].should_not eq(nil)
	end


	it "holds a player's cards dealt by the game" do

		@game.deal_to_players(@deck)
		@game.player[0].fish_hand.player_cards.should have(5).items
		@game.player[4].fish_hand.player_cards.should have(5).items
		#puts "Player[0] cards : #{@game.player[0].fish_hand.player_cards}"
		#puts "Player[4] cards : #{@game.player[4].fish_hand.player_cards}"
	end

	it "looks for books, deletes them, and update books collected" do
		@game.player[0].fish_hand.player_cards = %w(2 4 7 3 J 7 J 9 7 4 J 7 J)
		#puts "Player[0] cards : #{@game.player[0].fish_hand.player_cards}"
		
		@game.player[0].fish_hand.looks_for_books
		card_count = @game.player[0].fish_hand.player_cards.count
		
		@game.player[0].fish_hand.books_collected.should eq(2)
		card_count.should eq(13-8)

	
		@game.player[0].fish_hand.player_cards.should_not include("J")
		@game.player[0].fish_hand.player_cards.should_not include("7")
	end


	it "returns requested card and deletes from player card, else returns empty array (nil?)" do
		
		@game.player[0].fish_hand.player_cards = %w(2 3 K A K)
		requested_card = @game.player[0].fish_hand.return_cards_requested!("A")	#retreiving and deleting one cards
		@game.player[0].fish_hand.player_cards.should eq(%w(2 3 K K))
		requested_card.should eq(["A"])

		@game.player[1].fish_hand.player_cards = %w(2 3 K A K)
		@game.player[1].fish_hand.return_cards_requested!("K")	#retreving and deleting multiple cards
		@game.player[1].fish_hand.player_cards.should eq(%w(2 3 A))
	end



end



describe FishHand do
 
 	before(:all) do
    	@game = FishGame.new(5)
    	@deck = FishDeck.new
	end


	it "exists" do
		@game.class.should_not eq(nil)
	end

	it "initializes Hands" do
		
		@game.player[0].should_not eq(nil)
		@game.player[4].should_not eq(nil)
	end


	it "deals cards to hands" do

		@game.deal_to_players(@deck)
		@game.player[0].fish_hand.player_cards.should have(5).items
		@game.player[4].fish_hand.player_cards.should have(5).items
	end

	it "deletes all cards of a given rank from a player's cards" do
		@game.player[0].fish_hand.player_cards = %w(2 3 K A K 3 K)
		@game.player[0].fish_hand.delete_cards("K")
		@game.player[0].fish_hand.player_cards.should_not include("K")

	end

end



describe FishGame do

	before(:all) do
    	@game = FishGame.new(5)
    	@deck = FishDeck.new	#PUT THE DECK IN THE GAME
	end


	it "gives deck top card a specific hand and initiates finds book in that hand" do
		
		@game.player[0].fish_hand.player_cards = %w(3 5 7 3 7 8)	#initialized deck with 6 cards
		@game.deck_to_player(@deck, @game.player[0])
		
		@deck.all_cards.size.should eq(51)	#one came off the deck
		@game.player[0].fish_hand.player_cards.size.should eq(7)	#and was added to player_cards

	end

	it "gives deck top card a specific hand and finds books" do
		@deck = FishDeck.new
		@deck.all_cards.delete("5")	#Deletes all 5s from deck for last test
		@game.player[0].fish_hand.player_cards = %w(5 5 5 3 5 8)	#initialized deck with 6 cards with one
		@game.deck_to_player(@deck, @game.player[0])
		
		@deck.all_cards.size.should eq(47)	#one came off the a deck of 48 cards
		@game.player[0].fish_hand.player_cards.size.should eq(3)	#and was added to player_cards (after the book of 5 was deleted)
		@game.player[0].fish_hand.player_cards.should_not include("5")

	end


	it "takes a card of rank x from player_y to player_z" do

		@game.player[0].fish_hand.player_cards = %w(2 3 5 K A J)
		@game.player[1].fish_hand.player_cards = %w(4 6 A Q J 9)
		
		@game.player_to_player(@deck, "Q", @game.player[1], @game.player[0])

		@game.player[0].fish_hand.player_cards.size.should eq(7)
		@game.player[1].fish_hand.player_cards.size.should eq(5)

		#puts "player asked cards: #{@game.player[1].fish_hand.player_cards}"
		#puts "player asking cards #{@game.player[0].fish_hand.player_cards}"
	end


	it "takes two or more cards of rank x from player_y to player_z" do

		@game.player[0].fish_hand.player_cards = %w(2 3 5 K A K)
		@game.player[1].fish_hand.player_cards = %w(4 6 A Q J Q)

		@game.player_to_player(@deck, "Q", @game.player[1], @game.player[0])

		@game.player[0].fish_hand.player_cards.size.should eq(8)
		@game.player[1].fish_hand.player_cards.size.should eq(4)
		#puts "Cards for player 0 #{@game.player[0].fish_hand.player_cards}"	
	end

	it "takes finds no card x from player_y to player_z" do
		@game.player[0].fish_hand.player_cards = %w(2 3 5 K A J)
		@game.player[1].fish_hand.player_cards = %w(4 6 A Q J 9)
		
		@game.player_to_player(@deck, "3", @game.player[1], @game.player[0])

		@game.player[0].fish_hand.player_cards.size.should eq(7)
		@game.player[1].fish_hand.player_cards.size.should eq(6)	
	end


	it "player_to_player does not find and cards of rank x from player_y to player_z" do

		@game.player[0].fish_hand.player_cards = %w(2 3 5 K A J)
		@game.player[1].fish_hand.player_cards = %w(4 6 A Q J 9)
		
		@game.player_to_player(@deck, "7", @game.player[0], @game.player[1])

		@game.player[0].fish_hand.player_cards.size.should eq(6)
		@game.player[1].fish_hand.player_cards.size.should eq(7)	
	
	end


end

