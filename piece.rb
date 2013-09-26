class Piece
  attr_accessor :color, :king

  DIR = [[-1,-1], [-1,1], [-2,-2], [-2,2], [1,-1], [1,1], [2,-2], [2,2]] #normal dir is the first 4, king is all

  def initialize(board, color)
    @board = board
    @color = color
    @display_char = ([9865].pack('U*'))
    @king = false
  end

  def to_s
    @display_char = (@king ? [9818].pack('U*') : [9865].pack('U*'))
    @display_char.send(@color)
  end

  def moves
    piece_color = (@color == :blue ? 0 : 4)
    return DIR if @king
    DIR[piece_color..piece_color+3]
  end
end