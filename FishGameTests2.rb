require_relative 'FishDeck.rb'
require_relative 'FishHand.rb'
require_relative 'FishGame.rb'
require_relative 'FishPlayers.rb'


describe FishGame do 

	before do
		@fish_game = FishGame.new(3)
		@deck = FishDeck.new
		@fish_game.deal_to_players(@deck)

	end

	after do	
	end
#=begin
	it "checks for player books and finds none" do
		@fish_game.player[0].fish_hand.books_collected = 0
		@fish_game.player[1].fish_hand.books_collected = 0
		@fish_game.player[2].fish_hand.books_collected = 0

		book_sum = @fish_game.players_have_books(@fish_game)
		book_sum.should eq(nil)
	end

	it "checks for player books and finds 1" do
		@fish_game.player[0].fish_hand.books_collected = 0
		@fish_game.player[1].fish_hand.books_collected = 1
		@fish_game.player[2].fish_hand.books_collected = 0

		book_sum = @fish_game.players_have_books(@fish_game)
		book_sum.should eq(1)


		@fish_game.player[0].fish_hand.books_collected = 0
		@fish_game.player[1].fish_hand.books_collected = 1
		@fish_game.player[2].fish_hand.books_collected = 3

		book_sum = @fish_game.players_have_books(@fish_game)
		book_sum.should be > 3
	end

	it "checks for player books and finds more than 1" do
		@fish_game.player[0].fish_hand.books_collected = 0
		@fish_game.player[1].fish_hand.books_collected = 1
		@fish_game.player[2].fish_hand.books_collected = 3

		book_sum = @fish_game.players_have_books(@fish_game)
		book_sum.should be > 3
	end


	it "returns index of most books when players have no books" do 
		@fish_game.player[0].fish_hand.books_collected = 0
		@fish_game.player[1].fish_hand.books_collected = 0
		@fish_game.player[2].fish_hand.books_collected = 0

		most_books = @fish_game.return_book_winner_index(@fish_game)
		most_books.should eq(nil)
	end


	it "returns index of player with most books when player(s) have books" do 
		@fish_game.player[0].fish_hand.books_collected = 3
		@fish_game.player[1].fish_hand.books_collected = 1
		@fish_game.player[2].fish_hand.books_collected = 2

		most_books = @fish_game.return_book_winner_index(@fish_game)
		most_books.should eq(0)

		@fish_game.player[0].fish_hand.books_collected = 3
		@fish_game.player[1].fish_hand.books_collected = 1
		@fish_game.player[2].fish_hand.books_collected = 5

		most_books = @fish_game.return_book_winner_index(@fish_game)
		most_books.should eq(2)
	end

	it "returns false if all players have cards" do 
	
		@fish_game.player[0].fish_hand.player_cards = %w(2)
		@fish_game.player[1].fish_hand.player_cards = %w(3 6 9 J A)
		@fish_game.player[2].fish_hand.player_cards = %w(2 5)

		cards_available = @fish_game.players_hand_empty?(@fish_game)
		cards_available.should eq(false)
	end

	it "returns true if any players have 0 cards" do 
	
		@fish_game.player[0].fish_hand.player_cards = %w()
		@fish_game.player[1].fish_hand.player_cards = %w(3 6 9 J A)
		@fish_game.player[2].fish_hand.player_cards = %w(K J Q 2 5)

		cards_available = @fish_game.players_hand_empty?(@fish_game)
		cards_available.should eq(true)

		@fish_game.player[0].fish_hand.player_cards = %w(K J)
		@fish_game.player[1].fish_hand.player_cards = %w(3 6 9 J A)
		@fish_game.player[2].fish_hand.player_cards = %w()

		cards_available = @fish_game.players_hand_empty?(@fish_game)
		cards_available.should eq(true)
	end

	it "returns the number of books the player with the most books has (case, no players have any books)" do
		@fish_game.player[0].fish_hand.books_collected = 0
		@fish_game.player[1].fish_hand.books_collected = 0
		@fish_game.player[2].fish_hand.books_collected = 0

		lead_player_most_books = @fish_game.lead_player_books(@fish_game)
		lead_player_most_books.should eq(0)
	end

	it "returns the number of books the player with the most books has (last player most books" do
		@fish_game.player[0].fish_hand.books_collected = 3
		@fish_game.player[1].fish_hand.books_collected = 1
		@fish_game.player[2].fish_hand.books_collected = 5

		lead_player_most_books = @fish_game.lead_player_books(@fish_game)
		lead_player_most_books.should eq(5)			
	end

	it "returns the number of books the player with the most books has (first player most books" do
		@fish_game.player[0].fish_hand.books_collected = 4
		@fish_game.player[1].fish_hand.books_collected = 0
		@fish_game.player[2].fish_hand.books_collected = 2

		lead_player_most_books = @fish_game.lead_player_books(@fish_game)
		lead_player_most_books.should eq(4)			
	end

	it "returns nil for player array index for most books when no players have any books" do
		@fish_game.player[0].fish_hand.books_collected = 0
		@fish_game.player[1].fish_hand.books_collected = 0
		@fish_game.player[2].fish_hand.books_collected = 0

		most_books_index = @fish_game.return_book_winner_index(@fish_game)
		most_books_index.should eq(nil)
	end

	it "returns player array index for player with the most books, case that first player has most books" do
		@fish_game.player[0].fish_hand.books_collected = 3
		@fish_game.player[1].fish_hand.books_collected = 0
		@fish_game.player[2].fish_hand.books_collected = 1

		most_books_index = @fish_game.return_book_winner_index(@fish_game)
		most_books_index.should eq(0)
	end

		it "returns player array index for player with the most books, case that last player has most books" do
		@fish_game.player[0].fish_hand.books_collected = 3
		@fish_game.player[1].fish_hand.books_collected = 1
		@fish_game.player[2].fish_hand.books_collected = 4

		most_books_index = @fish_game.return_book_winner_index(@fish_game)
		most_books_index.should eq(2)
	end

	

























end

