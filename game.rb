# a game of checkers starts by initializing a 8X8 board of black and white. There are two sides. The red side and the white side.
# Each side has 12 pieces. All pieces are placed on the board when the board is initialized. The pieces only live on a black square.
# Only 3 rows of pieces are generated. When one side loses all its pieces the game is over.
# Pieces can move in 1 direction only and in 2 ways: sliding diagonally or jumping over an opponents piece. Pieces can jump multiple
# times if there exists such an opportunity. Pieces can turn into King pieces if they reach the otherside of the board. In that case,
#   they have the ability to perform the same methods but also backwards.
require 'colorize'
require './board.rb'

class Game
  def initialize
    @board = Board.new
    @turn_color = :blue
  end

  def play

    until over?
      puts @board
      take_turn(@turn_color)
      @turn_color = (@turn_color == :blue ? :red : :blue)
    end
  end

  def take_turn(turn_color)
    begin
      puts "#{turn_color}'s turn"
      puts "Please make a move: "
      position = gets.chomp.split(" ")

      if position.length == 2
        from_pos = convert(position[0])
        to_pos = convert(position[1])

        @board.move_piece(turn_color, from_pos, to_pos) if valid_input?(from_pos, to_pos)
      elsif position.length > 2
        sequence_pos = position.map! {|pos| convert(pos) }
        @board.jump_seq(turn_color, sequence_pos)
      end
    rescue StandardError => e
      puts "Error: #{e.message}"
      retry
    end
  end

  def convert(position)
    [8 - position[1].to_i, "abcdefgh".index(position[0])]
  end

  def valid_input?(from_pos, to_pos)
    if !from_pos.all? { |num| "01234567".include?(num.to_s) }
      raise "select a square with a piece"
    elsif !to_pos.all? { |num| "01234567".include?(num.to_s) }
      raise "can't move outside of board"
    elsif !@board[to_pos].nil?
      raise "there's a piece there."
    end
    true
  end

  def over?
    @board.over?
  end
end

if __FILE__ == $PROGRAM_NAME

g = Game.new
g.play
end

# e3 f4
# f6 e5
# g3 h4
# b6 a5
# d2 e3
# g7 f6
# e1 d2
# e5 g3 e1

