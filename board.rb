require './piece.rb'

class Board
  attr_accessor :board_map

  def initialize
    create_board
  end

  def create_board
    @board_map = Array.new(8) { Array.new(8) }
    color = :red
    @board_map.each_index do |row|
      next if row == 3 || row == 4
      color = :blue if row > 4
      @board_map[row].each_index { |sq_idx| @board_map[row][sq_idx] = Piece.new(self, color) if (sq_idx + row).odd? }
    end
    @board_map
  end

  def to_s
    board_str = "\n"
    @board_map.each_index do |row_idx|
      board_str += "#{8-row_idx}".light_white
      @board_map.each_index do |col_idx|
        if (row_idx + col_idx) % 2 == 0
          board_str += (self[[row_idx, col_idx]].to_s + " ")
        else
          board_str += (self[[row_idx, col_idx]].to_s.on_white + " ".on_white)
        end
      end
      board_str += "\n"
    end
    board_str += "  a b c d e f g h\n".light_white
    board_str
  end

  def over?
    return true if board.all? { |piece| piece.color == :red || piece.color == :nil }
    return true if board.all? { |piece| piece.color == :blue || piece.color == :nil }
    false
  end

  def board
    @board_map.flatten
  end

  def empty?(pos)
    @board_map[pos[0]][pos[1]].nil?
  end

  def [](pos)
    @board_map[pos[0]][pos[1]]
  end

  def []=(to_pos, piece)
    x, y = to_pos
    @board_map[x][y] = piece
  end

  def jump_seq(turn_color, sequence_pos)
    dup_sequence_pos = sequence_pos.dup
    until dup_sequence_pos.length == 1
      move_piece(turn_color, dup_sequence_pos.shift, dup_sequence_pos[0])
    end
  end

  def move_piece(turn_color, from_pos, to_pos)

    raise "from pos is empty" if empty?(from_pos)
    move_diff = [to_pos[0]-from_pos[0], to_pos[1]-from_pos[1]]
    piece = self[from_pos]
    if piece.color != turn_color
      raise "move your own piece"
    elsif !piece.moves.include?(move_diff)
      raise "piece can't move like that"
    end
    move_piece!(from_pos, to_pos, move_diff)
    make_king(piece, to_pos)
    return move_diff.any? { |num| num.even? } # return if the player made a successful jump move
  end

  def move_piece!(from_pos, to_pos, move_diff)
    if move_diff.any? { |num| num.even? }
      # this is a jump move
      self[[move_diff[0]/2+from_pos[0], move_diff[1]/2+from_pos[1]]] = nil if jump_valid?(from_pos, move_diff)
    end
    # this is a normal move
    self[to_pos] = self[from_pos]
    self[from_pos] = nil
  end

  def make_king(piece, to_pos)
    ending_row = (piece.color == :blue ? 0 : 7)
    piece.king = true if to_pos[0] == ending_row
  end

  def jump_valid?(from_pos, move_diff)
    middle_sq = [from_pos[0]+move_diff[0]/2, from_pos[1]+move_diff[1]/2]
    !self[middle_sq].nil?
  end
end

class NilClass

  def to_s
    " "
  end

  def color
    :nil
  end
end